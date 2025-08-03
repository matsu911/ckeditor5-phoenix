defmodule CKEditor5.Components.Cloud.StylesheetsTest do
  alias CKEditor5.Components.Cloud.Stylesheets
  alias CKEditor5.Test.PresetsHelper

  use CKEditor5.Test.PresetsTestCaseTemplate, async: true

  import Phoenix.LiveViewTest

  describe "render/1 with CKBox and premium config" do
    test "should not render premium stylesheet when premium is false", %{cloud_license_key: key} do
      preset =
        default_preset(key, cloud: %{version: "40.0.0", premium: false, translations: ["pl"]})

      PresetsHelper.put_presets_env(%{"default" => preset})

      html = render_component(&Stylesheets.render/1, preset: "default")
      refute html =~ "ckeditor5-premium-features.css"
    end

    test "renders CKEditor premium stylesheet", %{cloud_license_key: key} do
      preset =
        default_preset(key,
          cloud: %{version: "40.0.0", premium: true, translations: ["pl"], ckbox: nil}
        )

      PresetsHelper.put_presets_env(%{"premium" => preset})
      html = render_component(&Stylesheets.render/1, preset: "premium")

      assert html =~ "ckeditor5-premium-features.css"
      assert html =~ "<link rel=\"stylesheet\""
    end

    test "renders CKBox stylesheet when ckbox config is present", %{cloud_license_key: key} do
      ckbox_version = "1.2.3"

      preset =
        default_preset(key,
          cloud: %{
            version: "40.0.0",
            premium: false,
            translations: ["pl"],
            ckbox: %{version: ckbox_version, theme: "dark"}
          }
        )

      PresetsHelper.put_presets_env(%{"with_ckbox" => preset})

      html = render_component(&Stylesheets.render/1, preset: "with_ckbox")
      assert html =~ "href=\"https://cdn.ckbox.io/ckbox/1.2.3/styles/themes/dark.css\""
    end

    test "should not render CKBox stylesheet when ckbox config is missing", %{
      cloud_license_key: key
    } do
      preset =
        default_preset(key, cloud: %{version: "40.0.0", premium: false, translations: ["pl"]})

      PresetsHelper.put_presets_env(%{"without_ckbox" => preset})
      html = render_component(&Stylesheets.render/1, preset: "without_ckbox")

      refute html =~ "/themes/dark.css"
    end

    test "render premium css if premium attribute is present and non-premium preset", %{
      cloud_license_key: key
    } do
      preset = default_preset(key, cloud: %{version: "40.0.0", premium: false})
      PresetsHelper.put_presets_env(%{"free" => preset})

      html = render_component(&Stylesheets.render/1, preset: "free", premium: true)

      assert html =~ "ckeditor5-premium-features.css"
    end
  end
end
