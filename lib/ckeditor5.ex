defmodule CKEditor5 do
  @moduledoc """
  The main module for CKEditor 5 integration in Phoenix Framework.
  """

  @version Mix.Project.config()[:version]

  alias CKEditor5.Components

  defmacro __using__(_opts) do
    quote do
      defdelegate ckeditor(assigns), to: CKEditor5.Components.Editor, as: :render
      defdelegate cke_editable(assigns), to: CKEditor5.Components.Editable, as: :render
      defdelegate cke_cloud_assets(assigns), to: CKEditor5.Components.Cloud.Assets, as: :render
      defdelegate cke_ui_part(assigns), to: CKEditor5.Components.UIPart, as: :render
    end
  end

  def version, do: @version

  defdelegate editor(assigns), to: Components.Editor, as: :render
  defdelegate editable(assigns), to: Components.Editable, as: :render
  defdelegate cloud_assets(assigns), to: Components.Cloud.Assets, as: :render
  defdelegate ui_part(assigns), to: Components.UIPart, as: :render
end
