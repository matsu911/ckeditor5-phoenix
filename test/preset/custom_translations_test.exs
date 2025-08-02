defmodule CKEditor5.Preset.CustomTranslationsTest do
  use ExUnit.Case, async: true

  alias CKEditor5.Errors.InvalidCustomTranslations
  alias CKEditor5.Preset.CustomTranslations

  describe "parse/1" do
    test "with valid translations returns ok" do
      translations = %{"en" => %{"foo" => "bar"}}

      assert {:ok, %CustomTranslations{dictionary: ^translations}} =
               CustomTranslations.parse(translations)
    end

    test "with valid translations with list value returns ok" do
      translations = %{"en" => %{"foo" => ["bar", "baz"]}}

      assert {:ok, %CustomTranslations{dictionary: ^translations}} =
               CustomTranslations.parse(translations)
    end

    test "with valid translations with atom keys returns ok" do
      translations = %{en: %{foo: "bar"}}

      assert {:ok, %CustomTranslations{dictionary: ^translations}} =
               CustomTranslations.parse(translations)
    end

    test "with nil returns ok with nil" do
      assert {:ok, nil} == CustomTranslations.parse(nil)
    end

    test "with non-map value returns an error" do
      assert {:error, "Custom translations must be a map or nil"} ==
               CustomTranslations.parse("not a map")
    end

    test "with invalid structure returns an error" do
      translations = %{:en => nil}
      assert {:error, _} = CustomTranslations.parse(translations)
    end
  end

  describe "parse!/1" do
    test "with valid translations returns a struct" do
      translations = %{"en" => %{"foo" => "bar"}}

      assert %CustomTranslations{dictionary: ^translations} =
               CustomTranslations.parse!(translations)
    end

    test "with invalid data raises an error" do
      assert_raise InvalidCustomTranslations, fn ->
        CustomTranslations.parse!("not a map")
      end
    end
  end

  describe "merge/2" do
    test "merges two CustomTranslations structs" do
      base = CustomTranslations.parse!(%{"en" => %{"foo" => "bar"}, "pl" => %{"a" => "b"}})
      overrides = CustomTranslations.parse!(%{"en" => %{"baz" => "qux"}, "de" => %{"c" => "d"}})

      expected = %{
        "en" => %{"foo" => "bar", "baz" => "qux"},
        "pl" => %{"a" => "b"},
        "de" => %{"c" => "d"}
      }

      assert %CustomTranslations{dictionary: ^expected} =
               CustomTranslations.merge(base, overrides)
    end

    test "merges two maps" do
      base = %{"en" => %{"foo" => "bar"}, "pl" => %{"a" => "b"}}
      overrides = %{"en" => %{"baz" => "qux"}, "de" => %{"c" => "d"}}

      expected = %{
        "en" => %{"foo" => "bar", "baz" => "qux"},
        "pl" => %{"a" => "b"},
        "de" => %{"c" => "d"}
      }

      assert %CustomTranslations{dictionary: ^expected} =
               CustomTranslations.merge(base, overrides)
    end

    test "merges with nil" do
      translations = %{"en" => %{"foo" => "bar"}}
      struct = CustomTranslations.parse!(translations)

      assert CustomTranslations.merge(struct, nil) == struct
      assert CustomTranslations.merge(nil, struct) == struct
      assert CustomTranslations.merge(nil, nil) == nil
    end
  end
end
