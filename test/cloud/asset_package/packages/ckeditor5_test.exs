defmodule CKEditor5.Cloud.AssetPackage.CKEditor5Test do
  use ExUnit.Case, async: true

  alias CKEditor5.Cloud.AssetPackage
  alias CKEditor5.Cloud.AssetPackage.{CKEditor5, JSAsset}

  describe "build_package/2" do
    test "builds CKEditor5 package with default translations" do
      version = "1.0.0"

      result = CKEditor5.build_package(version)

      assert %AssetPackage{} = result
      assert length(result.js) == 1
      assert length(result.css) == 1

      # Check CSS URL
      assert result.css == ["https://cdn.ckeditor.com/ckeditor5/1.0.0/ckeditor5.css"]

      # Check main JS asset
      [main_js] = result.js

      assert %JSAsset{
               name: "ckeditor5",
               url: "https://cdn.ckeditor.com/ckeditor5/1.0.0/ckeditor5.js",
               type: :esm
             } = main_js
    end

    test "builds CKEditor5 package with custom version" do
      version = "42.0.1"

      result = CKEditor5.build_package(version)

      assert %AssetPackage{} = result
      assert result.css == ["https://cdn.ckeditor.com/ckeditor5/42.0.1/ckeditor5.css"]

      [main_js] = result.js
      assert main_js.url == "https://cdn.ckeditor.com/ckeditor5/42.0.1/ckeditor5.js"
    end

    test "builds CKEditor5 package with single translation" do
      version = "1.0.0"
      translations = ["fr"]

      result = CKEditor5.build_package(version, translations)

      assert %AssetPackage{} = result
      assert length(result.js) == 2
      assert length(result.css) == 1

      [main_js, translation_js] = result.js

      # Check main JS asset
      assert %JSAsset{
               name: "ckeditor5",
               url: "https://cdn.ckeditor.com/ckeditor5/1.0.0/ckeditor5.js",
               type: :esm
             } = main_js

      # Check translation JS asset
      assert %JSAsset{
               name: "ckeditor5/translations/fr",
               url: "https://cdn.ckeditor.com/ckeditor5/1.0.0/translations/fr.js",
               type: :esm
             } = translation_js
    end

    test "builds CKEditor5 package with multiple translations" do
      version = "1.0.0"
      translations = ["es", "it", "pt"]

      result = CKEditor5.build_package(version, translations)

      assert %AssetPackage{} = result
      # main + 3 translations
      assert length(result.js) == 4
      assert length(result.css) == 1

      [main_js | translation_assets] = result.js

      # Check main JS asset
      assert main_js.name == "ckeditor5"
      assert main_js.type == :esm

      # Check all translation assets
      translation_names = Enum.map(translation_assets, & &1.name)

      assert translation_names == [
               "ckeditor5/translations/es",
               "ckeditor5/translations/it",
               "ckeditor5/translations/pt"
             ]

      translation_urls = Enum.map(translation_assets, & &1.url)

      assert translation_urls == [
               "https://cdn.ckeditor.com/ckeditor5/1.0.0/translations/es.js",
               "https://cdn.ckeditor.com/ckeditor5/1.0.0/translations/it.js",
               "https://cdn.ckeditor.com/ckeditor5/1.0.0/translations/pt.js"
             ]

      # All translation assets should be ESM
      Enum.each(translation_assets, fn asset ->
        assert asset.type == :esm
      end)
    end

    test "builds CKEditor5 package with empty translations list" do
      version = "1.0.0"
      translations = []

      result = CKEditor5.build_package(version, translations)

      assert %AssetPackage{} = result
      assert length(result.js) == 1
      assert length(result.css) == 1

      [main_js] = result.js
      assert main_js.name == "ckeditor5"
    end

    test "verifies all assets use ESM module type" do
      version = "1.0.0"
      translations = ["pl", "en"]

      result = CKEditor5.build_package(version, translations)

      # All JS assets should use ESM
      Enum.each(result.js, fn asset ->
        assert asset.type == :esm
      end)
    end
  end
end
