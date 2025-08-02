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

  def live_view do
    quote do
      use Phoenix.LiveView

      import Playground.DistributionChannel
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

      import Playground.DistributionChannel
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
