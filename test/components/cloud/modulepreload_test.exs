defmodule CKEditor5.Components.Cloud.ModulePreloadTest do
  alias CKEditor5.Components.Cloud.ModulePreload
  alias CKEditor5.Test.PresetsHelper

  use CKEditor5.Test.PresetsTestCaseTemplate, async: true

  import Phoenix.LiveViewTest

  describe "render/1 for CKEditor5 and premium features" do
    test "renders CKEditor5 modulepreload link and translation", %{cloud_license_key: key} do
      preset = default_preset(key)

      PresetsHelper.put_presets_env(%{"default" => preset})
      html = render_component(&ModulePreload.render/1, preset: "default")

      assert html =~
               "rel=\"modulepreload\" href=\"https://cdn.ckeditor.com/ckeditor5/40.0.0/ckeditor5.js\""

      assert html =~
               "rel=\"modulepreload\" href=\"https://cdn.ckeditor.com/ckeditor5/40.0.0/translations/pl.js\""
    end

    test "renders premium features modulepreload link and translation", %{cloud_license_key: key} do
      preset =
        default_preset(key, cloud: %{version: "40.0.0", premium: true, translations: ["pl"]})

      PresetsHelper.put_presets_env(%{"premium" => preset})
      html = render_component(&ModulePreload.render/1, preset: "premium")

      assert html =~
               "rel=\"modulepreload\" href=\"https://cdn.ckeditor.com/ckeditor5-premium-features/40.0.0/ckeditor5-premium-features.js\""

      assert html =~
               "rel=\"modulepreload\" href=\"https://cdn.ckeditor.com/ckeditor5-premium-features/40.0.0/translations/pl.js\""
    end

    test "renders modulepreload links for multiple translations", %{cloud_license_key: key} do
      preset =
        default_preset(key,
          cloud: %{version: "40.0.0", premium: false, translations: ["pl", "de"]}
        )

      PresetsHelper.put_presets_env(%{"default" => preset})

      html =
        render_component(&ModulePreload.render/1, preset: "default", translations: ["pl", "de"])

      assert html =~
               "rel=\"modulepreload\" href=\"https://cdn.ckeditor.com/ckeditor5/40.0.0/ckeditor5.js\""

      assert html =~
               "rel=\"modulepreload\" href=\"https://cdn.ckeditor.com/ckeditor5/40.0.0/translations/pl.js\""

      assert html =~
               "rel=\"modulepreload\" href=\"https://cdn.ckeditor.com/ckeditor5/40.0.0/translations/de.js\""
    end

    test "renders modulepreload links with translations as nil uses preset config", %{
      cloud_license_key: key
    } do
      preset = default_preset(key)

      PresetsHelper.put_presets_env(%{"default" => preset})
      html = render_component(&ModulePreload.render/1, preset: "default", translations: nil)

      assert html =~
               "rel=\"modulepreload\" href=\"https://cdn.ckeditor.com/ckeditor5/40.0.0/ckeditor5.js\""

      assert html =~
               "rel=\"modulepreload\" href=\"https://cdn.ckeditor.com/ckeditor5/40.0.0/translations/pl.js\""
    end

    test "renders modulepreload links with empty translations omits translation links", %{
      cloud_license_key: key
    } do
      preset = default_preset(key)

      PresetsHelper.put_presets_env(%{"default" => preset})
      html = render_component(&ModulePreload.render/1, preset: "default", translations: [])

      assert html =~
               "rel=\"modulepreload\" href=\"https://cdn.ckeditor.com/ckeditor5/40.0.0/ckeditor5.js\""

      refute html =~
               "rel=\"modulepreload\" href=\"https://cdn.ckeditor.com/ckeditor5/40.0.0/translations/pl.js\""
    end
  end
end
