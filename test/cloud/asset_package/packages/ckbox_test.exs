defmodule CKEditor5.Cloud.AssetPackage.CKBoxTest do
  use ExUnit.Case, async: true

  alias CKEditor5.Cloud.AssetPackage
  alias CKEditor5.Cloud.AssetPackage.{CKBox, JSAsset}

  describe "build_package/2" do
    test "builds CKBox package with default translations" do
      version = "1.0.0"

      result = CKBox.build_package(version)

      assert %AssetPackage{} = result
      assert length(result.js) == 1
      assert length(result.css) == 1

      # Check CSS URL
      assert result.css == ["https://cdn.ckbox.io/ckbox/1.0.0/styles/themes/theme.css"]

      # Check main JS asset
      [main_js] = result.js

      assert %JSAsset{
               name: "ckbox",
               url: "https://cdn.ckbox.io/ckbox/1.0.0/ckbox.js",
               type: :umd
             } = main_js
    end

    test "builds CKBox package with custom version" do
      version = "2.1.5"

      result = CKBox.build_package(version)

      assert %AssetPackage{} = result
      assert result.css == ["https://cdn.ckbox.io/ckbox/2.1.5/styles/themes/theme.css"]

      [main_js] = result.js
      assert main_js.url == "https://cdn.ckbox.io/ckbox/2.1.5/ckbox.js"
    end

    test "builds CKBox package with single translation" do
      version = "1.0.0"
      translations = ["pl"]

      result = CKBox.build_package(version, translations)

      assert %AssetPackage{} = result
      assert length(result.js) == 2
      assert length(result.css) == 1

      [main_js, translation_js] = result.js

      # Check main JS asset
      assert %JSAsset{
               name: "ckbox",
               url: "https://cdn.ckbox.io/ckbox/1.0.0/ckbox.js",
               type: :umd
             } = main_js

      # Check translation JS asset
      assert %JSAsset{
               name: "ckbox/translations/pl",
               url: "https://cdn.ckbox.io/ckbox/1.0.0/translations/pl.js",
               type: :umd
             } = translation_js
    end

    test "builds CKBox package with multiple translations" do
      version = "1.0.0"
      translations = ["pl", "en", "de"]

      result = CKBox.build_package(version, translations)

      assert %AssetPackage{} = result
      # main + 3 translations
      assert length(result.js) == 4
      assert length(result.css) == 1

      [main_js | translation_assets] = result.js

      # Check main JS asset
      assert main_js.name == "ckbox"
      assert main_js.type == :umd

      # Check all translation assets
      translation_names = Enum.map(translation_assets, & &1.name)

      assert translation_names == [
               "ckbox/translations/pl",
               "ckbox/translations/en",
               "ckbox/translations/de"
             ]

      translation_urls = Enum.map(translation_assets, & &1.url)

      assert translation_urls == [
               "https://cdn.ckbox.io/ckbox/1.0.0/translations/pl.js",
               "https://cdn.ckbox.io/ckbox/1.0.0/translations/en.js",
               "https://cdn.ckbox.io/ckbox/1.0.0/translations/de.js"
             ]

      # All translation assets should be UMD
      Enum.each(translation_assets, fn asset ->
        assert asset.type == :umd
      end)
    end

    test "builds CKBox package with empty translations list" do
      version = "1.0.0"
      translations = []

      result = CKBox.build_package(version, translations)

      assert %AssetPackage{} = result
      assert length(result.js) == 1
      assert length(result.css) == 1

      [main_js] = result.js
      assert main_js.name == "ckbox"
    end
  end
end
