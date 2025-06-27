defmodule CKEditor5.Preset.License do
  @moduledoc """
  Validates Cloud and license key dependencies for CKEditor5 presets.
  Ensures that Cloud configuration is compatible with the specified license.
  """

  alias CKEditor5.Preset

  @doc """
  Retrieves the license key from the environment variable
  """
  def get_from_env_or_fallback do
    System.get_env("CKEDITOR5_LICENSE_KEY") || "GPL"
  end

  @doc """
  Validates that Cloud configuration is compatible with the license key.
  Cloud is only available commercially, so it cannot be used with GPL license.

  Returns {:ok, :valid} if valid, {:error, reason} if invalid.
  """
  def validate(%Preset{cloud: nil}), do: {:ok, :valid}

  def validate(%Preset{cloud: _cloud} = preset) do
    if allows_cloud?(preset) do
      {:ok, :valid}
    else
      {:error, "Cloud cannot be provided when license_key is GPL"}
    end
  end

  @doc """
  Validates that Cloud configuration is compatible with the license key.
  Raises an error if the configuration is invalid.
  """
  def require_cloud!(%Preset{cloud: nil} = preset) do
    raise CKEditor5.CloudNotConfiguredError, preset: preset
  end

  def require_cloud!(%Preset{}), do: :ok

  @doc """
  Checks if the preset can use Cloud based on its license key.
  Returns true if the license key is not GPL, false otherwise.
  """
  def allows_cloud?(%Preset{license_key: "GPL"}), do: false

  def allows_cloud?(%Preset{license_key: _license}), do: true
end
