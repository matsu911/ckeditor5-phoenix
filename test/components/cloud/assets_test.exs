defmodule CKEditor5.Components.Cloud.AssetsTest do
  use CKEditor5.Test.PresetsTestCaseTemplate, async: true

  alias CKEditor5.Components.Cloud.Assets

  import Phoenix.LiveViewTest

  describe "render/1" do
    test "renders all cloud asset components for default preset", %{cloud_license_key: key} do
      preset = default_preset(key)
      put_presets_env(%{"default" => preset})

      html = render_component(&Assets.render/1, preset: "default")

      assert html =~ "<script type=\"importmap\""
      assert html =~ "rel=\"stylesheet\""
      assert html =~ "rel=\"modulepreload\""
    end

    test "renders with nonce attribute for all asset tags", %{cloud_license_key: key} do
      preset = default_preset(key)
      put_presets_env(%{"default" => preset})

      nonce = "test-nonce"
      html = render_component(&Assets.render/1, preset: "default", nonce: nonce)

      assert html =~ "nonce=\"test-nonce\""
    end

    test "renders premium features and CKBox assets if present", %{cloud_license_key: key} do
      ckbox = %{version: "1.2.3", theme: "dark"}

      preset =
        default_preset(key,
          cloud: %{version: "40.0.0", premium: true, translations: ["pl"], ckbox: ckbox}
        )

      put_presets_env(%{"premium" => preset})
      html = render_component(&Assets.render/1, preset: "premium")

      assert html =~ "ckeditor5-premium-features"
      assert html =~ "ckbox/1.2.3/ckbox.js"
      assert html =~ "ckbox/1.2.3/styles/themes/dark.css"
    end

    test "renders with custom translations does not crash", %{cloud_license_key: key} do
      preset = default_preset(key)
      put_presets_env(%{"default" => preset})

      html = render_component(&Assets.render/1, preset: "default", translations: ["pl", "de"])

      assert html =~ "<script type=\"importmap\""

      assert html =~
               "rel=\"modulepreload\" href=\"https://cdn.ckeditor.com/ckeditor5/40.0.0/translations/pl.js\""

      assert html =~
               "rel=\"modulepreload\" href=\"https://cdn.ckeditor.com/ckeditor5/40.0.0/translations/de.js\""

      assert html =~
               "\"ckeditor5/translations/pl.js\":\"https://cdn.ckeditor.com/ckeditor5/40.0.0/translations/pl.js\""

      assert html =~
               "\"ckeditor5/translations/de.js\":\"https://cdn.ckeditor.com/ckeditor5/40.0.0/translations/de.js\""
    end
  end
end
