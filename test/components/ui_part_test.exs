defmodule CKEditor5.Components.UIPartTest do
  use ExUnit.Case, async: true

  import Phoenix.LiveViewTest

  alias CKEditor5.Components.UIPart

  test "renders UI part div with correct attributes" do
    html = render_component(&UIPart.render/1, name: "toolbar", editor_id: "editor-1")

    assert html =~ ~s(phx-hook="CKUIPart")
    assert html =~ ~s(data-cke-editor-id="editor-1")
    assert html =~ ~s(data-cke-ui-part-name="toolbar")
  end

  test "renders with only required name attribute" do
    html = render_component(&UIPart.render/1, name: "menubar")

    assert html =~ ~s(data-cke-ui-part-name="menubar")
  end

  test "it is possible to pass CSS class to component" do
    html =
      render_component(&UIPart.render/1,
        name: "toolbar",
        editor_id: "editor-1",
        class: "custom-class"
      )

    assert html =~ ~s(class="custom-class")
  end

  test "it is possible to pass CSS styles to component" do
    html =
      render_component(&UIPart.render/1,
        name: "toolbar",
        editor_id: "editor-1",
        style: "color: red;"
      )

    assert html =~ ~s(style="color: red;")
  end

  test "it should assign random ID if not provided" do
    html = render_component(&UIPart.render/1, name: "toolbar")
    assert html =~ ~s(id="cke-ui-part-)
    assert html =~ ~s(phx-hook="CKUIPart")
  end

  test "it assigns proper id if passed" do
    html = render_component(&UIPart.render/1, name: "toolbar", id: "custom-id")
    assert html =~ ~s(id="custom-id")
    assert html =~ ~s(phx-hook="CKUIPart")
  end
end
