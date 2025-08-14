defmodule CKEditor5.Test.ContextsHelper do
  @moduledoc """
  Specialized helper for managing :ckeditor5_phoenix, :contexts Application env in tests.
  """

  @app :ckeditor5_phoenix
  @key :contexts

  @doc """
  Sets the contexts env to the given value, returning the previous value.
  """
  def put_contexts_env(new_contexts) do
    original = Application.get_env(@app, @key, %{})
    Application.put_env(@app, @key, new_contexts)
    original
  end

  @doc """
  Restores the contexts env to the given value.
  """
  def restore_contexts_env(original_contexts) do
    Application.put_env(@app, @key, original_contexts)
  end
end
