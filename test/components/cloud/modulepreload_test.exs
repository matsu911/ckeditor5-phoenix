defmodule CKEditor5.Components.Cloud.ModulePreloadTest do
  use ExUnit.Case, async: true

  alias CKEditor5.Components.Cloud.ModulePreload
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

  describe "render/1 for CKEditor5 and premium features" do
    test "renders CKEditor5 modulepreload link and translation", %{cloud_license_key: key} do
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
      html = render_component(&ModulePreload.render/1, preset: "default")

      assert html =~
               "rel=\"modulepreload\" href=\"https://cdn.ckeditor.com/ckeditor5/40.0.0/ckeditor5.js\""

      assert html =~
               "rel=\"modulepreload\" href=\"https://cdn.ckeditor.com/ckeditor5/40.0.0/translations/pl.js\""
    end

    test "renders premium features modulepreload link and translation", %{cloud_license_key: key} do
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
      html = render_component(&ModulePreload.render/1, preset: "premium")

      assert html =~
               "rel=\"modulepreload\" href=\"https://cdn.ckeditor.com/ckeditor5-premium-features/40.0.0/ckeditor5-premium-features.js\""

      assert html =~
               "rel=\"modulepreload\" href=\"https://cdn.ckeditor.com/ckeditor5-premium-features/40.0.0/translations/pl.js\""
    end
  end
end
