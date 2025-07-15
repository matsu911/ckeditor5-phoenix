defmodule CKEditor5.LicenseTest do
  use ExUnit.Case, async: true

  alias CKEditor5.Errors
  alias CKEditor5.License
  alias CKEditor5.Test.JwtHelper

  describe "new/1" do
    test "creates a license from a valid key" do
      key = JwtHelper.generate(%{"distributionChannel" => "test-channel"})

      assert {:ok, %License{key: ^key, distribution_channel: "test-channel"}} = License.new(key)
    end

    test "returns an error for an invalid key" do
      key = "invalidkey"
      assert {:error, %Errors.InvalidLicenseKey{key: ^key}} = License.new(key)
    end

    test "returns a GPL license" do
      assert {:ok, %License{key: "GPL", distribution_channel: "sh"}} = License.new("GPL")
    end

    test "accepts a license struct" do
      license = License.gpl()
      assert {:ok, ^license} = License.new(license)
    end
  end

  describe "gpl/0" do
    test "returns a GPL license" do
      assert %License{key: "GPL", distribution_channel: "sh"} = License.gpl()
    end
  end

  describe "env_license_or_gpl/0" do
    setup do
      env_key = "CKEDITOR5_LICENSE_KEY"
      original_value = System.get_env(env_key)

      on_exit(fn ->
        if original_value do
          System.put_env(env_key, original_value)
        else
          System.delete_env(env_key)
        end
      end)

      :ok
    end

    test "returns license from environment variable if set" do
      key = JwtHelper.generate(%{"distributionChannel" => "env-channel"})
      System.put_env("CKEDITOR5_LICENSE_KEY", key)

      assert {:ok, %License{key: ^key, distribution_channel: "env-channel"}} =
               License.env_license_or_gpl()
    end

    test "returns GPL license if environment variable is not set" do
      System.delete_env("CKEDITOR5_LICENSE_KEY")

      assert {:ok, %License{key: "GPL", distribution_channel: "sh"}} =
               License.env_license_or_gpl()
    end

    test "returns an error for an invalid key from environment variable" do
      key = "invalidkey"
      System.put_env("CKEDITOR5_LICENSE_KEY", key)
      assert {:error, %Errors.InvalidLicenseKey{key: ^key}} = License.env_license_or_gpl()
    end
  end

  describe "format_key/1" do
    test "returns the key if it is short" do
      license = %License{key: "short", distribution_channel: "sh"}
      assert License.format_key(license) == "short"
    end

    test "truncates a long key" do
      license = %License{key: "a_very_long_license_key", distribution_channel: "sh"}
      assert License.format_key(license) == "a_very_l..."
    end
  end
end
