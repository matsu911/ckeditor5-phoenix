defmodule CKEditor5.PresetTest do
  use ExUnit.Case, async: true

  alias CKEditor5.{Cloud, License, Preset}
  alias CKEditor5.Test.LicenseGenerator

  describe "of_type/2" do
    test "sets the type of the preset" do
      preset = %Preset{config: %{}}
      new_preset = Preset.of_type(preset, :inline)

      assert new_preset.type == :inline
    end
  end

  describe "merge/2" do
    setup do
      %{
        preset: %Preset{
          type: :classic,
          config: %{a: 1},
          license: License.gpl(),
          cloud: nil
        }
      }
    end

    test "merges with nil overrides", %{preset: preset} do
      assert Preset.merge(preset, nil) == preset
    end

    test "merges with empty map overrides", %{preset: preset} do
      assert Preset.merge(preset, %{}) == preset
    end

    test "merges with new overrides", %{preset: preset} do
      {:ok, license} = LicenseGenerator.generate_key() |> License.new()

      overrides = %{
        type: :inline,
        config: %{b: 2},
        license: license,
        cloud: %{version: "5.0.0"}
      }

      merged_preset = Preset.merge(preset, overrides)

      assert merged_preset.type == :inline
      assert merged_preset.config == %{a: 1, b: 2}
      assert merged_preset.license == license
      assert merged_preset.cloud.version == "5.0.0"
    end

    test "merges cloud configuration when base cloud is nil", %{preset: preset} do
      overrides = %{cloud: %{version: "5.0.0"}}
      merged_preset = Preset.merge(preset, overrides)

      assert merged_preset.cloud.version == "5.0.0"
    end

    test "merges cloud configuration when base cloud exists", %{preset: preset} do
      preset_with_cloud = %{preset | cloud: %Cloud{version: "4.0.0"}}
      overrides = %{cloud: %{version: "5.0.0"}}
      merged_preset = Preset.merge(preset_with_cloud, overrides)

      assert merged_preset.cloud.version == "5.0.0"
    end

    test "unsets cloud when override cloud is nil", %{preset: preset} do
      preset_with_cloud = %{preset | cloud: %Cloud{version: "4.0.0"}}
      overrides = %{cloud: nil}
      merged_preset = Preset.merge(preset_with_cloud, overrides)

      assert merged_preset.cloud == nil
    end

    test "merges with cloud hash override", %{preset: preset} do
      overrides = %{cloud: %{version: "5.0.0"}}
      merged_preset = Preset.merge(preset, overrides)

      assert is_struct(merged_preset.cloud, Cloud)
      assert merged_preset.cloud.version == "5.0.0"
    end

    test "merges with cloud struct override", %{preset: preset} do
      cloud_override = %Cloud{version: "6.0.0"}
      overrides = %{cloud: cloud_override}
      merged_preset = Preset.merge(preset, overrides)

      assert merged_preset.cloud == cloud_override
    end
  end

  describe "configured_cloud?/1" do
    test "returns false when cloud is not configured" do
      preset = %Preset{config: %{}, cloud: nil}
      refute Preset.configured_cloud?(preset)
    end

    test "returns true when cloud is configured" do
      preset = %Preset{config: %{}, cloud: %Cloud{}}
      assert Preset.configured_cloud?(preset)
    end
  end
end
