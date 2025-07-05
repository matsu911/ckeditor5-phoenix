defmodule CKEditor5.Errors.CloudCannotBeUsedWithLicenseKey do
  @moduledoc """
  Exception raised when Cloud cannot be used with the provided license key.
  """
  defexception [:license, :preset]

  alias CKEditor5.License

  @impl true
  def message(%{license: license}) do
    "Cloud cannot be used with the license key '#{License.format_key(license)}'. Please use a license key that supports Cloud Distribution Channel."
  end
end
