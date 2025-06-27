defmodule CKEditor5.Preset.License do
  @moduledoc """
  Validates CDN and license key dependencies for CKEditor5 presets.
  Ensures that CDN configuration is compatible with the specified license.
  """

  alias CKEditor5.Preset

  @doc """
  Validates that CDN configuration is compatible with the license key.
  CDN is only available commercially, so it cannot be used with GPL license.

  Returns {:ok, :valid} if valid, {:error, reason} if invalid.
  """
  def validate(%Preset{license_key: "GPL", cdn: nil}), do: {:ok, :valid}

  def validate(%Preset{license_key: "GPL", cdn: _cdn}) do
    {:error, "CDN cannot be provided when license_key is GPL"}
  end

  def validate(%Preset{license_key: _license, cdn: _cdn}), do: {:ok, :valid}
end
