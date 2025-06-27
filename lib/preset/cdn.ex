defmodule CKEditor5.Preset.CDN do
  @moduledoc """
  Represents the CDN configuration for a CKEditor 5 preset.
  """

  import Norm

  @default_editor_version Mix.Project.config()[:cke][:default_cdn_editor_version]

  @derive Jason.Encoder
  defstruct version: @default_editor_version,
            premium: false

  @doc """
  Defines the schema for a raw CDN configuration map.
  """
  def s do
    schema(%{
      version: spec(is_binary() and fn v -> String.match?(v, ~r/^\d+\.\d+\.\d+$/) end),
      premium: spec(is_boolean())
    })
  end

  @doc """
  Returns default values for CDN configuration.
  """
  def defaults do
    %{
      version: @default_editor_version,
      premium: false
    }
  end

  @doc """
  Parses a map into a CDN struct.
  Returns {:ok, %CDN{}} if valid, {:error, reason} if invalid.
  """
  def parse(nil), do: {:ok, nil}

  def parse(map) when map == %{}, do: {:ok, struct(__MODULE__, defaults())}

  def parse(map) when is_map(map) do
    case conform(map, s()) do
      {:ok, _} -> {:ok, build_struct(map)}
      {:error, errors} -> {:error, errors}
    end
  end

  def parse(_), do: {:error, "CDN configuration must be a map or nil"}

  @doc """
  Parses a map into a CDN struct.
  Returns %CDN{} if valid, raises an error if invalid.
  """
  def parse!(cdn_data) do
    case parse(cdn_data) do
      {:ok, cdn} -> cdn
      {:error, reason} -> raise ArgumentError, "Invalid CDN configuration: #{reason}"
    end
  end

  @doc """
  Builds a CDN struct with default values, allowing for overrides.
  """
  def build_struct(overrides \\ %{}) do
    defaults = defaults()

    %__MODULE__{
      version: Map.get(overrides, :version, defaults.version),
      premium: Map.get(overrides, :premium, defaults.premium)
    }
  end

  @doc """
  Merges the current CDN configuration with the provided overrides.
  """
  def merge(%__MODULE__{} = cdn, overrides) when is_map(overrides) do
    %__MODULE__{
      version: Map.get(overrides, :version, cdn.version),
      premium: Map.get(overrides, :premium, cdn.premium)
    }
  end
end
