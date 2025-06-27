defmodule CKEditor5.Cloud.Bundle.CKEditor5 do
  @moduledoc """
  Generates bundle URLs for CKEditor5 core files.
  """

  alias CKEditor5.Cloud.Bundle
  alias CKEditor5.Cloud.Bundle.JSAsset

  import CKEditor5.Cloud.UrlBuilder, only: [build_url: 1]

  @doc """
  Creates URLs for CKEditor5 core JavaScript and CSS files.
  """
  def build_bundle(version, translations \\ []) do
    css_url = build_url(["ckeditor5", version, "ckeditor5.css"])

    js_asset = %JSAsset{
      name: "ckeditor5",
      url: build_url(["ckeditor5", version, "ckeditor5.js"]),
      type: :esm
    }

    translation_js_assets =
      Enum.map(translations, fn translation ->
        %JSAsset{
          name: "ckeditor5/translations/#{translation}",
          url: build_url(["ckeditor5", version, "translations", "#{translation}.js"]),
          type: :esm
        }
      end)

    %Bundle{
      js: [js_asset | translation_js_assets],
      css: [css_url]
    }
  end
end
