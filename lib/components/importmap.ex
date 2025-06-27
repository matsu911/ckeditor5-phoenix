defmodule CKEditor5.Components.Importmap do
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

  alias CKEditor5.Preset.License
  alias CKEditor5.Presets

  @doc """
  Renders the import map script tag.
  This component does not take any specific assigns, but it can be customized with a `:preset` assign
  to specify which preset's import map to use.
  """
  attr :preset, :string, default: "default"

  def render(assigns) do
    assigns = assigns |> load_preset!()

    ensure_cloud_available!(assigns.preset)

    ~H"""
    <script type="importmap">
      {
        "imports": {}
      }
    </script>
    """
  end

  defp load_preset!(assigns) do
    preset = Presets.get!(assigns.preset)

    Map.put(assigns, :preset, preset)
  end

  defp ensure_cloud_available!(preset) do
    if !License.can_use_cloud?(preset) do
      raise CKEditor5.CloudNotAvailableInLicenseError, license_key: preset.license_key
    end
  end
end
