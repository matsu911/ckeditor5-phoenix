defmodule CKEditor5.Preset.CloudCompatibilityChecker do
  @moduledoc """
  Enforces business rules and compatibility constraints for CKEditor5 presets.
  Specifically handles Cloud service licensing requirements and configuration validation.
  """

  alias CKEditor5.License.Assertions
  alias CKEditor5.{Cloud, Errors, Preset}

  @doc """
  Checks if the preset's Cloud configuration is valid based on the license type.
  """
  def handle_cloud_config(%Preset{cloud: _cloud, license: license} = preset) do
    cond do
      Assertions.compatible_cloud_distribution?(license) and !Preset.configured_cloud?(preset) ->
        {:ok, %{preset | cloud: %Cloud{}}}

      !Assertions.compatible_cloud_distribution?(license) and Preset.configured_cloud?(preset) ->
        {:error, %Errors.CloudCannotBeUsedWithLicenseKey{preset: preset, license: license}}

      true ->
        {:ok, preset}
    end
  end

  @doc """
  Ensures that a preset has Cloud configuration when required.
  """
  def ensure_cloud_configured!(%Preset{cloud: nil} = preset) do
    raise Errors.CloudNotConfigured, preset: preset
  end

  def ensure_cloud_configured!(%Preset{}), do: :ok
end
