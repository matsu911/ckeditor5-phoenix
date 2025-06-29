defmodule CKEditor5.Errors.CloudNotConfigured do
  @moduledoc """
  Exception raised when Cloud is not configured in the preset.
  """
  defexception [:preset]

  @impl true
  def message(_exception) do
    "Cloud is not configured in the used preset."
  end
end
