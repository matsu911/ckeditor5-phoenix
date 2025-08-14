defmodule CKEditor5.Errors.ContextNotFound do
  @moduledoc """
  Exception raised when a CKEditor5 context is not found.
  """
  defexception [:context_name, :available_contexts]

  @impl true
  def message(exception) do
    available = exception.available_contexts |> Enum.sort() |> Enum.join(", ")
    "Context '#{exception.context_name}' not found. Available contexts: #{available}"
  end
end
