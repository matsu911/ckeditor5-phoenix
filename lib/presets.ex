defmodule CKEditor5.Presets do
  @moduledoc """
  Provides predefined configurations (presets) for CKEditor 5.
  """

  alias CKEditor5.Errors
  alias CKEditor5.Preset.Parser

  @default_presets %{
    "default" => %{
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

  Returns `{:ok, preset}` on success, or `{:error, reason}` on failure.
  """
  def get(preset_name) do
    all_presets = all()

    with {:ok, preset_config} <- Map.fetch(all_presets, preset_name),
         {:ok, preset} <- Parser.parse(preset_config) do
      {:ok, preset}
    else
      {:error, reason} ->
        {:error, %Errors.InvalidPreset{reason: reason}}

      :error ->
        {:error,
         %Errors.PresetNotFound{
           preset_name: preset_name,
           available_presets: Map.keys(all_presets)
         }}
    end
  end

  @doc """
  Retrieves a preset configuration by name, raising an exception on failure.
  """
  def get!(preset_name) do
    case get(preset_name) do
      {:ok, preset} -> preset
      {:error, reason} -> raise reason
    end
  end

  defp all do
    Map.merge(@default_presets, Application.get_env(:ckeditor5, :presets, %{}))
  end
end
