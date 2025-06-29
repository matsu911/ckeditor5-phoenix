defmodule CKEditor5.Errors.CloudRequiresCommercialLicense do
  @moduledoc """
  Exception raised when Cloud services are used with a GPL license.
  """
  defexception [:preset]

  @impl true
  def message(exception) do
    "Cloud services require a commercial license. Cannot be used with GPL license in preset '#{exception.preset.name}'."
  end
end
