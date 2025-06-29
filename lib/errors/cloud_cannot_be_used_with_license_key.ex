defmodule CKEditor5.Errors.CloudCannotBeUsedWithLicenseKey do
  @moduledoc """
  Exception raised when Cloud cannot be used with the provided license key.
  """
  defexception [:license, :preset]

  @impl true
  def message(%{license: license}) do
    "Cloud cannot be used with the license key '#{license.key}'. Please use a license key that supports Cloud services."
  end
end
