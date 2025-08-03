defmodule CKEditor5.Components.Cloud.ModulePreload do
  @moduledoc """
  A component for rendering module preload link tags of CKEditor 5 in Phoenix.

  ## ⚠️ Warning

  Import maps can only be used if the preset has the Cloud option enabled, which is not available
  under the GPL license key. You must specify your own Cloud or use a commercial license to utilize
  this feature.
  """

  use Phoenix.Component

  import CKEditor5.Components.Cloud.Assigns

  alias CKEditor5.Cloud.AssetPackageBuilder

  @doc """
  Renders module preload link tags for all modules in the import map.
  """
  attr :nonce, :string, default: nil, doc: "The CSP nonce to use for the script tag."

  cloud_build_attrs()

  def render(assigns) do
    assigns = assign_modules_for_preload(assigns)

    ~H"""
    <link
      :for={module_url <- @module_urls}
      rel="modulepreload"
      href={module_url}
      nonce={@nonce}
      crossorigin="anonymous"
    />
    """
  end

  defp assign_modules_for_preload(assigns) do
    module_urls =
      build_cloud!(assigns)
      |> AssetPackageBuilder.build()
      |> Map.get(:js)
      |> Enum.filter(&(&1.type == :esm))
      |> Enum.map(& &1.url)

    Map.put(assigns, :module_urls, module_urls)
  end
end
