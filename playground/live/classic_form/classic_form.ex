defmodule Playground.Live.ClassicForm do
  @moduledoc """
  LiveView for demonstrating CKEditor5 Classic integration with a form.
  """

  alias Phoenix.Component

  use Playground, :live_view
  use CKEditor5

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       saved: false,
       error: nil,
       form: Component.to_form(%{"content" => "Initial content"}, as: :form)
     )}
  end

  @impl true
  def handle_event("validate", %{"form" => form}, socket) do
    socket
    |> assign(form: Component.to_form(form, as: :form))
    |> assign_error(form)
    |> then(&{:noreply, &1})
  end

  @impl true
  def handle_event("save", %{"form" => form}, socket) do
    socket =
      socket
      |> assign(form: Component.to_form(form, as: :form))
      |> assign_error(form)

    if socket.assigns[:error] do
      {:noreply, assign(socket, saved: false)}
    else
      {:noreply, assign(socket, saved: true, error: nil)}
    end
  end

  defp assign_error(socket, form) do
    error =
      if String.trim(form["content"] || "") == "" do
        "Content can't be blank"
      else
        nil
      end

    assign(socket, error: error)
  end
end
