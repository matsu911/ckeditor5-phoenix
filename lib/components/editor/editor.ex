defmodule CKEditor5.Components.Editor do
  @moduledoc """
  LiveView component for CKEditor 5 integration in Phoenix Framework.

  This module provides the necessary functionality to render and manage
  CKEditor 5 instances within Phoenix LiveView applications.
  """

  use Phoenix.LiveComponent

  import CKEditor5.Components.FormAttrs

  alias CKEditor5.Components.Editor.Assigns
  alias CKEditor5.Components.HiddenInput

  @doc """
  Renders the CKEditor 5 component in a LiveView.
  """
  attr :id, :string, required: false, doc: "The ID for the editor instance."

  attr :class, :string,
    required: false,
    default: "",
    doc: "Additional CSS classes to apply to the editor container."

  attr :style, :string,
    required: false,
    default: "",
    doc: "Inline styles to apply to the editor container."

  attr :preset, :string, default: "default", doc: "The name of the preset to use."

  attr :change_event, :boolean,
    default: false,
    doc:
      "Whether the editor should push events to the LiveView. If true, the editor will send `ckeditor5:change` event every time the content changes."

  attr :editable_height, :string,
    default: nil,
    required: false,
    doc:
      "The height of the editable area (e.g., \"300px\"). If not provided, the height will be determined by the editor's content."

  attr :save_debounce_ms, :integer,
    default: 400,
    required: false,
    doc: "Debounce time in ms for saving/syncing editor content."

  attr :type, :string,
    required: false,
    default: nil,
    doc: "The type of the editor. Overrides the type from the preset."

  attr :language, :string,
    required: false,
    default: nil,
    doc:
      "The language code for the editor UI (e.g., 'en', 'pl', 'de', etc.). If not provided, will use the default \"en\" language."

  attr :content_language, :string,
    required: false,
    default: nil,
    doc:
      "The content language code for the editor (e.g. 'en', 'pl', 'de', etc.). This is used to set the `lang` attribute on the editable area. " <>
        "If not provided, it will default to the same value as `language`."

  form_attrs()

  def render(assigns) do
    assigns = Assigns.prepare(assigns)

    ~H"""
    <div
      id={@id}
      class={@class}
      style={@style}
      phx-hook="CKEditor5"
      phx-update="ignore"
      cke-preset={Jason.encode!(@preset)}
      cke-editable-height={@editable_height}
      cke-initial-value={@value || ""}
      cke-change-event={@change_event}
      cke-save-debounce-ms={@save_debounce_ms}
      cke-language={@language}
      cke-content-language={@content_language}
    >
      <div id={"#{@id}_editor"}></div>
      <%= if @name do %>
        <HiddenInput.render
          id={"#{@id}_input"}
          name={@name}
          value={@value}
          required={@required}
        />
      <% end %>
    </div>
    """
  end
end
