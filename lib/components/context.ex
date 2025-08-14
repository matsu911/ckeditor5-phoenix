defmodule CKEditor5.Components.Context do
  @moduledoc """
  A component for rendering a CKEditor5 context.
  """

  use Phoenix.Component

  alias CKEditor5.{Context, Contexts}

  attr :id, :string,
    required: false,
    default: nil,
    doc:
      "The ID of the context to be used. The ID should be used to determine which context should be used by the editor."

  attr :context, :any,
    required: true,
    doc: "The name or reference of the context to be used."

  slot :inner_block,
    required: false,
    doc:
      "Optional content of the context. Every editor instance within block will use this context."

  attr :rest, :global

  def render(assigns) do
    assigns = load_context(assigns)

    ~H"""
    <div
      id={@id}
      phx-hook="CKContext"
      phx-update="ignore"
      cke-context={Jason.encode!(@context)}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  # Loads the preset configuration from the preset name
  defp load_context(%{context: %Context{}} = assigns), do: assigns

  defp load_context(%{context: preset} = assigns) when is_binary(preset) do
    preset = Contexts.get!(preset)

    Map.put(assigns, :context, preset)
  end
end
