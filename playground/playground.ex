defmodule Playground do
  @moduledoc """
  Main playground module providing common functionality and macros for Phoenix components.

  This module defines the shared functionality used across the playground application,
  including router, controller, and HTML helper macros.
  """

  alias Playground.Components

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  def router do
    quote do
      use Phoenix.Router, helpers: false

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, formats: [:html, :json]

      import Plug.Conn

      unquote(verified_routes())
    end
  end

  def html do
    quote do
      use Phoenix.Component

      import Phoenix.HTML

      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      alias Phoenix.LiveView.JS

      unquote(verified_routes())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView

      import Components.Core

      unquote(verified_routes())
    end
  end

  def view do
    quote do
      use Phoenix.Component

      use Phoenix.View,
        root: "playground/templates",
        namespace: Playground

      import Phoenix.HTML

      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: Playground.Endpoint,
        router: Playground.Router,
        statics: Playground.static_paths()
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
