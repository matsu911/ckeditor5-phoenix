defmodule CKEditor5.License.Extractor do
  @moduledoc false

  alias CKEditor5.Errors

  @doc """
  Extracts distribution channel from license key.
  """
  def distribution_channel("GPL"), do: {:ok, "sh"}

  def distribution_channel(key) do
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
