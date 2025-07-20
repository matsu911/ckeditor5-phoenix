defmodule CKEditor5.Cloud do
  @moduledoc """
  Represents the Cloud configuration for a CKEditor 5 preset.
  """

  import Norm

  alias CKEditor5.{Errors, Helpers}

  @default_editor_version Mix.Project.config()[:cke][:default_cloud_editor_version]
  @derive Jason.Encoder
  @type t :: %__MODULE__{
          version: String.t(),
          premium: boolean(),
          translations: [String.t()],
          ckbox: String.t() | nil
        }

  defstruct version: @default_editor_version,
            premium: false,
            translations: [],
            ckbox: nil

  @doc """
  Defines the schema for a raw Cloud configuration map.
  """
  def s do
    schema(%{
      version: spec(is_binary() and (&Helpers.is_semver_version?/1)),
      premium: spec(is_boolean()),
      ckbox: spec(is_binary() and (&Helpers.is_semver_version?/1)),
      translations: coll_of(spec(is_binary))
    })
  end

  @doc """
  Returns default values for Cloud configuration.
  """
  def defaults do
    %{
      version: @default_editor_version,
      premium: false,
      translations: [],
      ckbox: nil
    }
  end

  @doc """
  Parses a map into a Cloud struct.
  Returns {:ok, %Cloud{}} if valid, {:error, reason} if invalid.
  """
  def parse(nil), do: {:ok, nil}

  def parse(map) when is_map(map) do
    case conform(map, s()) do
      {:ok, _} -> {:ok, build_struct(map)}
      {:error, errors} -> {:error, errors}
    end
  end

  def parse(_), do: {:error, "Cloud configuration must be a map or nil"}

  @doc """
  Parses a map into a Cloud struct.
  Returns %Cloud{} if valid, raises an error if invalid.
  """
  def parse!(cloud_data) do
    case parse(cloud_data) do
      {:ok, cloud} -> cloud
      {:error, reason} -> raise Errors.InvalidCloudConfiguration, reason: reason
    end
  end

  @doc """
  Builds a Cloud struct with default values, allowing for overrides.
  """
  def build_struct(overrides \\ %{}) do
    defaults = defaults()

    %__MODULE__{
      version: Map.get(overrides, :version, defaults.version),
      premium: Map.get(overrides, :premium, defaults.premium),
      translations: Map.get(overrides, :translations, defaults.translations),
      ckbox: Map.get(overrides, :ckbox, defaults.ckbox)
    }
  end

  @doc """
  Merges the current Cloud configuration with the provided overrides.
  """
  def merge(nil, overrides) when is_map(overrides) do
    build_struct(overrides)
  end

  def merge(%__MODULE__{}, nil), do: nil

  def merge(%__MODULE__{} = cloud, overrides) when is_map(overrides) do
    %__MODULE__{
      version: Map.get(overrides, :version, cloud.version),
      premium: Map.get(overrides, :premium, cloud.premium),
      translations: [Map.get(overrides, :translations, []) | cloud.translations],
      ckbox: Map.get(overrides, :ckbox, cloud.ckbox)
    }
  end
end
