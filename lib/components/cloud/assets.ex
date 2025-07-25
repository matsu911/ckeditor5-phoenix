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

  alias CKEditor5.Components.Cloud.{Importmap, ModulePreload, Stylesheets, UmdScripts}

  @doc """
  Renders all the assets by composing individual cloud components.
  Accepts a `:preset` assign to specify which preset's assets to use.
  """
  attr :preset, :string, default: "default", doc: "The name of the preset to use."
  attr :nonce, :string, default: nil, doc: "The CSP nonce to use for the script and link tags."

  def render(assigns) do
    ~H"""
    <Importmap.render preset={@preset} nonce={@nonce} />
    <Stylesheets.render preset={@preset} nonce={@nonce} />
    <UmdScripts.render preset={@preset} nonce={@nonce} />
    <ModulePreload.render preset={@preset} nonce={@nonce} />
    """
  end
end
