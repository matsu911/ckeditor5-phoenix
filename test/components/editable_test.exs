defmodule CKEditor5.Components.EditableTest do
  use ExUnit.Case, async: true

  import Phoenix.LiveViewTest

  alias CKEditor5.Components.Editable

  test "renders editable with all attributes and hidden input" do
    html =
      render_component(&Editable.render/1,
        root: "main",
        editor_id: "editor-1",
        name: "content",
        value: "Hello",
        required: true
      )

    assert html =~ ~s(phx-hook="CKEditable")
    assert html =~ ~s(data-cke-editor-id="editor-1")
    assert html =~ ~s(data-cke-editable-root-name="main")
    assert html =~ ~s(data-cke-editable-initial-value="Hello")
    assert html =~ ~s(data-cke-editable-required)
    assert html =~ ~s(<input)
    assert html =~ ~s(name="content")
    assert html =~ ~s(value="Hello")
    assert html =~ ~s(required)
  end

  test "renders editable without name (no hidden input)" do
    html = render_component(&Editable.render/1, root: "main", editor_id: "editor-1")

    assert html =~ ~s(phx-hook="CKEditable")
    assert html =~ ~s(data-cke-editable-root-name="main")
    refute html =~ ~s(<input)
  end
end
