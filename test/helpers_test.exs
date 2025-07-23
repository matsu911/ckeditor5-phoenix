defmodule CKEditor5.HelpersTest do
  use ExUnit.Case, async: true

  alias CKEditor5.Helpers

  describe "is_semver_version?/1" do
    test "returns true for valid semver" do
      assert Helpers.is_semver_version?("1.0.0")
      assert Helpers.is_semver_version?("2.3.4-beta.1")
      assert Helpers.is_semver_version?("0.0.1-alpha")
    end

    test "returns false for invalid semver" do
      refute Helpers.is_semver_version?("1.0")
      refute Helpers.is_semver_version?("v1.0.0")
      refute Helpers.is_semver_version?("1.0.0.0")
      refute Helpers.is_semver_version?("abc")
    end
  end

  describe "serialize_styles_map/1" do
    test "serializes a map of styles to CSS string" do
      styles = %{color: "red", "font-size": "16px"}
      css = Helpers.serialize_styles_map(styles)
      assert css == "color: red; font-size: 16px" or css == "font-size: 16px; color: red"
    end

    test "returns empty string for empty map" do
      assert Helpers.serialize_styles_map(%{}) == ""
    end
  end
end
