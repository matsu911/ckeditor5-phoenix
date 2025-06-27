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
    System.get_env("CKEDITOR5_API_KEY") || "GPL"
  end

  @doc """
  Checks if the preset can use Cloud based on its license key.
  Returns true if the license key is not GPL, false otherwise.
  """
  def can_use_cloud?(%Preset{license_key: "GPL"}), do: false

  def can_use_cloud?(%Preset{license_key: _license}), do: true

  @doc """
  Validates that Cloud configuration is compatible with the license key.
  Cloud is only available commercially, so it cannot be used with GPL license.

  Returns {:ok, :valid} if valid, {:error, reason} if invalid.
  """
  def validate(%Preset{cloud: nil}), do: {:ok, :valid}

  def validate(%Preset{cloud: _cloud} = preset) do
    if can_use_cloud?(preset) do
      {:ok, :valid}
    else
      {:error, "Cloud cannot be provided when license_key is GPL"}
    end
  end
end
