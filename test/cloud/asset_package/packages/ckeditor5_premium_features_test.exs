defmodule CKEditor5.Cloud.AssetPackage.CKEditor5PremiumFeaturesTest do
  use ExUnit.Case, async: true

  alias CKEditor5.Cloud.AssetPackage
  alias CKEditor5.Cloud.AssetPackage.{CKEditor5PremiumFeatures, JSAsset}

  describe "build_package/2" do
    test "builds CKEditor5 Premium Features package with default translations" do
      version = "1.0.0"

      result = CKEditor5PremiumFeatures.build_package(version)

      assert %AssetPackage{} = result
      assert length(result.js) == 1
      assert length(result.css) == 1

      # Check CSS URL
      assert result.css == [
               "https://cdn.ckeditor.com/ckeditor5-premium-features/1.0.0/ckeditor5-premium-features.css"
             ]

      # Check main JS asset
      [main_js] = result.js

      assert %JSAsset{
               name: "ckeditor5-premium-features",
               url:
                 "https://cdn.ckeditor.com/ckeditor5-premium-features/1.0.0/ckeditor5-premium-features.js",
               type: :esm
             } = main_js
    end

    test "builds CKEditor5 Premium Features package with custom version" do
      version = "3.2.1"

      result = CKEditor5PremiumFeatures.build_package(version)

      assert %AssetPackage{} = result

      assert result.css == [
               "https://cdn.ckeditor.com/ckeditor5-premium-features/3.2.1/ckeditor5-premium-features.css"
             ]

      [main_js] = result.js

      assert main_js.url ==
               "https://cdn.ckeditor.com/ckeditor5-premium-features/3.2.1/ckeditor5-premium-features.js"
    end

    test "builds CKEditor5 Premium Features package with single translation" do
      version = "1.0.0"
      translations = ["zh"]

      result = CKEditor5PremiumFeatures.build_package(version, translations)

      assert %AssetPackage{} = result
      assert length(result.js) == 2
      assert length(result.css) == 1

      [main_js, translation_js] = result.js

      # Check main JS asset
      assert %JSAsset{
               name: "ckeditor5-premium-features",
               url:
                 "https://cdn.ckeditor.com/ckeditor5-premium-features/1.0.0/ckeditor5-premium-features.js",
               type: :esm
             } = main_js

      # Check translation JS asset
      assert %JSAsset{
               name: "ckeditor5-premium-features/translations/zh",
               url:
                 "https://cdn.ckeditor.com/ckeditor5-premium-features/1.0.0/translations/zh.js",
               type: :esm
             } = translation_js
    end

    test "builds CKEditor5 Premium Features package with multiple translations" do
      version = "1.0.0"
      translations = ["ja", "ko", "ru"]

      result = CKEditor5PremiumFeatures.build_package(version, translations)

      assert %AssetPackage{} = result
      # main + 3 translations
      assert length(result.js) == 4
      assert length(result.css) == 1

      [main_js | translation_assets] = result.js

      # Check main JS asset
      assert main_js.name == "ckeditor5-premium-features"
      assert main_js.type == :esm

      # Check all translation assets
      translation_names = Enum.map(translation_assets, & &1.name)

      assert translation_names == [
               "ckeditor5-premium-features/translations/ja",
               "ckeditor5-premium-features/translations/ko",
               "ckeditor5-premium-features/translations/ru"
             ]

      translation_urls = Enum.map(translation_assets, & &1.url)

      assert translation_urls == [
               "https://cdn.ckeditor.com/ckeditor5-premium-features/1.0.0/translations/ja.js",
               "https://cdn.ckeditor.com/ckeditor5-premium-features/1.0.0/translations/ko.js",
               "https://cdn.ckeditor.com/ckeditor5-premium-features/1.0.0/translations/ru.js"
             ]

      # All translation assets should be ESM
      Enum.each(translation_assets, fn asset ->
        assert asset.type == :esm
      end)
    end

    test "builds CKEditor5 Premium Features package with empty translations list" do
      version = "1.0.0"
      translations = []

      result = CKEditor5PremiumFeatures.build_package(version, translations)

      assert %AssetPackage{} = result
      assert length(result.js) == 1
      assert length(result.css) == 1

      [main_js] = result.js
      assert main_js.name == "ckeditor5-premium-features"
    end

    test "verifies all assets use ESM module type" do
      version = "1.0.0"
      translations = ["pl", "en"]

      result = CKEditor5PremiumFeatures.build_package(version, translations)

      # All JS assets should use ESM
      Enum.each(result.js, fn asset ->
        assert asset.type == :esm
      end)
    end

    test "handles long package name correctly in URLs" do
      version = "1.0.0"
      translations = ["pt-br"]

      result = CKEditor5PremiumFeatures.build_package(version, translations)

      [main_js, translation_js] = result.js

      # Verify the long package name is handled correctly in URLs
      assert String.contains?(main_js.url, "ckeditor5-premium-features")
      assert String.contains?(translation_js.url, "ckeditor5-premium-features")
      assert String.contains?(translation_js.name, "ckeditor5-premium-features/translations/")
    end
  end
end
