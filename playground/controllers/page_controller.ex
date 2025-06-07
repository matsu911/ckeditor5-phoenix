defmodule Playground.PageController do
  @moduledoc """
  Controller for handling page requests in the playground.

  This controller manages the main pages and navigation within the playground application.
  """

  use Playground, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end
end
