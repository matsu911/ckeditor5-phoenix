defmodule CKEditor5.Cloud.AssetPackage.CKEditor5PremiumFeatures do
  @moduledoc """
  Generates asset package URLs for CKEditor5 Premium Features.
  """

  alias CKEditor5.Cloud.AssetPackage
  alias CKEditor5.Cloud.AssetPackage.JSAsset

  import CKEditor5.Cloud.UrlBuilder, only: [build_url: 1]

  @doc """
  Creates URLs for CKEditor5 Premium Features JavaScript and CSS files.
  """
  def build_package(version, translations \\ []) do
    css_url = build_url(["ckeditor5-premium-features", version, "ckeditor5-premium-features.css"])

    js_asset = %JSAsset{
      name: "ckeditor5-premium-features",
      url: build_url(["ckeditor5-premium-features", version, "ckeditor5-premium-features.js"]),
      type: :esm
    }

    translation_js_assets =
      Enum.map(translations, fn translation ->
        %JSAsset{
          name: "ckeditor5-premium-features/translations/#{translation}",
          url:
            build_url([
              "ckeditor5-premium-features",
              version,
              "translations",
              "#{translation}.js"
            ]),
          type: :esm
        }
      end)

    %AssetPackage{
      js: [js_asset | translation_js_assets],
      css: [css_url]
    }
  end
end
