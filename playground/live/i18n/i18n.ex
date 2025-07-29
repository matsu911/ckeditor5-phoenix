defmodule Playground.Live.I18n do
  @moduledoc """
  HTML module for the i18n editor page of the playground application.
  """

  use Playground, :live_view
  use CKEditor5

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, editor_value: "Hello!")}
  end
end
