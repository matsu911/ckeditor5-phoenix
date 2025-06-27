defmodule CKEditor5.Preset do
  @moduledoc """
  Represents a CKEditor 5 preset configuration.
  """

  alias CKEditor5.Preset.CDN

  @derive Jason.Encoder
  defstruct [
    :config,
    cdn: nil,
    license_key: "GPL"
  ]

  @doc """
  Merges the current preset configuration with the provided overrides.
  """
  def merge(%__MODULE__{} = preset, overrides) when overrides in [nil, %{}] do
    preset
  end

  def merge(%__MODULE__{} = preset, overrides) when is_map(overrides) do
    %__MODULE__{
      config: Map.merge(preset.config || %{}, overrides[:config] || %{}),
      license_key: overrides[:license_key] || preset.license_key,
      cdn: merge_cdn(preset.cdn, overrides[:cdn])
    }
  end

  defp merge_cdn(preset_cdn, nil), do: preset_cdn

  defp merge_cdn(preset_cdn, overrides_cdn) when is_map(overrides_cdn) do
    base_cdn = preset_cdn || %CDN{}

    CDN.merge(base_cdn, overrides_cdn)
  end
end
