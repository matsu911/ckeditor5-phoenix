defmodule CKEditor5.Components.HiddenInput do
  @moduledoc """
  LiveView component for rendering a hidden input field.
  """

  use Phoenix.Component

  alias CKEditor5.Helpers

  attr :id, :string, required: true, doc: "The ID of the hidden input."
  attr :name, :string, required: true, doc: "The name of the hidden input."
  attr :value, :string, required: false, default: "", doc: "The value of the hidden input."
  attr :required, :boolean, default: false, doc: "Whether the input is required."

  @doc """
  Renders a hidden input field with the specified attributes.
  """
  def render(assigns) do
    ~H"""
    <input
      id={@id}
      name={@name}
      value={@value}
      required={@required}
      type="hidden"
      style={
        Helpers.serialize_styles_map(%{
          display: "flex",
          width: "100%",
          height: "1px",
          opacity: "0",
          "pointer-events": "none",
          margin: "0",
          padding: "0",
          border: "none"
        })
      }
    />
    """
  end
end
