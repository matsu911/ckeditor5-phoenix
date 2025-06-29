defmodule CKEditor5.Preset.Parser do
  @moduledoc """
  Parses CKEditor5 preset configurations.
  Ensures that the configuration adheres to the expected schema and constraints.
  """

  import Norm

  alias CKEditor5.{Cloud, Errors, License, Preset}
  alias CKEditor5.Preset.CompatibilityChecker

  @doc """
  Defines the schema for a preset configuration map.
  """
  def s do
    schema =
      schema(%{
        cloud: Cloud.s(),
        license_key: spec(is_binary()),
        config: spec(is_map())
      })

    selection(schema, [:config])
  end

  @doc """
  Parses and validates a plain map into a CKEditor5 preset configuration.
  Returns {:ok, %Preset{}} if valid, {:error, errors} if invalid.
  """
  def parse(preset_map) when is_map(preset_map) do
    with {:ok, _} <- conform(preset_map, s()),
         {:ok, parsed_map} <- parse_cloud(preset_map),
         {:ok, parsed_map} <- parse_license_key(parsed_map),
         {:ok, preset} <- build_and_validate(parsed_map) do
      {:ok, preset}
    else
      {:error, errors} -> {:error, errors}
    end
  end

  def parse(_), do: {:error, "Preset configuration must be a map"}

  @doc """
  Parses and validates a plain map into a CKEditor5 preset configuration.
  Returns %Preset{} if valid, raises an error if invalid.
  """
  def parse!(preset_map) do
    case parse(preset_map) do
      {:ok, preset} -> preset
      {:error, reason} -> raise Errors.InvalidPreset, reason: reason
    end
  end

  # Parses the license key from a map into a License struct.
  defp parse_license_key(preset_map) do
    license_result =
      case preset_map[:license_key] do
        nil -> License.env_license_or_gpl()
        key -> License.new(key)
      end

    case license_result do
      {:ok, license} ->
        preset_map
        |> Map.put(:license, license)
        |> Map.delete(:license_key)
        |> then(&{:ok, &1})

      {:error, error} ->
        {:error, error}
    end
  end

  # Parses the Cloud configuration from a map into a Cloud struct.
  defp parse_cloud(preset_map) do
    with {:ok, cloud_struct} <- Cloud.parse(preset_map[:cloud]) do
      {:ok, Map.put(preset_map, :cloud, cloud_struct)}
    end
  end

  # Builds a Preset struct from a parsed map and validates it with license constraints.
  defp build_and_validate(parsed_map) do
    preset = build_struct(parsed_map)

    case CompatibilityChecker.check_cloud_compatibility(preset) do
      {:ok, _} -> {:ok, preset}
      {:error, reason} -> {:error, reason}
    end
  end

  # Builds a Preset struct from a parsed map, setting default values.
  # It's map passed from configuration file or environment variables.
  defp build_struct(parsed_map) do
    %Preset{
      config: parsed_map[:config] || %{},
      license: parsed_map[:license],
      cloud: parsed_map[:cloud]
    }
  end
end
