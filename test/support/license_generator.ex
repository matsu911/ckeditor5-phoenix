defmodule CKEditor5.Test.LicenseGenerator do
  @moduledoc """
  A helper module to generate license keys for testing purposes.
  """

  @doc """
  Generates a license key with the specified distribution channel.
  """
  def generate_key(distribution_channel \\ "sh") do
    encoded_payload =
      Jason.encode!(%{distributionChannel: distribution_channel})
      |> Base.url_encode64(padding: false)

    "header.#{encoded_payload}.signature"
  end
end
