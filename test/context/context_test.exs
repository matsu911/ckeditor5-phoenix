defmodule CKEditor5.ContextTest do
  use ExUnit.Case, async: true

  alias CKEditor5.{Context, Errors}

  describe "parse/1" do
    test "returns {:ok, nil} for nil input" do
      assert Context.parse(nil) == {:ok, nil}
    end

    test "returns {:ok, context} for valid map" do
      map = %{config: %{plugins: ["foo"]}}
      assert {:ok, %Context{config: %{plugins: ["foo"]}}} = Context.parse(map)
    end

    test "returns {:ok, context} for struct input" do
      struct = %Context{config: %{plugins: ["bar"]}}
      assert Context.parse(struct) == {:ok, struct}
    end

    test "returns {:error, reason} for invalid map" do
      assert {:error, _} = Context.parse(%{invalid: true})
    end

    test "returns error for non-map, non-nil input" do
      assert Context.parse("not a map") == {:error, "Context configuration must be a map or nil"}
    end
  end

  describe "parse!/1" do
    test "returns struct for valid map" do
      map = %{config: %{plugins: ["foo"]}}
      assert %Context{config: %{plugins: ["foo"]}} = Context.parse!(map)
    end

    test "raises for invalid map" do
      assert_raise Errors.InvalidContext, fn ->
        Context.parse!(%{invalid: true})
      end
    end

    test "returns an error if custom translations are invalid" do
      map = %{custom_translations: %{en: nil}, config: %{}}
      assert {:error, [_ | _]} = Context.parse(map)
    end
  end
end
