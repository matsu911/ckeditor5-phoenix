defmodule CKEditor5.Cloud.CKEditorCloudUrlBuilderTest do
  use ExUnit.Case, async: true

  alias CKEditor5.Cloud.CKEditorCloudUrlBuilder

  describe "build_url/2 with cdn_type" do
    test "builds CKEditor URL from a list of path segments" do
      path_segments = ["foo", "bar", "baz"]
      expected_url = "https://cdn.ckeditor.com/foo/bar/baz"

      assert CKEditorCloudUrlBuilder.build_url(:ckeditor, path_segments) == expected_url
    end

    test "builds CKBox URL from a list of path segments" do
      path_segments = ["foo", "bar", "baz"]
      expected_url = "https://cdn.ckbox.io/foo/bar/baz"

      assert CKEditorCloudUrlBuilder.build_url(:ckbox, path_segments) == expected_url
    end
  end
end
