defmodule Playground.Components.Core do
  @moduledoc """
  Core components for the Playground application.
  """

  use Phoenix.Component

  @doc """
  A component that displays a link to return to the home page.
  """
  def back_to_home(assigns) do
    ~H"""
    <a href="/" class="flex items-center gap-1 pb-8 text-blue-600 hover:underline">
      <span aria-hidden="true">←</span>
      <span>Back to Home</span>
    </a>
    """
  end
end
