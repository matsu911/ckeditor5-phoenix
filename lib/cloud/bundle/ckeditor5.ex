defmodule CKEditor5.Cloud.Bundle.CKEditor5 do
  @moduledoc """
  Generates bundle URLs for CKEditor5 core files.
  """

  alias CKEditor5.Cloud.Bundle

  import CKEditor5.Cloud.UrlBuilder, only: [build_url: 1]

  @doc """
  Creates URLs for CKEditor5 core JavaScript and CSS files.
  """
  def create_urls(version, translations \\ []) do
    css_url = build_url(["ckeditor5", version, "ckeditor5.css"])
    js_url = build_url(["ckeditor5", version, "ckeditor5.umd.js"])

    translation_js_urls =
      Enum.map(translations, fn translation ->
        build_url(["ckeditor5", version, "translations", "#{translation}.js"])
      end)

    %Bundle{
      js: [js_url | translation_js_urls],
      css: [css_url]
    }
  end
end
