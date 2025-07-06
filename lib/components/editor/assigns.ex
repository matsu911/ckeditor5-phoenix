defmodule CKEditor5.Components.Editor.Assigns do
  @moduledoc """
  Handles assigns processing for the Editor component.
  """

  alias CKEditor5.Preset
  alias CKEditor5.Preset.EditorType
  alias Phoenix.HTML

  @doc """
  Prepares the assigns for the editor component by processing and validating them.
  """
  def prepare(assigns) do
    assigns
    |> assign_form_fields()
    |> assign_loaded_preset()
    |> override_preset_type()
    |> validate_attributes_for_editor_type()
    |> normalize_editable_height()
  end

  # Assigns form fields if the `form` and `field` attributes are provided
  defp assign_form_fields(%{form: nil} = assigns), do: assigns

  defp assign_form_fields(%{form: form, field: field_name} = assigns) when is_atom(field_name) do
    field = HTML.Form.input_name(form, field_name)

    assigns
    |> Map.put(:field, field)
    |> Map.put_new(:name, field.name)
    |> Map.put_new(:value, field.value || "")
  end

  # Loads the preset configuration from the preset name
  defp assign_loaded_preset(assigns) do
    preset = CKEditor5.Presets.get!(assigns.preset)

    Map.put(assigns, :preset, preset)
  end

  # Overrides the preset type if a type is provided in the assigns
  defp override_preset_type(%{type: nil} = assigns), do: assigns

  defp override_preset_type(%{type: type, preset: preset} = assigns) do
    type_atom = String.to_atom(type)

    if EditorType.valid?(type_atom) do
      new_preset = Preset.of_type(preset, type_atom)
      Map.put(assigns, :preset, new_preset)
    else
      raise ArgumentError, "Invalid editor type provided: #{type}"
    end
  end

  # Validates attributes based on the editor type
  defp validate_attributes_for_editor_type(%{preset: %Preset{type: preset_type}} = assigns) do
    if EditorType.single_editing_like?(preset_type) do
      assigns
    else
      validate_no_disallowed_attrs(assigns, preset_type)
    end
  end

  defp validate_no_disallowed_attrs(assigns, preset_type) do
    disallowed_attrs = [
      {:name, assigns.name, "Remove the `field` and `name` attributes."},
      {:value, assigns.value, "Use the `<.cke_editable>` component to set content instead."},
      {
        :editable_height,
        assigns.editable_height,
        "Set height on individual editable areas if needed."
      },
      {:required, assigns.required, "The `required` attribute is only for form integration."}
    ]

    case Enum.find(disallowed_attrs, fn {attr, value, _hint} -> attr_present?(attr, value) end) do
      {attr, _value, hint} ->
        raise ArgumentError,
              "The `#{attr}` attribute is not supported for editor type '#{preset_type}'. #{hint}"

      nil ->
        assigns
    end
  end

  defp attr_present?(:value, value), do: value != "" && not is_nil(value)
  defp attr_present?(:required, value), do: value == true
  defp attr_present?(_attr, value), do: not is_nil(value)

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
