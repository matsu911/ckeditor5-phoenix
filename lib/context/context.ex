defmodule CKEditor5.Context do
  @moduledoc """
  Represents the CKEditor 5 context configuration.
  """

  import Norm

  alias CKEditor5.Errors

  @derive Jason.Encoder
  @enforce_keys [:config]
  @type t :: %__MODULE__{
          config: map()
        }

  defstruct config: %{
              plugins: []
            }

  @doc """
  Defines the schema for a raw Context configuration map.
  """
  def s do
    schema =
      schema(%{
        config: spec(is_map())
      })

    selection(schema, [:config])
  end

  @doc """
  Parses a map into a Context struct.
  Returns {:ok, %Context{}} if valid, {:error, reason} if invalid.
  """
  def parse(nil), do: {:ok, nil}

  def parse(%__MODULE__{} = context), do: {:ok, context}

  def parse(map) when is_map(map) do
    case conform(map, s()) do
      {:ok, _} -> {:ok, struct(__MODULE__, map)}
      {:error, errors} -> {:error, errors}
    end
  end

  def parse(_), do: {:error, "Context configuration must be a map or nil"}

  @doc """
  Parses a map into a Context struct.
  Returns %Context{} if valid, raises an error if invalid.
  """
  def parse!(data) do
    case parse(data) do
      {:ok, context} -> context
      {:error, reason} -> raise Errors.InvalidContext, reason: reason
    end
  end
end
