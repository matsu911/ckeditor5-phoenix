defmodule CKEditor5.Components.EditorTest do
  use ExUnit.Case, async: true

  import Phoenix.LiveViewTest

  alias CKEditor5.Components.Editor
  alias CKEditor5.Errors.Error
  alias CKEditor5.Test.PresetsHelper
  alias Phoenix.HTML

  setup do
    original =
      PresetsHelper.put_presets_env(%{"mock" => %{type: :inline, config: %{toolbar: ["bold"]}}})

    on_exit(fn -> PresetsHelper.restore_presets_env(original) end)
    :ok
  end

  test "renders editor with default attributes" do
    html = render_component(&Editor.render/1, id: "editor1", name: "content", value: "Hello")
    assert html =~ ~s(phx-hook="CKEditor5")
    assert html =~ ~s(id="editor1")
    assert html =~ ~s(cke-initial-value="Hello")
    assert html =~ ~s(<div id="editor1_editor"></div>)
    assert html =~ ~s(<input)
  end

  test "renders editor without name (no hidden input)" do
    html = render_component(&Editor.render/1, id: "editor3", value: "No input")
    refute html =~ ~s(<input)
  end

  describe "preset type handling" do
    test "uses classic type when no type and preset are specified" do
      html = render_component(&Editor.render/1, id: "editor1", name: "content")
      assert html =~ ~s(type&quot;:&quot;classic&quot;)
    end

    test "uses type defined in custom preset" do
      html = render_component(&Editor.render/1, id: "editor1", name: "content", preset: "mock")
      assert html =~ ~s(type&quot;:&quot;inline&quot;)
    end

    test "uses type defined as string in custom preset" do
      html =
        render_component(&Editor.render/1,
          id: "editor1",
          name: "content",
          preset: "mock",
          type: "inline"
        )

      assert html =~ ~s(type&quot;:&quot;inline&quot;)
    end

    test "overrides editor type to classic when type is set to :classic" do
      html =
        render_component(&Editor.render/1,
          id: "editor2",
          name: "content2",
          preset: "mock",
          type: :classic
        )

      assert html =~ ~s(type&quot;:&quot;classic&quot;)
    end

    test "throws error for invalid type" do
      message = "Invalid editor type provided: invalid_type"

      assert_raise Error, message, fn ->
        render_component(&Editor.render/1, id: "editor3", name: "content3", type: :invalid_type)
      end
    end
  end

  describe "editable height handling" do
    test "sets editable height when specified" do
      html =
        render_component(&Editor.render/1,
          id: "editor4",
          name: "content4",
          editable_height: "300px"
        )

      assert html =~ ~s(cke-editable-height="300")
    end

    test "does not set editable height when not specified" do
      html = render_component(&Editor.render/1, id: "editor5", name: "content5")
      refute html =~ ~s(cke-editable-height)
    end

    test "not sets editable height when set to nil" do
      html =
        render_component(&Editor.render/1, id: "editor6", name: "content6", editable_height: nil)

      refute html =~ ~s(cke-editable-height)
    end

    test "sets editable height even if it does not end with px" do
      html =
        render_component(&Editor.render/1,
          id: "editor7",
          name: "content7",
          editable_height: "300"
        )

      assert html =~ ~s(cke-editable-height="300")
    end

    test "sets editable height if value is number" do
      html =
        render_component(&Editor.render/1, id: "editor8", name: "content8", editable_height: 300)

      assert html =~ ~s(cke-editable-height="300")
    end
  end

  describe "validate attributes for editor type" do
    def error_message(attr, preset_type, hint) do
      "The `#{attr}` attribute is not supported for editor type '#{preset_type}'. #{hint}"
    end

    test "raises disallowed attributes for non-single-editing editors" do
      assert_raise Error,
                   error_message(:name, "multiroot", "Remove the `field` and `name` attributes."),
                   fn ->
                     render_component(&Editor.render/1,
                       id: "editor9",
                       name: "content9",
                       type: :multiroot
                     )
                   end
    end

    test "raises disallowed value attribute for non-single-editing editors" do
      assert_raise Error,
                   error_message(
                     :value,
                     "multiroot",
                     "Use the `<.cke_editable>` component to set content instead."
                   ),
                   fn ->
                     render_component(&Editor.render/1,
                       id: "editor10",
                       value: "test",
                       type: :multiroot
                     )
                   end
    end

    test "raises disallowed editable_height attribute for non-single-editing editors" do
      assert_raise Error,
                   error_message(
                     :editable_height,
                     "multiroot",
                     "Set height on individual editable areas if needed."
                   ),
                   fn ->
                     render_component(&Editor.render/1,
                       id: "editor11",
                       editable_height: "300px",
                       type: :multiroot
                     )
                   end
    end

    test "raises disallowed required attribute for non-single-editing editors" do
      assert_raise Error,
                   error_message(
                     :required,
                     "multiroot",
                     "The `required` attribute is only for form integration."
                   ),
                   fn ->
                     render_component(&Editor.render/1,
                       id: "editor12",
                       required: true,
                       type: :multiroot
                     )
                   end
    end

    test "should not raise any error if no disallowed attributes are present for non-single-editing editors" do
      html = render_component(&Editor.render/1, id: "editor13", type: :multiroot)
      assert html =~ ~s(id="editor13")
    end
  end

  describe "form support" do
    test "renders hidden input with correct name from :name attribute" do
      html =
        render_component(&Editor.render/1, id: "editor_form1", name: "my_content", value: "abc")

      assert html =~ ~s(<input)
      assert html =~ ~s(name="my_content")
    end

    test "renders hidden input with correct name from :field attribute (Phoenix.HTML.FormField)" do
      form = %HTML.Form{
        source: nil,
        id: "f",
        name: "f",
        params: %{},
        hidden: [],
        options: [],
        errors: [],
        data: %{}
      }

      field = %HTML.FormField{
        form: form,
        field: :body,
        name: "f[body]",
        id: "f_body",
        value: "test123",
        errors: []
      }

      html = render_component(&Editor.render/1, id: "editor_form2", field: field)

      assert html =~ ~s(<input)
      assert html =~ ~s(name="f[body]")
    end

    test "does not render hidden input if no name, field or form is given" do
      html = render_component(&Editor.render/1, id: "editor_form4", value: "noinput")
      refute html =~ ~s(<input)
    end
  end
end
