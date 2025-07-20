defmodule CKEditor5.Components.Editor.AttributeValidator do
  @moduledoc """
  Validates attributes for different editor types in the Editor component.
  """

  alias CKEditor5.Errors.Error
  alias CKEditor5.Preset
  alias CKEditor5.Preset.EditorType

  @doc """
  Validates attributes based on the editor type.
  """
  def validate_for_editor_type(%{preset: %Preset{type: preset_type}} = assigns) do
    if EditorType.single_editing_like?(preset_type) do
      assigns
    else
      validate_no_disallowed_attrs(assigns, preset_type)
    end
  end

  # Validates that disallowed attributes are not present for multi-editing editors
  defp validate_no_disallowed_attrs(assigns, preset_type) do
    disallowed_attrs = build_disallowed_attrs_list(assigns)

    case find_present_disallowed_attr(disallowed_attrs) do
      {attr, _value, hint} ->
        message =
          "The `#{attr}` attribute is not supported for editor type '#{preset_type}'. #{hint}"

        raise Error, message: message

      nil ->
        assigns
    end
  end

  # Builds a list of potentially disallowed attributes with their values and error hints
  defp build_disallowed_attrs_list(assigns) do
    [
      {:name, assigns.name, "Remove the `field` and `name` attributes."},
      {:value, assigns.value, "Use the `<.cke_editable>` component to set content instead."},
      {
        :editable_height,
        assigns.editable_height,
        "Set height on individual editable areas if needed."
      },
      {:required, assigns.required, "The `required` attribute is only for form integration."}
    ]
  end

  # Finds the first disallowed attribute that is present
  defp find_present_disallowed_attr(disallowed_attrs) do
    Enum.find(disallowed_attrs, fn {attr, value, _hint} -> attr_present?(attr, value) end)
  end

  # Checks if an attribute is present based on its type and value
  defp attr_present?(:value, value), do: value != "" && not is_nil(value)
  defp attr_present?(:required, value), do: value == true
  defp attr_present?(_attr, value), do: not is_nil(value)
end
