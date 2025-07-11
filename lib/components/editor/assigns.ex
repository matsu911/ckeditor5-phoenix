defmodule CKEditor5.Components.Editor.Assigns do
  @moduledoc """
  Handles assigns processing for the Editor component.
  """

  alias CKEditor5.Form
  alias CKEditor5.Components.Editor.{AttributeValidator, PresetHandler, ValueNormalizer}

  @doc """
  Prepares the assigns for the editor component by processing and validating them.
  """
  def prepare(assigns) do
    assigns
    |> Form.assign_form_fields()
    |> PresetHandler.process_preset()
    |> AttributeValidator.validate_for_editor_type()
    |> ValueNormalizer.normalize_values()
  end
end
