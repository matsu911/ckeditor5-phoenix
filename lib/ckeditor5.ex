defmodule CKEditor5 do
  @moduledoc """
  The main module for CKEditor 5 integration in Phoenix Framework.
  """

  @version Mix.Project.config()[:version]

  def version, do: @version

  defmacro __using__(_opts) do
    quote do
      defdelegate ckeditor5(assigns), to: CKEditor5.Components.Editor, as: :render
      defdelegate ckeditor5_importmap(assigns), to: CKEditor5.Components.Importmap, as: :render
    end
  end
end
