defmodule CKEditor5.License.AssertionsTest do
  use ExUnit.Case, async: true

  alias CKEditor5.License
  alias CKEditor5.License.Assertions

  describe "gpl?/1" do
    test "returns true for GPL license struct" do
      assert Assertions.gpl?(%License{key: "GPL", distribution_channel: nil})
    end

    test "returns true for GPL license string" do
      assert Assertions.gpl?("GPL")
    end

    test "returns false for other license structs" do
      refute Assertions.gpl?(%License{key: "some-key", distribution_channel: nil})
    end

    test "returns false for other strings" do
      refute Assertions.gpl?("some-key")
    end
  end

  describe "distribution?/2" do
    test "returns true when distribution matches" do
      assert Assertions.distribution?(
               %License{key: "some-key", distribution_channel: "cloud"},
               "cloud"
             )
    end

    test "returns false when distribution does not match" do
      refute Assertions.distribution?(
               %License{key: "some-key", distribution_channel: "sh"},
               "cloud"
             )
    end

    test "returns false when license has no distribution" do
      refute Assertions.distribution?(
               %License{key: "some-key", distribution_channel: nil},
               "cloud"
             )
    end
  end

  describe "cloud_distribution?/1" do
    test "returns true for cloud distribution" do
      assert Assertions.cloud_distribution?(%License{
               key: "some-key",
               distribution_channel: "cloud"
             })
    end

    test "returns false for other distributions" do
      refute Assertions.cloud_distribution?(%License{
               key: "some-key",
               distribution_channel: "sh"
             })
    end
  end

  describe "npm_distribution?/1" do
    test "returns true for npm distribution" do
      assert Assertions.npm_distribution?(%License{key: "some-key", distribution_channel: "sh"})
    end

    test "returns false for other distributions" do
      refute Assertions.npm_distribution?(%License{
               key: "some-key",
               distribution_channel: "cloud"
             })
    end
  end

  describe "compatible_distribution?/2" do
    test "returns true for GPL license" do
      assert Assertions.compatible_distribution?(
               %License{key: "GPL", distribution_channel: nil},
               "cloud"
             )

      assert Assertions.compatible_distribution?(
               %License{key: "GPL", distribution_channel: nil},
               "sh"
             )
    end

    test "returns true when license has no distribution" do
      assert Assertions.compatible_distribution?(
               %License{key: "some-key", distribution_channel: nil},
               "cloud"
             )
    end

    test "returns true when distribution matches" do
      assert Assertions.compatible_distribution?(
               %License{key: "some-key", distribution_channel: "cloud"},
               "cloud"
             )
    end

    test "returns false when distribution does not match" do
      refute Assertions.compatible_distribution?(
               %License{key: "some-key", distribution_channel: "sh"},
               "cloud"
             )
    end
  end

  describe "compatible_cloud_distribution?/1" do
    test "returns true for cloud distribution" do
      assert Assertions.compatible_cloud_distribution?(%License{
               key: "some-key",
               distribution_channel: "cloud"
             })
    end

    test "returns true for GPL license" do
      assert Assertions.compatible_cloud_distribution?(%License{
               key: "GPL",
               distribution_channel: nil
             })
    end

    test "returns false for other distributions" do
      refute Assertions.compatible_cloud_distribution?(%License{
               key: "some-key",
               distribution_channel: "sh"
             })
    end
  end

  describe "compatible_npm_distribution?/1" do
    test "returns true for npm distribution" do
      assert Assertions.compatible_npm_distribution?(%License{
               key: "some-key",
               distribution_channel: "sh"
             })
    end

    test "returns true for GPL license" do
      assert Assertions.compatible_npm_distribution?(%License{
               key: "GPL",
               distribution_channel: nil
             })
    end

    test "returns false for other distributions" do
      refute Assertions.compatible_npm_distribution?(%License{
               key: "some-key",
               distribution_channel: "cloud"
             })
    end
  end
end
