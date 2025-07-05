defmodule CKEditor5.Components.Editor do
  @moduledoc """
  LiveView component for CKEditor 5 integration in Phoenix Framework.

  This module provides the necessary functionality to render and manage
  CKEditor 5 instances within Phoenix LiveView applications.
  """

  use Phoenix.LiveComponent

  alias CKEditor5.Helpers

  @doc """
  Renders the CKEditor 5 component in a LiveView.

  ## Attributes
    * `:id` - Optional string ID for the editor instance
    * `:preset` - Optional string preset name (defaults to "default")
    * `:editable_height` - Optional string to set the height of the editable area
      (e.g., "300px"). If not provided, the height will be determined by the editor's content.
    * `:rest` - Global attributes passed to the container div
  """
  attr :id, :string, required: false
  attr :preset, :string, default: "default"
  attr :editable_height, :string, required: false
  attr :rest, :global

  def render(assigns) do
    assigns =
      assigns
      |> Helpers.assign_id_if_missing("cke")
      |> assign_loaded_preset()
      |> normalize_editable_height()

    ~H"""
    <div
      id={@id}
      phx-update="ignore"
      phx-hook="CKEditor5"
      cke-preset={Jason.encode!(@preset)}
      cke-editable-height={@editable_height}
      {@rest}
    >
    </div>
    """
  end

  defp assign_loaded_preset(assigns) do
    preset = CKEditor5.Presets.get!(assigns.preset)

    Map.put(assigns, :preset, preset)
  end

  def normalize_editable_height(%{editable_height: nil} = assigns), do: assigns

  def normalize_editable_height(%{editable_height: editable_height} = assigns) do
    normalized_height =
      if is_binary(editable_height) && String.ends_with?(editable_height, "px") do
        editable_height |> String.slice(0..-3//1)
      else
        editable_height
      end

    Map.put(assigns, :editable_height, normalized_height)
  end
end
