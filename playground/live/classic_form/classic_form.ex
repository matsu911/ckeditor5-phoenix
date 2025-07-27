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
       form: Component.to_form(%{"content" => "Initial content"}, as: :form)
     )}
  end

  @impl true
  def handle_event("validate", %{"form" => form}, socket) do
    {:noreply, assign(socket, saved: false, form: Component.to_form(form, as: :form))}
  end

  @impl true
  def handle_event("save", %{"form" => form}, socket) do
    {:noreply, assign(socket, saved: true, form: Component.to_form(form, as: :form))}
  end
end
