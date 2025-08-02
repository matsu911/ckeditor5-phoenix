defmodule CKEditor5.Preset.CustomTranslations do
  @moduledoc """
  Represents custom translations configuration for CKEditor5.
  """

  import Norm

  alias CKEditor5.Errors

  @derive Jason.Encoder
  @type t :: %__MODULE__{
          dictionary: %{String.t() => %{String.t() => String.t() | [String.t()]}}
        }

  defstruct dictionary: %{}

  @doc """
  Defines the schema for custom translations configuration.
  """
  def s do
    key_spec = one_of([spec(is_binary()), spec(is_atom())])
    translation_value_spec = one_of([spec(is_binary()), spec(is_list())])
    language_translations_spec = map_of(key_spec, translation_value_spec)

    map_of(key_spec, language_translations_spec)
  end

  @doc """
  Parses a map into a CustomTranslations struct.
  Returns {:ok, %CustomTranslations{}} if valid, {:error, reason} if invalid.
  """
  def parse(nil), do: {:ok, nil}

  def parse(map) when is_map(map) do
    case conform(map, s()) do
      {:ok, _} -> {:ok, %__MODULE__{dictionary: map}}
      {:error, errors} -> {:error, errors}
    end
  end

  def parse(_), do: {:error, "Custom translations must be a map or nil"}

  @doc """
  Parses a map into a CustomTranslations struct.
  Returns %CustomTranslations{} if valid, raises an error if invalid.
  """
  def parse!(translations_data) do
    case parse(translations_data) do
      {:ok, translations} ->
        translations

      {:error, reason} ->
        raise Errors.InvalidCustomTranslations,
          reason: "Invalid custom translations: #{inspect(reason)}"
    end
  end

  @doc """
  Merges two CustomTranslations structs or maps.
  """
  def merge(base, overrides) do
    base_dictionary = to_dictionary(base)
    overrides_dictionary = to_dictionary(overrides)

    case {base_dictionary, overrides_dictionary} do
      {nil, nil} -> nil
      {dict, nil} -> %__MODULE__{dictionary: dict}
      {nil, dict} -> %__MODULE__{dictionary: dict}
      {dict1, dict2} -> %__MODULE__{dictionary: merge_translation_maps(dict1, dict2)}
    end
  end

  # Merges translation maps with deep merging for language-specific translations
  defp merge_translation_maps(base, overrides) do
    Map.merge(base, overrides, fn _lang, base_lang_translations, override_lang_translations ->
      Map.merge(base_lang_translations, override_lang_translations)
    end)
  end

  defp to_dictionary(nil), do: nil
  defp to_dictionary(%__MODULE__{dictionary: dict}), do: dict
  defp to_dictionary(map) when is_map(map), do: map
end
