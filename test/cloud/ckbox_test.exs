defmodule CKEditor5.Cloud.CKBoxTest do
  use ExUnit.Case, async: true

  alias CKEditor5.Cloud.CKBox
  alias CKEditor5.Errors

  describe "s/0" do
    test "validates a correct ckbox configuration map" do
      valid_config = %{
        version: "35.4.0",
        theme: "default"
      }

      assert {:ok, _} = Norm.conform(valid_config, CKBox.s())
    end

    test "validates a ckbox configuration map without theme" do
      valid_config = %{
        version: "35.4.0"
      }

      assert {:ok, _} = Norm.conform(valid_config, CKBox.s())
    end

    test "returns an error for an invalid version" do
      invalid_config = %{version: "35"}
      {:error, errors} = Norm.conform(invalid_config, CKBox.s())
      assert Enum.any?(errors, &(&1.path == [:version]))
    end
  end

  describe "parse/1" do
    test "parses nil and returns {:ok, nil}" do
      assert CKBox.parse(nil) == {:ok, nil}
    end

    test "parses a valid map with version and theme" do
      config = %{version: "36.0.0", theme: "dark"}
      {:ok, ckbox} = CKBox.parse(config)

      assert %CKBox{
               version: "36.0.0",
               theme: "dark"
             } = ckbox
    end

    test "parses a valid map with only version" do
      config = %{version: "36.0.0"}
      {:ok, ckbox} = CKBox.parse(config)

      assert %CKBox{
               version: "36.0.0",
               theme: nil
             } = ckbox
    end

    test "returns an error when version is missing" do
      config = %{theme: "dark"}

      assert {:error, [%{input: %{theme: "dark"}, path: [:version], spec: ":required"}]} =
               CKBox.parse(config)
    end

    test "returns an error for an invalid map" do
      assert {:error, _} = CKBox.parse(%{version: "invalid"})
    end

    test "returns an error for non-map input" do
      assert {:error, "CKBox configuration must be a map or nil"} = CKBox.parse("string")
    end
  end

  describe "parse!/1" do
    test "parses a valid map and returns a CKBox struct" do
      config = %{version: "36.0.0", theme: "light"}
      ckbox = CKBox.parse!(config)

      assert %CKBox{
               version: "36.0.0",
               theme: "light"
             } = ckbox
    end

    test "raises an error for invalid input" do
      assert_raise Errors.InvalidCloudConfiguration, fn ->
        CKBox.parse!("invalid")
      end
    end
  end

  describe "merge/2" do
    test "merges nil with nil returns nil" do
      assert CKBox.merge(nil, nil) == nil
    end

    test "merges nil with valid overrides returns parsed struct" do
      overrides = %{version: "36.0.0", theme: "dark"}
      result = CKBox.merge(nil, overrides)

      assert %CKBox{
               version: "36.0.0",
               theme: "dark"
             } = result
    end

    test "merges nil with invalid overrides returns nil" do
      invalid_overrides = %{version: "invalid"}
      result = CKBox.merge(nil, invalid_overrides)

      assert result == nil
    end

    test "merges struct with nil returns nil" do
      ckbox = %CKBox{version: "35.0.0", theme: "light"}
      result = CKBox.merge(ckbox, nil)

      assert result == nil
    end

    test "merges struct with valid overrides" do
      ckbox = %CKBox{version: "35.0.0", theme: "light"}
      overrides = %{version: "36.0.0"}
      result = CKBox.merge(ckbox, overrides)

      assert %CKBox{
               version: "36.0.0",
               theme: "light"
             } = result
    end

    test "merges struct with partial overrides preserves original values" do
      ckbox = %CKBox{version: "35.0.0", theme: "light"}
      overrides = %{theme: "dark"}
      result = CKBox.merge(ckbox, overrides)

      assert %CKBox{
               version: "35.0.0",
               theme: "dark"
             } = result
    end

    test "merges struct with complete overrides" do
      ckbox = %CKBox{version: "35.0.0", theme: "light"}
      overrides = %{version: "37.0.0", theme: "custom"}
      result = CKBox.merge(ckbox, overrides)

      assert %CKBox{
               version: "37.0.0",
               theme: "custom"
             } = result
    end

    test "merges struct with empty overrides preserves original" do
      ckbox = %CKBox{version: "35.0.0", theme: "light"}
      overrides = %{}
      result = CKBox.merge(ckbox, overrides)

      assert %CKBox{
               version: "35.0.0",
               theme: "light"
             } = result
    end

    test "merges struct with struct" do
      ckbox = %CKBox{version: "35.0.0", theme: "light"}
      override_struct = %CKBox{version: "36.0.0", theme: "dark"}
      result = CKBox.merge(ckbox, override_struct)

      assert %CKBox{
               version: "36.0.0",
               theme: "dark"
             } = result
    end
  end
end
