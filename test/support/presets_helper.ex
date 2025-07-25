defmodule CKEditor5.Test.PresetsHelper do
  @moduledoc """
  Specialized helper for managing :ckeditor5, :presets Application env in tests.
  """

  @app :ckeditor5
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
end
