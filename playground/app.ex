defmodule Playground.App do
  @moduledoc """
  Main application module for the playground.

  This module handles the startup and supervision of the playground application,
  including Phoenix PubSub and the endpoint.
  """

  def run_supervisor do
    children = [
      {Phoenix.PubSub, [name: Playground.PubSub, adapter: Phoenix.PubSub.PG2]},
      Playground.Endpoint
    ]

    {:ok, _} = Supervisor.start_link(children, strategy: :one_for_one)
  end

  def run do
    Task.async(fn ->
      run_supervisor()
      Process.sleep(:infinity)
    end)
    |> Task.await(:infinity)
  end
end
