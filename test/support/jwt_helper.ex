defmodule CKEditor5.Test.JwtHelper do
  @moduledoc """
  Test helper for generating JWT-like tokens for license key tests.
  """

  @doc """
  Generates a JWT-like string with a given payload.
  """
  def generate(payload) do
    encoded_payload = Jason.encode!(payload) |> Base.url_encode64(padding: false)

    "header.#{encoded_payload}.signature"
  end
end
