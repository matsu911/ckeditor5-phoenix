defmodule Playground.Router do
  use Phoenix.Router

  import Plug.Conn
  import Phoenix.Controller
  import Phoenix.LiveView.Router

  @dialyzer {:nowarn_function, browser: 2}

  pipeline :browser do
    plug(:put_root_layout, {Playground.View, :root})
    plug(:accepts, ~w(html))
  end

  scope "/", Playground do
    pipe_through(:browser)
  end
end
