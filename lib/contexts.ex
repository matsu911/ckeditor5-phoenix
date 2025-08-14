defmodule CKEditor5.Contexts do
  @moduledoc """
  Provides predefined configurations (contexts) for CKEditor 5.
  """

  use Memoize

  alias CKEditor5.{Config, Context, Errors, Helpers}

  @doc """
  Retrieves a context configuration by name.

  Returns `{:ok, context}` on success, or `{:error, reason}` on failure.
  """
  defmemo get(context_name) do
    all_contexts = contexts()

    with {:ok, context_config} <- Map.fetch(all_contexts, context_name),
         {:ok, context} <- Context.parse(context_config) do
      {:ok, context}
    else
      {:error, reason} ->
        {:error, %Errors.InvalidContext{reason: reason}}

      :error ->
        {:error,
         %Errors.ContextNotFound{
           context_name: context_name,
           available_contexts: Map.keys(all_contexts)
         }}
    end
  end

  @doc """
  Retrieves a context configuration by name, raising an exception on failure.
  """
  def get!(context_name) do
    case get(context_name) do
      {:ok, context} -> context
      {:error, reason} -> raise reason
    end
  end

  @doc """
  Returns all available contexts.
  """
  def contexts do
    Config.raw_contexts()
    |> Helpers.map_keys_to_strings()
    |> Map.new()
  end
end
