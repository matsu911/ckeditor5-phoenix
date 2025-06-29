defmodule CKEditor5.Components.Cloud.Importmap do
  @moduledoc """
  A component for rendering an import map in Phoenix.
  This component generates a script tag with type "importmap" containing an empty imports object.
  It can be used to define module imports for JavaScript in a Phoenix application.

  ## ⚠️ Warning

  Import maps can only be used if the preset has the Cloud option enabled, which is not available
  under the GPL license key. You must specify your own Cloud or use a commercial license to utilize
  this feature.
  """

  use Phoenix.Component

  import Phoenix.HTML

  alias CKEditor5.Cloud.AssetPackageBuilder
  alias CKEditor5.Preset.CloudCompatibilityChecker
  alias CKEditor5.Presets

  @doc """
  Renders the import map script tag.
  This component does not take any specific assigns, but it can be customized with a `:preset` assign
  to specify which preset's import map to use.
  """
  attr :preset, :string, default: "default"

  def render(assigns) do
    assigns = assign_importmap(assigns)

    ~H"""
    <script type="importmap"><%= raw(@imports) %></script>
    """
  end

  defp assign_importmap(%{preset: preset} = assigns) do
    preset = Presets.get!(preset)

    CloudCompatibilityChecker.ensure_cloud_configured!(preset)

    imports =
      AssetPackageBuilder.build(preset.cloud)
      |> Map.get(:js)
      |> Enum.filter(&(&1.type == :esm))
      |> Enum.map(&{&1.name, &1.url})
      |> Enum.into(%{})
      |> then(&%{imports: &1})
      |> Jason.encode!()

    Map.put(assigns, :imports, imports)
  end
end
