defmodule Playground.PageController do
  use Playground, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end
end
