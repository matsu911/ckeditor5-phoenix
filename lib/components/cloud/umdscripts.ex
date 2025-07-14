defmodule CKEditor5.Components.Cloud.UmdScripts do
  @moduledoc """
  A component for rendering UMD script tags in Phoenix.
  This component generates script tags for UMD modules.
  It can be used to load CKEditor 5 builds in a Phoenix application.

  ## ⚠️ Warning

  This component can only be used if the preset has the Cloud option enabled, which is not available
  under the GPL license key. You must specify your own Cloud or use a commercial license to utilize
  this feature.
  """

  use Phoenix.Component

  alias CKEditor5.Cloud.AssetPackageBuilder
  alias CKEditor5.Preset.CloudCompatibilityChecker
  alias CKEditor5.Presets

  @doc """
  Renders the UMD script tags.
  This component can be customized with a `:preset` assign
  to specify which preset's scripts to use.
  """
  attr :preset, :string, default: "default", doc: "The name of the preset to use."
  attr :nonce, :string, default: nil, doc: "The CSP nonce to use for the script tags."

  def render(assigns) do
    assigns = assign_scripts(assigns)

    ~H"""
    <%= for src <- @scripts do %>
      <script src={src} nonce={@nonce}></script>
    <% end %>
    """
  end

  defp assign_scripts(%{preset: preset} = assigns) do
    preset = Presets.get!(preset)

    CloudCompatibilityChecker.ensure_cloud_configured!(preset)

    scripts =
      AssetPackageBuilder.build(preset.cloud)
      |> Map.get(:js)
      |> Enum.filter(&(&1.type == :umd))
      |> Enum.map(& &1.url)

    Map.put(assigns, :scripts, scripts)
  end
end
