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
    * `:config` - Optional map with CKEditor 5 configuration
    * `:preset` - Optional string preset name (defaults to "default")
    * `:rest` - Global attributes passed to the container div
  """
  attr :id, :string, required: false
  attr :config, :map, required: false
  attr :preset, :string, default: "default"
  attr :rest, :global

  def render(assigns) do
    assigns =
      assigns
      |> Helpers.assign_id_if_missing("cke")
      |> assign_config_if_missing()

    ~H"""
    <div
      id={@id}
      phx-update="ignore"
      phx-hook="CKEditor5"
      cke-config={Jason.encode!(@config)}
      {@rest}
    >
    </div>
    """
  end

  defp assign_config_if_missing(%{config: _} = assigns), do: assigns

  defp assign_config_if_missing(assigns) do
    config = CKEditor5.Presets.get!(assigns.preset)

    Map.put(assigns, :config, config)
  end
end
