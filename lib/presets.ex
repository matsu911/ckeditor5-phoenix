defmodule CKEditor5.Presets do
  @moduledoc """
  Provides predefined configurations (presets) for CKEditor 5.
  """

  @default_editor_version Mix.Project.config()[:default_editor_version]
  @builtin_presets %{
    "default" => %{
      version: @default_editor_version,
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

  @doc """
  Retrieves a preset configuration by name.
  """
  def get!(preset_name) do
    @builtin_presets
    |> Map.merge(Application.get_env(:ckeditor5, :presets, %{}))
    |> Map.fetch!(preset_name)
  end
end
