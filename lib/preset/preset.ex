defmodule CKEditor5.Preset do
  @moduledoc """
  Represents a CKEditor 5 preset configuration.
  """

  alias CKEditor5.Cloud

  @derive Jason.Encoder
  defstruct [
    :config,
    cloud: nil,
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
      cloud: merge_cloud(preset.cloud, overrides[:cloud])
    }
  end

  defp merge_cloud(preset_cloud, nil), do: preset_cloud

  defp merge_cloud(preset_cloud, overrides_cloud) when is_map(overrides_cloud) do
    base_cloud = preset_cloud || %Cloud{}

    Cloud.merge(base_cloud, overrides_cloud)
  end
end
