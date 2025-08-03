defmodule CKEditor5.Components.Cloud.Stylesheets do
  @moduledoc """
  A component for rendering stylesheet link tags of CKEditor 5 in Phoenix.

  ## ⚠️ Warning

  Import maps can only be used if the preset has the Cloud option enabled, which is not available
  under the GPL license key. You must specify your own Cloud or use a commercial license to utilize
  this feature.
  """

  use Phoenix.Component

  import CKEditor5.Components.Cloud.Assigns

  alias CKEditor5.Cloud.AssetPackageBuilder

  @doc """
  Renders the stylesheet link tags..
  """
  attr :nonce, :string, default: nil, doc: "The CSP nonce to use for the link tags."

  cloud_build_attrs()

  def render(assigns) do
    assigns = assign_stylesheets(assigns)

    ~H"""
    <%= for href <- @stylesheets do %>
      <link rel="stylesheet" href={href} nonce={@nonce} crossorigin="anonymous" />
    <% end %>
    """
  end

  defp assign_stylesheets(assigns) do
    stylesheets =
      build_cloud!(assigns)
      |> AssetPackageBuilder.build()
      |> Map.get(:css)

    Map.put(assigns, :stylesheets, stylesheets)
  end
end
