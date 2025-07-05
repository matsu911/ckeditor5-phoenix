defmodule CKEditor5.Components.Editor do
  @moduledoc """
  LiveView component for CKEditor 5 integration in Phoenix Framework.

  This module provides the necessary functionality to render and manage
  CKEditor 5 instances within Phoenix LiveView applications.
  """

  use Phoenix.LiveComponent

  alias CKEditor5.Components.HiddenInput
  alias CKEditor5.Helpers
  alias CKEditor5.Preset
  alias CKEditor5.Preset.EditorType
  alias Phoenix.HTML

  @doc """
  Renders the CKEditor 5 component in a LiveView.

  ## Attributes
    * `:id` - Optional string ID for the editor instance
    * `:preset` - Optional string preset name (defaults to "default")
    * `:editable_height` - Optional string to set the height of the editable area
      (e.g., "300px"). If not provided, the height will be determined by the editor's content.
    * `:name` - Optional string name for the editor, used for form integration
      (if `:field` is provided). If not provided, the name will be derived
      from the `:field` attribute.
    * `:field` - Optional Phoenix.HTML.FormField for form integration
    * `:value` - Optional string value for the editor content
    * `:required` - Optional boolean to indicate if the editor is required
      (defaults to false). This is used for form validation.
    * `:rest` - Global attributes passed to the container div
  """
  attr :id, :string, required: false
  attr :preset, :string, default: "default"
  attr :editable_height, :string, required: false
  attr :name, :string, required: false, default: nil
  attr :field, HTML.FormField, required: false, default: nil
  attr :value, :string, required: false, default: ""
  attr :required, :boolean, default: false
  attr :rest, :global

  def render(assigns) do
    assigns =
      assigns
      |> Helpers.assign_id_if_missing("cke")
      |> assign_loaded_preset()
      |> validate_name_for_editor_type()
      |> normalize_editable_height()

    ~H"""
    <div
      id={@id}
      phx-update="ignore"
      phx-hook="CKEditor5"
      cke-preset={Jason.encode!(@preset)}
      cke-editable-height={@editable_height}
      cke-initial-value={@value || ""}
      {@rest}
    >
      <div id={"#{@id}_editor"}></div>
      <%= if @field || @name do %>
        <HiddenInput.render
          id={"#{@id}_input"}
          name={@name || HTML.Form.input_name(@field.form, @field.field)}
          value={@value}
          required={@required}
        />
      <% end %>
    </div>
    """
  end

  # Loads the preset configuration from the preset name
  defp assign_loaded_preset(assigns) do
    preset = CKEditor5.Presets.get!(assigns.preset)

    Map.put(assigns, :preset, preset)
  end

  # Validates that form integration is not used with single editing-like editors
  defp validate_name_for_editor_type(
         %{preset: %Preset{type: preset_type}, field: field, name: name} = assigns
       )
       when not is_nil(field) or not is_nil(name) do
    if not EditorType.single_editing_like?(preset_type) do
      raise ArgumentError,
            "Editor type '#{preset_type}' does not support form integration. " <>
              "Remove the `field` and `name` attributes for non-single editing-like editors."
    end

    assigns
  end

  defp validate_name_for_editor_type(assigns), do: assigns

  # Normalizes the editable height value by removing 'px' suffix if present
  defp normalize_editable_height(%{editable_height: nil} = assigns), do: assigns

  defp normalize_editable_height(%{editable_height: editable_height} = assigns) do
    normalized_height =
      if is_binary(editable_height) && String.ends_with?(editable_height, "px") do
        editable_height |> String.slice(0..-3//1)
      else
        editable_height
      end

    Map.put(assigns, :editable_height, normalized_height)
  end
end
