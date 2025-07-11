defmodule CKEditor5.Form do
  @moduledoc """
  Common helper functions for CKEditor5 form components.
  """

  alias Phoenix.HTML

  @doc """
  Assigns form fields if the `form` and `field` attributes are provided.
  This function checks if the `form` is present and if the `field` is an atom.
  It then retrieves the input name and value from the form and assigns them to the assigns map.
  """
  def assign_form_fields(%{form: nil} = assigns), do: assigns

  def assign_form_fields(%{form: form, field: field_name} = assigns) when is_atom(field_name) do
    field = HTML.Form.input_name(form, field_name)

    assigns
    |> Map.put(:field, field)
    |> Map.put_new(:name, field.name)
    |> Map.put_new(:value, field.value || "")
  end

  @doc """
  Defines form-related attributes that are commonly used in CKEditor5 components.
  This includes name, form, field, value, and required attributes for form integration.
  """
  defmacro form_attrs do
    quote do
      attr :name, :string,
        required: false,
        default: nil,
        doc: """
        The name of the input field that will be used to submit the content.
        If not provided, it will be derived from the `:field` attribute when available.
        This is useful for form integration, allowing the content to be submitted as part of a form.
        """

      attr :form, :any,
        required: false,
        default: nil,
        doc: "The `Phoenix.HTML.Form` for form integration."

      attr :field, Phoenix.HTML.FormField,
        required: false,
        default: nil,
        doc: "The `Phoenix.HTML.FormField` for form integration."

      attr :value, :string,
        required: false,
        default: "",
        doc: """
        The initial value for the content. This will be set when the component is initialized.
        If not specified, it will default to an empty string.
        """

      attr :required, :boolean,
        default: false,
        doc: """
        Marks the input as required. This will be used to validate the content when the form is submitted.
        """
    end
  end
end
