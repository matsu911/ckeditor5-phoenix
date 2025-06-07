defmodule Playground.Router do
  @moduledoc """
  Main router for the playground application.

  This module defines the routing structure and pipelines for handling
  HTTP requests in the playground application.
  """

  use Playground, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {Playground.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Playground do
    pipe_through :browser

    get "/", PageController, :home
  end
end
