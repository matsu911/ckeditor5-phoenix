defmodule CKEditor5.Test.PresetsHelper do
  @moduledoc """
  Specialized helper for managing :ckeditor5_phoenix, :presets Application env in tests.
  """

  @app :ckeditor5_phoenix
  @key :presets

  @doc """
  Sets the presets env to the given value, returning the previous value.
  """
  def put_presets_env(new_presets) do
    original = Application.get_env(@app, @key, %{})
    Application.put_env(@app, @key, new_presets)
    original
  end

  @doc """
  Restores the presets env to the given value.
  """
  def restore_presets_env(original_presets) do
    Application.put_env(@app, @key, original_presets)
  end

  @doc """
  Creates a default preset configuration.
  """
  def default_preset(key, opts \\ []) do
    Map.merge(
      %{
        license_key: key,
        config: %{},
        cloud: %{
          version: "40.0.0",
          premium: false,
          translations: ["pl"]
        }
      },
      Enum.into(opts, %{})
    )
  end
end
