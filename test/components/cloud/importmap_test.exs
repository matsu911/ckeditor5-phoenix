defmodule CKEditor5.Components.Cloud.ImportmapTest do
  use CKEditor5.Test.PresetsTestCaseTemplate, async: true

  alias CKEditor5.Components.Cloud.Importmap

  import Phoenix.LiveViewTest

  describe "render/1 for importmap" do
    test "renders importmap script with ESM modules and matches expected JSON", %{
      cloud_license_key: key
    } do
      preset = default_preset(key)
      put_presets_env(%{"default" => preset})
      html = render_component(&Importmap.render/1, preset: "default")

      [_, importmap_json] = Regex.run(~r/<script type="importmap"[^>]*>(.+)<\/script>/s, html)
      importmap = Jason.decode!(importmap_json)

      expected_imports = %{
        "ckeditor5" => "https://cdn.ckeditor.com/ckeditor5/40.0.0/ckeditor5.js",
        "ckeditor5/translations/pl.js" =>
          "https://cdn.ckeditor.com/ckeditor5/40.0.0/translations/pl.js"
      }

      assert importmap["imports"] == expected_imports
    end

    test "renders importmap script for premium features and matches expected JSON", %{
      cloud_license_key: key
    } do
      preset =
        default_preset(key, cloud: %{version: "40.0.0", premium: true, translations: ["pl"]})

      put_presets_env(%{"premium" => preset})
      html = render_component(&Importmap.render/1, preset: "premium")

      [_, importmap_json] = Regex.run(~r/<script type="importmap"[^>]*>(.+)<\/script>/s, html)
      importmap = Jason.decode!(importmap_json)

      expected_imports = %{
        "ckeditor5" => "https://cdn.ckeditor.com/ckeditor5/40.0.0/ckeditor5.js",
        "ckeditor5/translations/pl.js" =>
          "https://cdn.ckeditor.com/ckeditor5/40.0.0/translations/pl.js",
        "ckeditor5-premium-features" =>
          "https://cdn.ckeditor.com/ckeditor5-premium-features/40.0.0/ckeditor5-premium-features.js",
        "ckeditor5-premium-features/translations/pl.js" =>
          "https://cdn.ckeditor.com/ckeditor5-premium-features/40.0.0/translations/pl.js"
      }

      assert importmap["imports"] == expected_imports
    end

    test "not renders importmap script for premium features when not defined in preset", %{
      cloud_license_key: key
    } do
      preset = default_preset(key, cloud: %{version: "40.0.0", premium: false})
      put_presets_env(%{"default" => preset})

      html = render_component(&Importmap.render/1, preset: "default")

      refute html =~ "ckeditor5-premium-features"
    end

    test "renders importmap for premium features defined as assign flag and non-premium preset",
         %{
           cloud_license_key: key
         } do
      free_preset =
        default_preset(key, cloud: %{version: "40.0.0", premium: false})

      put_presets_env(%{"free" => free_preset})

      html = render_component(&Importmap.render/1, preset: "free", premium: true)

      [_, importmap_json] = Regex.run(~r/<script type="importmap"[^>]*>(.+)<\/script>/s, html)
      importmap = Jason.decode!(importmap_json)

      expected_imports = %{
        "ckeditor5" => "https://cdn.ckeditor.com/ckeditor5/40.0.0/ckeditor5.js",
        "ckeditor5-premium-features" =>
          "https://cdn.ckeditor.com/ckeditor5-premium-features/40.0.0/ckeditor5-premium-features.js"
      }

      assert importmap["imports"] == expected_imports
    end

    test "renders importmap script with multiple translations", %{cloud_license_key: key} do
      preset =
        default_preset(key,
          cloud: %{version: "40.0.0", premium: false, translations: ["pl", "de"]}
        )

      put_presets_env(%{"default" => preset})
      html = render_component(&Importmap.render/1, preset: "default", translations: ["pl", "de"])

      [_, importmap_json] = Regex.run(~r/<script type="importmap"[^>]*>(.+)<\/script>/s, html)
      importmap = Jason.decode!(importmap_json)

      expected_imports = %{
        "ckeditor5" => "https://cdn.ckeditor.com/ckeditor5/40.0.0/ckeditor5.js",
        "ckeditor5/translations/pl.js" =>
          "https://cdn.ckeditor.com/ckeditor5/40.0.0/translations/pl.js",
        "ckeditor5/translations/de.js" =>
          "https://cdn.ckeditor.com/ckeditor5/40.0.0/translations/de.js"
      }

      assert importmap["imports"] == expected_imports
    end

    test "renders importmap script with translations as nil uses preset config", %{
      cloud_license_key: key
    } do
      preset = default_preset(key)
      put_presets_env(%{"default" => preset})
      html = render_component(&Importmap.render/1, preset: "default", translations: nil)

      [_, importmap_json] = Regex.run(~r/<script type="importmap"[^>]*>(.+)<\/script>/s, html)
      importmap = Jason.decode!(importmap_json)

      expected_imports = %{
        "ckeditor5" => "https://cdn.ckeditor.com/ckeditor5/40.0.0/ckeditor5.js",
        "ckeditor5/translations/pl.js" =>
          "https://cdn.ckeditor.com/ckeditor5/40.0.0/translations/pl.js"
      }

      assert importmap["imports"] == expected_imports
    end

    test "renders importmap script with empty translations omits translation imports", %{
      cloud_license_key: key
    } do
      preset = default_preset(key)
      put_presets_env(%{"default" => preset})
      html = render_component(&Importmap.render/1, preset: "default", translations: [])

      [_, importmap_json] = Regex.run(~r/<script type="importmap"[^>]*>(.+)<\/script>/s, html)
      importmap = Jason.decode!(importmap_json)

      expected_imports = %{
        "ckeditor5" => "https://cdn.ckeditor.com/ckeditor5/40.0.0/ckeditor5.js"
      }

      assert importmap["imports"] == expected_imports
    end
  end
end
