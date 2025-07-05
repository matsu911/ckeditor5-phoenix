defmodule CKEditor5.Errors.InvalidLicenseKey do
  @moduledoc """
  Exception raised when an invalid license key is provided.
  """
  defexception [:key]

  alias CKEditor5.License

  @impl true
  def message(exception) do
    "Invalid license key: '#{License.format_key(exception.key)}'. Please provide a valid CKEditor 5 license key."
  end
end
