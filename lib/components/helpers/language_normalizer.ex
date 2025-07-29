defmodule CKEditor5.Components.LanguageNormalizer do
  @moduledoc """
  Normalizes language codes for CKEditor integration.
  """

  @default_language "en"

  @doc """
  Normalizes the language code to a format suitable for CKEditor.
  If the language is nil, it defaults to "en".
  If the language is "en-us", it normalizes it to "en".
  """
  @spec normalize_language(nil) :: String.t()
  def normalize_language(nil), do: @default_language

  @spec normalize_language(String.t()) :: String.t()
  def normalize_language(language) do
    String.downcase(language)
    |> case do
      "en-us" -> "en"
      other -> other
    end
  end
end
