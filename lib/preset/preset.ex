defmodule CKEditor5.Preset do
  @moduledoc """
  Represents a CKEditor 5 preset configuration.
  """

  alias CKEditor5.Cloud
  alias CKEditor5.License

  @derive {Jason.Encoder, only: [:type, :config, :license]}
  @enforce_keys [:config]

  defstruct [
    :config,
    type: :classic,
    cloud: nil,
    license: License.gpl()
  ]

  @doc """
  Merges the current preset configuration with the provided overrides.
  """
  def merge(%__MODULE__{} = preset, overrides) when overrides in [nil, %{}] do
    preset
  end

  def merge(%__MODULE__{} = preset, overrides) when is_map(overrides) do
    %__MODULE__{
      type: overrides[:type] || preset.type,
      config: Map.merge(preset.config || %{}, overrides[:config] || %{}),
      license: overrides[:license] || preset.license,
      cloud: merge_cloud(preset.cloud, overrides[:cloud])
    }
  end

  defp merge_cloud(preset_cloud, nil), do: preset_cloud

  defp merge_cloud(preset_cloud, overrides_cloud) when is_map(overrides_cloud) do
    base_cloud = preset_cloud || %Cloud{}

    Cloud.merge(base_cloud, overrides_cloud)
  end

  @doc """
  Checks if the preset has a Cloud configuration.
  Returns true if the cloud field is not nil, false otherwise.
  """
  def configured_cloud?(%__MODULE__{cloud: cloud}), do: cloud != nil
end
