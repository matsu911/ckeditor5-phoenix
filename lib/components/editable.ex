defmodule CKEditor5.Components.Editable do
  @moduledoc """
  Live View component for rendering an editable area in CKEditor 5.
  It may be used with decoupled editors or multiroot editors.
  """

  use Phoenix.Component

  attr :name, :string,
    required: true,
    doc: """
    The name of the editable area. This will be used to identify the editable
    in the output editor data.
    """

  attr :editor_id, :string,
    default: nil,
    doc: """
    The ID of the editor instance this editable belongs to. If not provided,
    the first editor in the page will be used.
    """

  attr :value, :string,
    default: "",
    doc: """
    The initial value for the editable area. This will be set as the content
    of the editable when the editor is initialized.
    """

  attr :rest, :global

  def render(assigns) do
    ~H"""
    <div
      id={@name}
      data-cke-editor-id={@editor_id}
      data-cke-editable-name={@name}
      data-cke-editable-initial-value={@value}
      {@rest}
    />
    """
  end
end
