defmodule CKEditor5.Cloud.AssetPackage.CKBox do
  @moduledoc """
  Generates asset package URLs for CKBox.
  """

  alias CKEditor5.Cloud.AssetPackage
  alias CKEditor5.Cloud.AssetPackage.JSAsset

  import CKEditor5.Cloud.UrlBuilder, only: [build_url: 2]

  @doc """
  Creates URLs for CKBox JavaScript and CSS files.
  """
  def build_package(version, translations \\ []) do
    css_url = build_url(:ckbox, ["ckbox", version, "styles", "themes", "theme.css"])

    js_asset = %JSAsset{
      name: "ckbox",
      url: build_url(:ckbox, ["ckbox", version, "ckbox.js"]),
      type: :umd
    }

    translation_js_assets =
      Enum.map(translations, fn translation ->
        %JSAsset{
          name: "ckbox/translations/#{translation}",
          url: build_url(:ckbox, ["ckbox", version, "translations", "#{translation}.js"]),
          type: :umd
        }
      end)

    %AssetPackage{
      js: [js_asset | translation_js_assets],
      css: [css_url]
    }
  end
end
