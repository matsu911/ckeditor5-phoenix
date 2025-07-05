defmodule CKEditor5 do
  @moduledoc """
  The main module for CKEditor 5 integration in Phoenix Framework.
  """

  @version Mix.Project.config()[:version]

  alias CKEditor5.Components

  def version, do: @version

  defdelegate editor(assigns), to: Components.Editor, as: :render
  defdelegate editable(assigns), to: Components.Editable, as: :render
  defdelegate cloud_assets(assigns), to: Components.Cloud.Assets, as: :render
end
