defmodule Playground.Live.ClassicDynamicPreset do
  @moduledoc """
  HTML module for the classic editor page of the playground application.
  """

  use Playground, :live_view
  use CKEditor5

  alias CKEditor5.Preset.Parser

  @impl true
  def mount(_params, _session, socket) do
    preset =
      Parser.parse!(%{
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
            :insertTable,
            :blockQuote,
            :|,
            :bulletedList,
            :numberedList,
            :outdent,
            :indent
          ],
          plugins: [
            :HelloWorldPlugin,
            :AccessibilityHelp,
            :Autoformat,
            :BlockQuote,
            :Bold,
            :Essentials,
            :Heading,
            :ImageBlock,
            :ImageCaption,
            :ImageInsert,
            :ImageInsertViaUrl,
            :ImageResize,
            :ImageStyle,
            :ImageTextAlternative,
            :ImageToolbar,
            :ImageUpload,
            :Indent,
            :Italic,
            :Link,
            :LinkImage,
            :List,
            :Paragraph,
            :PasteFromOffice,
            :SelectAll,
            :Table,
            :TableToolbar,
            :TextTransformation,
            :Underline,
            :Undo,
            :Base64UploadAdapter
          ],
          table: %{
            contentToolbar: [
              :tableColumn,
              :tableRow,
              :mergeTableCells
            ]
          },
          image: %{
            toolbar: [
              :imageTextAlternative,
              :imageStyle,
              :imageResize
            ]
          }
        }
      })

    {:ok, assign(socket, editor_value: "Hello World!", preset: preset)}
  end

  @impl true
  def handle_event(event, %{"data" => data}, socket)
      when event in ["ckeditor5:focus", "ckeditor5:blur"] do
    {:noreply, assign(socket, editor_value: data["main"])}
  end
end
