defmodule CKEditor5.Errors.InvalidPreset do
  @moduledoc """
  Exception raised when a CKEditor5 preset configuration is invalid.
  """
  defexception [:reason]

  @impl true
  def message(exception) do
    "Invalid preset configuration: #{inspect(exception.reason)}"
  end
end
