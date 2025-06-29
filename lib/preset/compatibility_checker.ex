defmodule CKEditor5.Preset.CompatibilityChecker do
  @moduledoc """
  Enforces business rules and compatibility constraints for CKEditor5 presets.
  Specifically handles Cloud service licensing requirements and configuration validation.
  """

  alias CKEditor5.{Errors, License, Preset}

  @doc """
  Checks if Cloud configuration is compatible with the preset's license key.
  Cloud services require a commercial license and cannot be used with GPL.

  Returns `{:ok, :valid}` if configuration is valid, `{:error, reason}` otherwise.
  """
  def check_cloud_compatibility(%Preset{cloud: nil}), do: {:ok, :valid}

  def check_cloud_compatibility(%Preset{cloud: _cloud} = preset) do
    if cloud_allowed?(preset) do
      {:ok, :valid}
    else
      {:error, %Errors.CloudRequiresCommercialLicense{preset: preset}}
    end
  end

  @doc """
  Ensures that a preset has Cloud configuration when required.
  """
  def ensure_cloud_configured!(%Preset{cloud: nil} = preset) do
    raise Errors.CloudNotConfigured, preset: preset
  end

  def ensure_cloud_configured!(%Preset{}), do: :ok

  @doc """
  Determines if the preset is allowed to use Cloud services based on its license.
  Cloud services are only available with commercial licenses (non-GPL).

  Returns `true` if Cloud usage is allowed, `false` otherwise.
  """
  def cloud_allowed?(%Preset{license: license}), do: License.cloud_distribution?(license)
end
