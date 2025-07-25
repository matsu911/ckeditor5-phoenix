defmodule CKEditor5.Components.Cloud.AssetsTest do
  use ExUnit.Case, async: true

  alias CKEditor5.Components.Cloud.Assets
  alias CKEditor5.Test.{LicenseGenerator, PresetsHelper}

  import Phoenix.LiveViewTest

  setup do
    cloud_license_key = LicenseGenerator.generate_key("cloud")
    original_config = PresetsHelper.put_presets_env(%{})

    on_exit(fn ->
      PresetsHelper.restore_presets_env(original_config)
    end)

    {:ok, cloud_license_key: cloud_license_key}
  end

  describe "render/1" do
    test "renders all cloud asset components for default preset", %{cloud_license_key: key} do
      preset = %{
        license_key: key,
        config: %{},
        cloud: %{
          version: "40.0.0",
          premium: false,
          translations: ["pl"]
        }
      }

      PresetsHelper.put_presets_env(%{"default" => preset})
      html = render_component(&Assets.render/1, preset: "default")

      assert html =~ "<script type=\"importmap\""
      assert html =~ "rel=\"stylesheet\""
      assert html =~ "rel=\"modulepreload\""
    end

    test "renders with nonce attribute for all asset tags", %{cloud_license_key: key} do
      preset = %{
        license_key: key,
        config: %{},
        cloud: %{
          version: "40.0.0",
          premium: false,
          translations: ["pl"]
        }
      }

      PresetsHelper.put_presets_env(%{"default" => preset})

      nonce = "test-nonce"
      html = render_component(&Assets.render/1, preset: "default", nonce: nonce)

      assert html =~ "nonce=\"test-nonce\""
    end

    test "renders premium features and CKBox assets if present", %{cloud_license_key: key} do
      ckbox_version = "1.2.3"

      preset = %{
        license_key: key,
        config: %{},
        cloud: %{
          version: "40.0.0",
          premium: true,
          translations: ["pl"],
          ckbox: %{
            version: ckbox_version,
            theme: "dark"
          }
        }
      }

      PresetsHelper.put_presets_env(%{"premium" => preset})
      html = render_component(&Assets.render/1, preset: "premium")

      assert html =~ "ckeditor5-premium-features"
      assert html =~ "ckbox/1.2.3/ckbox.js"
      assert html =~ "ckbox/1.2.3/styles/themes/dark.css"
    end
  end
end
