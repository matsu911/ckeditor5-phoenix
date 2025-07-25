defmodule CKEditor5.Components.Cloud.ImportmapTest do
  use ExUnit.Case, async: true

  alias CKEditor5.Components.Cloud.Importmap
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

  describe "render/1 for importmap" do
    test "renders importmap script with ESM modules and matches expected JSON", %{
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

      PresetsHelper.put_presets_env(%{"default" => preset})
      html = render_component(&Importmap.render/1, preset: "default")

      [_, importmap_json] = Regex.run(~r/<script type="importmap"[^>]*>(.+)<\/script>/s, html)
      importmap = Jason.decode!(importmap_json)

      expected_imports = %{
        "ckeditor5" => "https://cdn.ckeditor.com/ckeditor5/40.0.0/ckeditor5.js",
        "ckeditor5/translations/pl" =>
          "https://cdn.ckeditor.com/ckeditor5/40.0.0/translations/pl.js"
      }

      assert importmap["imports"] == expected_imports
    end

    test "renders importmap script for premium features and matches expected JSON", %{
      cloud_license_key: key
    } do
      preset = %{
        license_key: key,
        config: %{},
        cloud: %{
          version: "40.0.0",
          premium: true,
          translations: ["pl"]
        }
      }

      PresetsHelper.put_presets_env(%{"premium" => preset})
      html = render_component(&Importmap.render/1, preset: "premium")

      [_, importmap_json] = Regex.run(~r/<script type="importmap"[^>]*>(.+)<\/script>/s, html)
      importmap = Jason.decode!(importmap_json)

      expected_imports = %{
        "ckeditor5" => "https://cdn.ckeditor.com/ckeditor5/40.0.0/ckeditor5.js",
        "ckeditor5/translations/pl" =>
          "https://cdn.ckeditor.com/ckeditor5/40.0.0/translations/pl.js",
        "ckeditor5-premium-features" =>
          "https://cdn.ckeditor.com/ckeditor5-premium-features/40.0.0/ckeditor5-premium-features.js",
        "ckeditor5-premium-features/translations/pl" =>
          "https://cdn.ckeditor.com/ckeditor5-premium-features/40.0.0/translations/pl.js"
      }

      assert importmap["imports"] == expected_imports
    end
  end
end
