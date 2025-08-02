defmodule CKEditor5.Components.Cloud.UmdScriptsTest do
  alias CKEditor5.Components.Cloud.UmdScripts
  alias CKEditor5.Test.PresetsHelper

  use CKEditor5.Test.PresetsTestCaseTemplate, async: true

  import Phoenix.LiveViewTest

  describe "render/1 with CKBox config" do
    test "renders CKBox UMD script src for ckbox.js", %{cloud_license_key: key} do
      ckbox_version = "1.2.3"

      preset =
        default_preset(key,
          cloud: %{
            version: "40.0.0",
            translations: ["pl"],
            ckbox: %{version: ckbox_version, theme: "dark"}
          }
        )

      PresetsHelper.put_presets_env(%{"with_ckbox" => preset})
      html = render_component(&UmdScripts.render/1, preset: "with_ckbox")
      assert html =~ "/ckbox/1.2.3/ckbox.js"
      assert html =~ "<script src="
    end

    test "renders CKBox UMD script src for translation", %{cloud_license_key: key} do
      ckbox_version = "1.2.3"

      preset =
        default_preset(key,
          cloud: %{
            version: "40.0.0",
            translations: ["pl"],
            ckbox: %{version: ckbox_version, theme: "dark"}
          }
        )

      PresetsHelper.put_presets_env(%{"with_ckbox" => preset})
      html = render_component(&UmdScripts.render/1, preset: "with_ckbox")
      assert html =~ "/ckbox/1.2.3/translations/pl.js"
    end

    test "does not render CKBox UMD script when ckbox config is missing", %{
      cloud_license_key: key
    } do
      preset = default_preset(key)
      PresetsHelper.put_presets_env(%{"without_ckbox" => preset})
      html = render_component(&UmdScripts.render/1, preset: "without_ckbox")
      refute html =~ "/ckbox/"
    end
  end
end
