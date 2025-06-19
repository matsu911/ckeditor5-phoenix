defmodule CKEditor5 do
  @moduledoc """
  The main module for CKEditor 5 integration in Phoenix Framework.
  """

  @version Mix.Project.config()[:version]

  def version, do: @version

  defmacro __using__(_opts) do
    quote do
      import CKEditor5.Editor.Config
      import CKEditor5.Editor.LiveView
    end
  end
end
