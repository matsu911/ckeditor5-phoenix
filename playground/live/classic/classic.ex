defmodule Playground.Live.Classic do
  @moduledoc """
  HTML module for the classic editor page of the playground application.
  """

  use Playground, :live_view
  use CKEditor5

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, editor_value: "Hello World!")}
  end

  @impl true
  def handle_event("ckeditor5:change", %{"data" => data}, socket) do
    {:noreply, assign(socket, editor_value: data["main"])}
  end
end
