defmodule CKEditor5.Components.Cloud.ModulePreload do
  @moduledoc """
  A component for rendering module_preload link tags in Phoenix.
  This component generates link tags with rel="modulepreload" for all modules in the import map.
  It helps browsers preload ES modules, improving performance by downloading dependencies
  before they are actually needed.
  """

  use Phoenix.Component

  alias CKEditor5.Cloud.AssetPackageBuilder
  alias CKEditor5.Preset.CloudCompatibilityChecker
  alias CKEditor5.Presets

  @doc """
  Renders module_preload link tags for all modules in the import map.
  This helps browsers preload ES modules, improving performance by downloading
  dependencies before they are actually needed.
  """
  attr :preset, :string, default: "default", doc: "The name of the preset to use."
  attr :nonce, :string, default: nil, doc: "The CSP nonce to use for the script tag."

  def module_preload(assigns) do
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

  defp assign_modules_for_preload(%{preset: preset} = assigns) do
    preset = Presets.get!(preset)

    CloudCompatibilityChecker.ensure_cloud_configured!(preset)

    module_urls =
      AssetPackageBuilder.build(preset.cloud)
      |> Map.get(:js)
      |> Enum.filter(&(&1.type == :esm))
      |> Enum.map(& &1.url)

    Map.put(assigns, :module_urls, module_urls)
  end
end
