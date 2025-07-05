defmodule Playground.Components.Layout do
  @moduledoc """
  Phoenix components used throughout the playground application.

  This module contains reusable UI components for the playground interface.
  """

  use Phoenix.Component

  import Phoenix.VerifiedRoutes, warn: false

  @endpoint Playground.Endpoint
  @router Playground.Router

  @doc """
  Renders the main layout for the playground application.
  """
  slot :head, doc: "Additional head content"
  slot :inner_content, required: true, doc: "Main content of the page"
  attr :page_title, :string, default: nil, doc: "Page title"

  def layout(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en" class="[scrollbar-gutter:stable]">
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <meta name="csrf-token" content={Plug.CSRFProtection.get_csrf_token()} />

        <.live_title default="Playground" suffix=" · Phoenix Framework">
          {@page_title}
        </.live_title>

        <%= if @head != [] do %>
          <%= render_slot(@head) %>
        <% end %>

        <link phx-track-static rel="stylesheet" href={~p"/assets/app.css"} />
        <script defer phx-track-static type="text/javascript" src={~p"/assets/app.js"}></script>
      </head>

      <body class="bg-white">
        <%= render_slot(@inner_content) %>
      </body>
    </html>
    """
  end
end
