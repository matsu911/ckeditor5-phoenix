defmodule CKEditor5.Preset.EditorTypeTest do
  use ExUnit.Case, async: true

  doctest CKEditor5.Preset.EditorType

  alias CKEditor5.Preset.EditorType

  describe "valid?/1" do
    test "returns true for valid editor types" do
      assert EditorType.valid?(:inline)
      assert EditorType.valid?(:classic)
      assert EditorType.valid?(:balloon)
      assert EditorType.valid?(:decoupled)
      assert EditorType.valid?(:multiroot)
    end

    test "returns false for an invalid editor type" do
      refute EditorType.valid?(:invalid_type)
    end
  end

  describe "single_editing_like?/1" do
    test "returns true for single editing-like editor types" do
      assert EditorType.single_editing_like?(:inline)
      assert EditorType.single_editing_like?(:classic)
      assert EditorType.single_editing_like?(:balloon)
      assert EditorType.single_editing_like?(:decoupled)
    end

    test "returns false for non-single editing-like editor types" do
      refute EditorType.single_editing_like?(:multiroot)
    end

    test "returns false for invalid types" do
      refute EditorType.single_editing_like?(:foo)
    end
  end
end
