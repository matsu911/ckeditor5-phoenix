defmodule CKEditor5.Cloud.Bundle.CKBox do
  @moduledoc """
  Generates bundle URLs for CKBox.
  """

  alias CKEditor5.Cloud.Bundle

  import CKEditor5.Cloud.UrlBuilder, only: [build_url: 1]

  @doc """
  Creates URLs for CKBox JavaScript and CSS files.
  """
  def create_urls(version, translations \\ []) do
    css_url = build_url(["ckbox", version, "styles", "themes", "theme.css"])
    js_url = build_url(["ckbox", version, "ckbox.js"])

    translation_js_urls =
      Enum.map(translations, fn translation ->
        build_url(["ckbox", version, "translations", "#{translation}.js"])
      end)

    %Bundle{
      js: [js_url | translation_js_urls],
      css: [css_url]
    }
  end
end
