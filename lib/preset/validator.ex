defmodule CKEditor5.Preset.Validator do
  @moduledoc """
  Validates CKEditor5 preset configurations.
  Ensures that the configuration adheres to the expected schema and constraints.
  """

  import Norm

  alias CKEditor5.Preset
  alias CKEditor5.Preset.CDN
  alias CKEditor5.Preset.License

  @doc """
  Defines the schema for a preset configuration map.
  """
  def s do
    schema =
      schema(%{
        cdn: CDN.s(),
        license_key: spec(is_binary()),
        config: spec(is_map())
      })

    selection(schema, [:config, :license_key])
  end

  @doc """
  Parses and validates a plain map into a CKEditor5 preset configuration.
  Returns {:ok, %Preset{}} if valid, {:error, errors} if invalid.
  """
  def parse(preset_map) when is_map(preset_map) do
    with {:ok, _} <- conform(preset_map, s()),
         {:ok, parsed_map} <- parse_cdn(preset_map),
         {:ok, preset} <- build_and_validate(parsed_map) do
      {:ok, preset}
    else
      {:error, errors} -> {:error, errors}
    end
  end

  @doc """
  Parses and validates a plain map into a CKEditor5 preset configuration.
  Returns %Preset{} if valid, raises an error if invalid.
  """
  def parse!(preset_map) do
    case parse(preset_map) do
      {:ok, preset} -> preset
      {:error, errors} -> raise ArgumentError, "Invalid preset configuration: #{inspect(errors)}"
    end
  end

  # Parses the CDN configuration from a map into a CDN struct.
  defp parse_cdn(preset_map) do
    with {:ok, cdn_struct} <- CDN.parse(preset_map[:cdn]) do
      {:ok, Map.put(preset_map, :cdn, cdn_struct)}
    end
  end

  # Builds a Preset struct from a parsed map and validates it with license constraints.
  defp build_and_validate(parsed_map) do
    preset = build_struct(parsed_map)

    case License.validate(preset) do
      {:ok, _} -> {:ok, preset}
      {:error, reason} -> {:error, reason}
    end
  end

  # Builds a Preset struct from a parsed map, setting default values.
  defp build_struct(parsed_map) do
    %Preset{
      config: parsed_map[:config] || %{},
      license_key: parsed_map[:license_key] || "GPL",
      cdn: parsed_map[:cdn]
    }
  end
end
