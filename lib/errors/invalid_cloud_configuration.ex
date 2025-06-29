defmodule CKEditor5.Errors.InvalidCloudConfiguration do
  @moduledoc """
  Exception raised when a Cloud configuration is invalid.
  """
  defexception [:reason]

  @impl true
  def message(exception) do
    "Invalid Cloud configuration: #{inspect(exception.reason)}"
  end
end
