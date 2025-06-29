defmodule CKEditor5.License do
  @moduledoc """
  Provides functionality to manage CKEditor 5 license keys.
  """

  use Memoize

  alias CKEditor5.Errors

  @env_license_key_name "CKEDITOR5_LICENSE_KEY"

  @derive {Jason.Encoder, only: [:key]}

  @enforce_keys [:key, :distribution_channel]
  defstruct [:key, :distribution_channel]

  @doc """
  Creates a new License struct with the given license key.
  Automatically extracts the distribution channel from the license key.
  Returns {:ok, %License{}} for valid keys or {:error, error} for invalid keys.
  """
  def new(%__MODULE__{} = license) do
    {:ok, license}
  end

  defmemo new(key) do
    case extract_distribution_channel(key) do
      {:error, error} ->
        {:error, error}

      {:ok, distribution_channel} ->
        {:ok,
         %__MODULE__{
           key: key,
           distribution_channel: distribution_channel
         }}
    end
  end

  @doc """
  Returns the default license key from environment variable or "GPL".
  """
  def env_license_or_gpl do
    case System.get_env(@env_license_key_name) do
      nil -> {:ok, gpl()}
      key -> new(key)
    end
  end

  @doc """
  Creates a new GPL license struct.
  This license is compatible with all distribution channels.
  """
  def gpl,
    do: %__MODULE__{
      key: "GPL",
      distribution_channel: "npm"
    }

  @doc """
  Checks if the license key is a GPL license.
  """
  def gpl?(%__MODULE__{key: "GPL"}), do: true

  def gpl?(%__MODULE__{}), do: false

  def gpl?("GPL"), do: true

  def gpl?(_), do: false

  @doc """
  Checks if the license is compatible with the given distribution channel.
  GPL licenses are compatible with all channels.
  """
  def distribution?(%__MODULE__{distribution_channel: nil}, _), do: true

  def distribution?(%__MODULE__{distribution_channel: channel}, channel), do: true

  def distribution?(%__MODULE__{}, _), do: false

  @doc """
  Checks if the license is for cloud distribution.
  """
  def cloud_distribution?(%__MODULE__{} = license), do: distribution?(license, "cloud")

  @doc """
  Checks if the license is for npm distribution.
  """
  def npm_distribution?(%__MODULE__{} = license), do: distribution?(license, "npm")

  # Extracts distribution channel for GPL license (returns nil)
  defp extract_distribution_channel("GPL"), do: {:ok, "npm"}

  # Extracts distribution channel from JWT license key
  # License key has three parts: header.payload.signature
  # Distribution channel is encoded in the payload as JSON
  defp extract_distribution_channel(key) do
    with parts when length(parts) == 3 <- String.split(key, "."),
         [_header, payload, _signature] <- parts,
         {:ok, decoded_payload} <- Base.url_decode64(payload, padding: false),
         {:ok, json} <- Jason.decode(decoded_payload) do
      {:ok, Map.get(json, "distributionChannel")}
    else
      _ -> {:error, %Errors.InvalidLicenseKey{key: key}}
    end
  end
end
