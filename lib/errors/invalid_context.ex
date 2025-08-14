defmodule CKEditor5.Errors.InvalidContext do
  @moduledoc """
  Exception raised when a CKEditor5 context configuration is invalid.
  """

  defexception [:reason]

  @impl true
  def message(exception) do
    "Invalid context configuration: #{inspect(exception.reason)}"
  end
end
