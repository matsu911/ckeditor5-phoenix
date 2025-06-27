defmodule CKEditor5.Cloud.Bundle.CKBox do
  @moduledoc """
  Generates bundle URLs for CKBox.
  """

  alias CKEditor5.Cloud.Bundle
  alias CKEditor5.Cloud.Bundle.JSAsset

  import CKEditor5.Cloud.UrlBuilder, only: [build_url: 1]

  @doc """
  Creates URLs for CKBox JavaScript and CSS files.
  """
  def build_bundle(version, translations \\ []) do
    css_url = build_url(["ckbox", version, "styles", "themes", "theme.css"])

    js_asset = %JSAsset{
      name: "ckbox",
      url: build_url(["ckbox", version, "ckbox.js"]),
      type: :umd
    }

    translation_js_assets =
      Enum.map(translations, fn translation ->
        %JSAsset{
          name: "ckbox/translations/#{translation}",
          url: build_url(["ckbox", version, "translations", "#{translation}.js"]),
          type: :umd
        }
      end)

    %Bundle{
      js: [js_asset | translation_js_assets],
      css: [css_url]
    }
  end
end
