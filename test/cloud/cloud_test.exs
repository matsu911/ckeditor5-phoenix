defmodule CKEditor5.CloudTest do
  use ExUnit.Case, async: true

  alias CKEditor5.Cloud
  alias CKEditor5.Errors
  alias CKEditor5.Helpers

  @default_editor_version Mix.Project.config()[:cke][:default_cloud_editor_version]

  describe "s/0" do
    test "validates a correct cloud configuration map" do
      valid_config = %{
        version: "35.4.0",
        premium: true,
        ckbox: "35.4.0",
        translations: ["pl", "de"]
      }

      assert {:ok, _} = Norm.conform(valid_config, Cloud.s())
    end

    test "returns an error for an invalid version" do
      invalid_config = %{version: "35"}
      {:error, errors} = Norm.conform(invalid_config, Cloud.s())
      assert Enum.any?(errors, &(&1.path == [:version]))
    end

    test "returns an error for an invalid premium flag" do
      invalid_config = %{premium: "not_a_boolean"}
      {:error, errors} = Norm.conform(invalid_config, Cloud.s())
      assert Enum.any?(errors, &(&1.path == [:premium]))
    end

    test "returns an error for an invalid ckbox version" do
      invalid_config = %{ckbox: "invalid-version"}
      {:error, errors} = Norm.conform(invalid_config, Cloud.s())
      assert Enum.any?(errors, &(&1.path == [:ckbox]))
    end

    test "returns an error for invalid translations" do
      invalid_config = %{translations: ["pl", 123]}
      {:error, errors} = Norm.conform(invalid_config, Cloud.s())
      assert Enum.any?(errors, &(&1.path == [:translations, 1]))
    end
  end

  describe "defaults/0" do
    test "returns the default cloud configuration" do
      defaults = Cloud.defaults()

      assert defaults == %{
               version: @default_editor_version,
               premium: false,
               translations: [],
               ckbox: nil
             }
    end
  end

  describe "parse/1" do
    test "parses nil and returns {:ok, nil}" do
      assert Cloud.parse(nil) == {:ok, nil}
    end

    test "parses a valid map and returns a Cloud struct" do
      config = %{version: "36.0.0", premium: true, translations: ["pl"], ckbox: "36.0.0"}
      {:ok, cloud} = Cloud.parse(config)

      assert %Cloud{
               version: "36.0.0",
               premium: true,
               translations: ["pl"],
               ckbox: "36.0.0"
             } = cloud
    end

    test "returns an error for an invalid map" do
      assert {:error, _} = Cloud.parse(%{version: "invalid"})
    end

    test "returns an error for non-map data" do
      assert Cloud.parse("not a map") == {:error, "Cloud configuration must be a map or nil"}
    end
  end

  describe "parse!/1" do
    test "parses a valid map and returns a Cloud struct" do
      config = %{version: "36.0.0"}
      cloud = Cloud.parse!(config)
      assert cloud.version == "36.0.0"
    end

    test "raises an error for invalid data" do
      assert_raise Errors.InvalidCloudConfiguration, fn ->
        Cloud.parse!(%{version: "invalid"})
      end
    end
  end

  describe "build_struct/1" do
    test "builds a struct with default values when no overrides are given" do
      cloud = Cloud.build_struct()

      assert cloud.version == @default_editor_version
      assert cloud.premium == false
      assert cloud.translations == []
      assert cloud.ckbox == nil
    end

    test "builds a struct with given overrides" do
      overrides = %{version: "35.0.0", premium: true, translations: ["de"], ckbox: "35.0.0"}
      cloud = Cloud.build_struct(overrides)

      assert cloud.version == "35.0.0"
      assert cloud.premium == true
      assert cloud.translations == ["de"]
      assert cloud.ckbox == "35.0.0"
    end
  end

  describe "merge/2" do
    test "merges a cloud struct with overrides" do
      cloud = Cloud.build_struct(%{version: "35.0.0", translations: ["pl"]})
      overrides = %{version: "36.0.1", premium: true, translations: ["de"]}
      merged_cloud = Cloud.merge(cloud, overrides)

      assert merged_cloud.version == "36.0.1"
      assert merged_cloud.premium == true
      assert List.flatten(merged_cloud.translations) == ["de", "pl"]
      assert merged_cloud.ckbox == nil
    end
  end

  describe "Helpers.is_semver_version?/1" do
    test "returns true for valid semver versions" do
      assert Helpers.is_semver_version?("1.0.0")
      assert Helpers.is_semver_version?("10.20.30")
      assert Helpers.is_semver_version?("1.0.0-alpha.1")
      assert Helpers.is_semver_version?("1.0.0-nightly-20250715.0")
    end

    test "returns false for invalid semver versions" do
      refute Helpers.is_semver_version?("1.0")
      refute Helpers.is_semver_version?("1")
      refute Helpers.is_semver_version?("a.b.c")
      refute Helpers.is_semver_version?("1.0.0-")
    end
  end
end
