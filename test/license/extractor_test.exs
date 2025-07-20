defmodule CKEditor5.License.ExtractorTest do
  use ExUnit.Case, async: true

  alias CKEditor5.Errors
  alias CKEditor5.License.Extractor
  alias CKEditor5.Test.LicenseGenerator

  describe "distribution_channel/1" do
    test "returns 'sh' for GPL license" do
      assert Extractor.distribution_channel("GPL") == {:ok, "sh"}
    end

    test "extracts distribution channel from a valid license key" do
      key = LicenseGenerator.generate_key("test-channel")
      assert Extractor.distribution_channel(key) == {:ok, "test-channel"}
    end

    test "returns error for a key with invalid format" do
      key = "invalidkey"
      assert Extractor.distribution_channel(key) == {:error, %Errors.InvalidLicenseKey{key: key}}
    end

    test "returns error for a key with invalid base64 payload" do
      key = "header.invalid_payload.signature"
      assert Extractor.distribution_channel(key) == {:error, %Errors.InvalidLicenseKey{key: key}}
    end

    test "returns error for a key with invalid json payload" do
      payload = "invalid-json" |> Base.url_encode64(padding: false)
      key = "header.#{payload}.signature"
      assert Extractor.distribution_channel(key) == {:error, %Errors.InvalidLicenseKey{key: key}}
    end
  end
end
