defmodule CKEditor5.Cloud.CKBox do
  @moduledoc """
  Represents the CKBox configuration for a CKEditor 5 preset.
  """

  import Norm

  alias CKEditor5.{Errors, Helpers}

  @derive Jason.Encoder
  @enforce_keys [:version]
  @type t :: %__MODULE__{
          version: String.t(),
          theme: String.t() | nil
        }

  defstruct [
    :version,
    theme: nil
  ]

  @doc """
  Defines the schema for a raw CKBox configuration map.
  """
  def s do
    schema =
      schema(%{
        version: spec(is_binary() and (&Helpers.is_semver_version?/1)),
        theme: spec(is_binary())
      })

    selection(schema, [:version])
  end

  @doc """
  Parses a map into a CKBox struct.
  Returns {:ok, %CKBox{}} if valid, {:error, reason} if invalid.
  """
  def parse(nil), do: {:ok, nil}

  def parse(map) when is_map(map) do
    case conform(map, s()) do
      {:ok, _} -> {:ok, struct(__MODULE__, map)}
      {:error, errors} -> {:error, errors}
    end
  end

  def parse(_), do: {:error, "CKBox configuration must be a map or nil"}

  @doc """
  Parses a map into a CKBox struct.
  Returns %CKBox{} if valid, raises an error if invalid.
  """
  def parse!(ckbox_data) do
    case parse(ckbox_data) do
      {:ok, ckbox} -> ckbox
      {:error, reason} -> raise Errors.InvalidCloudConfiguration, reason: reason
    end
  end

  @doc """
  Merges the current CKBox configuration with the provided overrides.
  """
  def merge(nil, nil), do: nil

  def merge(nil, overrides) when is_map(overrides) do
    case parse(overrides) do
      {:ok, ckbox} -> ckbox
      {:error, _} -> nil
    end
  end

  def merge(_, nil), do: nil

  def merge(ckbox, %__MODULE__{} = override_struct),
    do: merge(ckbox, Map.from_struct(override_struct))

  def merge(%__MODULE__{} = ckbox, overrides) when is_map(overrides) do
    %__MODULE__{
      version: Map.get(overrides, :version, ckbox.version),
      theme: Map.get(overrides, :theme, ckbox.theme)
    }
  end
end
