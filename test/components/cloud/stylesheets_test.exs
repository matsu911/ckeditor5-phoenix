defmodule CKEditor5.Components.Cloud.StylesheetsTest do
  use ExUnit.Case, async: true

  alias CKEditor5.Components.Cloud.Stylesheets
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

  describe "render/1 with CKBox and premium config" do
    test "renders CKEditor premium stylesheet", %{cloud_license_key: key} do
      preset = %{
        license_key: key,
        config: %{},
        cloud: %{
          version: "40.0.0",
          premium: true,
          translations: ["pl"],
          ckbox: nil
        }
      }

      PresetsHelper.put_presets_env(%{"premium" => preset})

      html = render_component(&Stylesheets.render/1, preset: "premium")

      assert html =~ "ckeditor5-premium-features.css"
      assert html =~ "<link rel=\"stylesheet\""
    end

    test "renders CKBox stylesheet when ckbox config is present", %{cloud_license_key: key} do
      ckbox_version = "1.2.3"

      preset = %{
        license_key: key,
        config: %{},
        cloud: %{
          version: "40.0.0",
          premium: false,
          translations: ["pl"],
          ckbox: %{
            version: ckbox_version,
            theme: "dark"
          }
        }
      }

      PresetsHelper.put_presets_env(%{"with_ckbox" => preset})

      html = render_component(&Stylesheets.render/1, preset: "with_ckbox")

      assert html =~ "href=\"https://cdn.ckbox.io/ckbox/1.2.3/styles/themes/dark.css\""
    end

    test "does not render CKBox stylesheet when ckbox config is missing", %{
      cloud_license_key: key
    } do
      preset = %{
        license_key: key,
        config: %{},
        cloud: %{
          version: "40.0.0",
          premium: false,
          translations: ["pl"]
        }
      }

      PresetsHelper.put_presets_env(%{"without_ckbox" => preset})

      html = render_component(&Stylesheets.render/1, preset: "without_ckbox")
      refute html =~ "/themes/dark.css"
    end
  end
end
