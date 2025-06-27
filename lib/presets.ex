defmodule CKEditor5.Presets do
  @moduledoc """
  Provides predefined configurations (presets) for CKEditor 5.
  """

  alias CKEditor5.Preset.Validator

  @default_presets %{
    "default" => %{
      license_key: "4234234",
      config: %{
        toolbar: [
          :undo,
          :redo,
          :|,
          :heading,
          :|,
          :bold,
          :italic,
          :underline,
          :|,
          :link,
          :insertImage,
          :mediaEmbed,
          :insertTable,
          :blockQuote,
          :|,
          :bulletedList,
          :numberedList,
          :todoList,
          :outdent,
          :indent
        ],
        plugins: [
          :AccessibilityHelp,
          :Autoformat,
          :AutoImage,
          :Autosave,
          :BlockQuote,
          :Bold,
          :CloudServices,
          :Essentials,
          :Heading,
          :ImageBlock,
          :ImageCaption,
          :ImageInline,
          :ImageInsert,
          :ImageInsertViaUrl,
          :ImageResize,
          :ImageStyle,
          :ImageTextAlternative,
          :ImageToolbar,
          :ImageUpload,
          :Indent,
          :IndentBlock,
          :Italic,
          :Link,
          :LinkImage,
          :List,
          :ListProperties,
          :MediaEmbed,
          :Paragraph,
          :PasteFromOffice,
          :PictureEditing,
          :SelectAll,
          :Table,
          :TableCaption,
          :TableCellProperties,
          :TableColumnResize,
          :TableProperties,
          :TableToolbar,
          :TextTransformation,
          :TodoList,
          :Underline,
          :Undo,
          :Base64UploadAdapter
        ],
        image: %{
          toolbar: [
            :imageTextAlternative,
            :imageStyle,
            :imageResize,
            :imageInsertViaUrl
          ]
        }
      }
    }
  }

  @doc """
  Retrieves a preset configuration by name.
  """
  def get!(preset_name) do
    @default_presets
    |> Map.merge(Application.get_env(:ckeditor5, :presets, %{}))
    |> Map.fetch!(preset_name)
    |> Validator.parse!()
  end
end
