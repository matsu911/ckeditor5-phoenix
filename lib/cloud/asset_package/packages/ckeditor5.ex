defmodule CKEditor5.Cloud.AssetPackage.CKEditor5 do
  @moduledoc """
  Generates asset package URLs for CKEditor5 core files.
  """

  alias CKEditor5.Cloud.AssetPackage
  alias CKEditor5.Cloud.AssetPackage.JSAsset

  import CKEditor5.Cloud.CKEditorCloudUrlBuilder, only: [build_url: 2]

  @doc """
  Creates URLs for CKEditor5 core JavaScript and CSS files.
  """
  def build_package(version, translations \\ []) do
    css_url = build_url(:ckeditor, ["ckeditor5", version, "ckeditor5.css"])

    js_asset = %JSAsset{
      name: "ckeditor5",
      url: build_url(:ckeditor, ["ckeditor5", version, "ckeditor5.js"]),
      type: :esm
    }

    translation_js_assets =
      Enum.map(translations, fn translation ->
        %JSAsset{
          name: "ckeditor5/translations/#{translation}.js",
          url: build_url(:ckeditor, ["ckeditor5", version, "translations", "#{translation}.js"]),
          type: :esm
        }
      end)

    %AssetPackage{
      js: [js_asset | translation_js_assets],
      css: [css_url]
    }
  end
end
