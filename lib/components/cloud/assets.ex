defmodule CKEditor5.Components.Cloud.Assets do
  @moduledoc """
  A component for rendering all necessary CKEditor 5 assets from the cloud.
  This includes the import map, stylesheets, and UMD scripts.

  It's a convenient way to include all required assets with a single component.
  This component composes other cloud components to provide a unified interface.

  ## ⚠️ Warning

  This component can only be used if the preset has the Cloud option enabled, which is not available
  under the GPL license key. You must specify your own Cloud or use a commercial license to utilize
  this feature.
  """

  use Phoenix.Component

  import CKEditor5.Components.Cloud.Assigns

  alias CKEditor5.Components.Cloud.{Importmap, ModulePreload, Stylesheets, UmdScripts}

  @doc """
  Renders all the assets by composing individual cloud components.
  """
  attr :nonce, :string, default: nil, doc: "The CSP nonce to use for the script and link tags."

  cloud_build_attrs()

  def render(assigns) do
    ~H"""
    <Importmap.render {assigns} />
    <Stylesheets.render {assigns} />
    <UmdScripts.render {assigns} />
    <ModulePreload.render {assigns} />
    """
  end
end
