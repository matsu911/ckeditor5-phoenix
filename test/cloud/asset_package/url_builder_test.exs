defmodule CKEditor5.Cloud.UrlBuilderTest do
  use ExUnit.Case, async: true

  alias CKEditor5.Cloud.UrlBuilder

  describe "build_url/1" do
    test "builds the URL from a list of path segments" do
      path_segments = ["foo", "bar", "baz"]
      expected_url = "https://cdn.ckeditor.com/foo/bar/baz"

      assert UrlBuilder.build_url(path_segments) == expected_url
    end

    test "builds the URL from a single resource path" do
      resource_path = "foo/bar/baz"
      expected_url = "https://cdn.ckeditor.com/foo/bar/baz"

      assert UrlBuilder.build_url(resource_path) == expected_url
    end

    test "handles an empty list of path segments" do
      path_segments = []
      expected_url = "https://cdn.ckeditor.com/"

      assert UrlBuilder.build_url(path_segments) == expected_url
    end

    test "handles an empty resource path" do
      resource_path = ""
      expected_url = "https://cdn.ckeditor.com/"

      assert UrlBuilder.build_url(resource_path) == expected_url
    end

    test "handles a list with a single path segment" do
      path_segments = ["foo"]
      expected_url = "https://cdn.ckeditor.com/foo"

      assert UrlBuilder.build_url(path_segments) == expected_url
    end
  end
end
