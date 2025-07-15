defmodule CKEditor5.Cloud.AssetPackageTest do
  use ExUnit.Case, async: true

  alias CKEditor5.Cloud.AssetPackage
  alias CKEditor5.Cloud.AssetPackage.JSAsset

  describe "struct" do
    test "creates asset package with default empty js and css arrays" do
      asset_package = %AssetPackage{}

      assert asset_package.js == []
      assert asset_package.css == []
    end

    test "creates asset package with custom js and css arrays" do
      js_asset = %JSAsset{name: "test", url: "https://example.com/test.js", type: :esm}
      css_url = "https://example.com/test.css"

      asset_package = %AssetPackage{
        js: [js_asset],
        css: [css_url]
      }

      assert asset_package.js == [js_asset]
      assert asset_package.css == [css_url]
    end
  end

  describe "merge/2" do
    test "merges two empty asset packages" do
      package1 = %AssetPackage{}
      package2 = %AssetPackage{}

      result = AssetPackage.merge(package1, package2)

      assert result.js == []
      assert result.css == []
    end

    test "merges asset package with empty js and css into empty package" do
      package1 = %AssetPackage{}

      js_asset = %JSAsset{name: "test", url: "https://example.com/test.js", type: :esm}

      package2 = %AssetPackage{
        js: [js_asset],
        css: ["https://example.com/test.css"]
      }

      result = AssetPackage.merge(package1, package2)

      assert result.js == [js_asset]
      assert result.css == ["https://example.com/test.css"]
    end

    test "merges empty package into asset package with js and css" do
      js_asset = %JSAsset{name: "test", url: "https://example.com/test.js", type: :esm}

      package1 = %AssetPackage{
        js: [js_asset],
        css: ["https://example.com/test.css"]
      }

      package2 = %AssetPackage{}

      result = AssetPackage.merge(package1, package2)

      assert result.js == [js_asset]
      assert result.css == ["https://example.com/test.css"]
    end

    test "merges two asset packages with different js and css assets" do
      js_asset1 = %JSAsset{name: "editor", url: "https://example.com/editor.js", type: :esm}
      js_asset2 = %JSAsset{name: "plugins", url: "https://example.com/plugins.js", type: :umd}

      package1 = %AssetPackage{
        js: [js_asset1],
        css: ["https://example.com/editor.css"]
      }

      package2 = %AssetPackage{
        js: [js_asset2],
        css: ["https://example.com/plugins.css"]
      }

      result = AssetPackage.merge(package1, package2)

      assert result.js == [js_asset1, js_asset2]
      assert result.css == ["https://example.com/editor.css", "https://example.com/plugins.css"]
    end

    test "merges two asset packages with multiple js and css assets each" do
      js_asset1 = %JSAsset{name: "editor", url: "https://example.com/editor.js", type: :esm}
      js_asset2 = %JSAsset{name: "ui", url: "https://example.com/ui.js", type: :esm}
      js_asset3 = %JSAsset{name: "plugins", url: "https://example.com/plugins.js", type: :umd}
      js_asset4 = %JSAsset{name: "themes", url: "https://example.com/themes.js", type: :umd}

      package1 = %AssetPackage{
        js: [js_asset1, js_asset2],
        css: ["https://example.com/editor.css", "https://example.com/ui.css"]
      }

      package2 = %AssetPackage{
        js: [js_asset3, js_asset4],
        css: ["https://example.com/plugins.css", "https://example.com/themes.css"]
      }

      result = AssetPackage.merge(package1, package2)

      assert result.js == [js_asset1, js_asset2, js_asset3, js_asset4]

      assert result.css == [
               "https://example.com/editor.css",
               "https://example.com/ui.css",
               "https://example.com/plugins.css",
               "https://example.com/themes.css"
             ]
    end

    test "preserves order when merging js assets" do
      js_asset1 = %JSAsset{name: "first", url: "https://example.com/first.js", type: :esm}
      js_asset2 = %JSAsset{name: "second", url: "https://example.com/second.js", type: :esm}
      js_asset3 = %JSAsset{name: "third", url: "https://example.com/third.js", type: :esm}

      package1 = %AssetPackage{js: [js_asset1]}
      package2 = %AssetPackage{js: [js_asset2, js_asset3]}

      result = AssetPackage.merge(package1, package2)

      assert result.js == [js_asset1, js_asset2, js_asset3]
    end

    test "preserves order when merging css assets" do
      package1 = %AssetPackage{css: ["https://example.com/first.css"]}

      package2 = %AssetPackage{
        css: ["https://example.com/second.css", "https://example.com/third.css"]
      }

      result = AssetPackage.merge(package1, package2)

      assert result.css == [
               "https://example.com/first.css",
               "https://example.com/second.css",
               "https://example.com/third.css"
             ]
    end

    test "allows duplicate js assets when merging" do
      js_asset = %JSAsset{name: "duplicate", url: "https://example.com/duplicate.js", type: :esm}

      package1 = %AssetPackage{js: [js_asset]}
      package2 = %AssetPackage{js: [js_asset]}

      result = AssetPackage.merge(package1, package2)

      assert result.js == [js_asset, js_asset]
      assert length(result.js) == 2
    end

    test "allows duplicate css assets when merging" do
      css_url = "https://example.com/duplicate.css"

      package1 = %AssetPackage{css: [css_url]}
      package2 = %AssetPackage{css: [css_url]}

      result = AssetPackage.merge(package1, package2)

      assert result.css == [css_url, css_url]
      assert length(result.css) == 2
    end
  end

  describe "type specs" do
    test "js_asset type matches JSAsset.t()" do
      js_asset = %JSAsset{name: "test", url: "https://example.com/test.js", type: :esm}
      package = %AssetPackage{js: [js_asset]}

      assert %AssetPackage{js: [%JSAsset{}]} = package
    end

    test "css_asset type is binary" do
      css_url = "https://example.com/test.css"
      package = %AssetPackage{css: [css_url]}

      assert %AssetPackage{css: [css_asset]} = package
      assert is_binary(css_asset)
    end
  end
end
