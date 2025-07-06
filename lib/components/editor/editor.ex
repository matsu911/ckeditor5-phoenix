defmodule CKEditor5.Components.Editor do
  @moduledoc """
  LiveView component for CKEditor 5 integration in Phoenix Framework.

  This module provides the necessary functionality to render and manage
  CKEditor 5 instances within Phoenix LiveView applications.
  """

  use Phoenix.LiveComponent

  alias CKEditor5.Components.Editor.Assigns
  alias CKEditor5.Components.HiddenInput
  alias CKEditor5.Helpers

  @doc """
  Renders the CKEditor 5 component in a LiveView.
  """
  attr :id, :string, required: false, doc: "The ID for the editor instance."
  attr :preset, :string, default: "default", doc: "The name of the preset to use."

  attr :editable_height, :string,
    default: nil,
    required: false,
    doc:
      "The height of the editable area (e.g., \"300px\"). If not provided, the height will be determined by the editor's content."

  attr :type, :string,
    required: false,
    default: nil,
    doc: "The type of the editor. Overrides the type from the preset."

  attr :name, :string,
    required: false,
    default: nil,
    doc:
      "The name for the editor, used for form integration. If not provided, it will be derived from the `:field` attribute."

  attr :field, Phoenix.HTML.FormField,
    required: false,
    default: nil,
    doc: "The `Phoenix.HTML.FormField` for form integration."

  attr :form, :any,
    required: false,
    default: nil,
    doc: "The `Phoenix.HTML.Form` for form integration."

  attr :value, :string,
    required: false,
    default: "",
    doc: "The initial value for the editor content."

  attr :required, :boolean,
    default: false,
    doc: "Indicates if the editor is required, used for form validation."

  attr :rest, :global

  def render(assigns) do
    assigns =
      assigns
      |> Helpers.assign_id_if_missing("cke")
      |> Assigns.prepare()

    ~H"""
    <div
      id={@id}
      phx-update="ignore"
      phx-hook="CKEditor5"
      cke-preset={Jason.encode!(@preset)}
      cke-editable-height={@editable_height}
      cke-initial-value={@value || ""}
      {@rest}
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
