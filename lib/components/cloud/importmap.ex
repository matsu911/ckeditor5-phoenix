defmodule CKEditor5.Components.Cloud.Importmap do
  @moduledoc """
  A component for rendering import map script tags of CKEditor 5 in Phoenix.

  ## ⚠️ Warning

  Import maps can only be used if the preset has the Cloud option enabled, which is not available
  under the GPL license key. You must specify your own Cloud or use a commercial license to utilize
  this feature.
  """

  use Phoenix.Component

  import Phoenix.HTML
  import CKEditor5.Components.Cloud.Assigns

  alias CKEditor5.Cloud.AssetPackageBuilder

  @doc """
  Renders the import map script tag.
  """
  attr :nonce, :string, default: nil, doc: "The CSP nonce to use for the script tag."

  cloud_build_attrs()

  def render(assigns) do
    assigns = assign_importmap(assigns)

    ~H"""
    <script type="importmap" nonce={@nonce}><%= raw(@imports) %></script>
    """
  end

  defp assign_importmap(assigns) do
    imports =
      build_cloud!(assigns)
      |> AssetPackageBuilder.build()
      |> Map.get(:js)
      |> Enum.filter(&(&1.type == :esm))
      |> Enum.map(&{&1.name, &1.url})
      |> Enum.into(%{})
      |> then(&%{imports: &1})
      |> Jason.encode!()

    Map.put(assigns, :imports, imports)
  end
end
