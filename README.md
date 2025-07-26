# CKEditor 5 Phoenix Integration ✨

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-green.svg?style=flat-square)](http://makeapullrequest.com)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/mati365/ckeditor5-phoenix?style=flat-square)
[![GitHub issues](https://img.shields.io/github/issues/mati365/ckeditor5-phoenix?style=flat-square)](https://github.com/Mati365/ckeditor5-phoenix/issues)
[![Elixir Coverage](https://img.shields.io/badge/Elixir-100%25-brightgreen?logo=elixir&logoColor=white&style=flat-square)](https://coveralls.io/github/Mati365/ckeditor5-phoenix?branch=main)
[![TS Coverage](https://img.shields.io/badge/TypeScript-100%25-brightgreen?logo=typescript&logoColor=white&style=flat-square)](https://codecov.io/gh/Mati365/ckeditor5-phoenix?flag=npm)
![NPM Version](https://img.shields.io/npm/v/ckeditor5-phoenix?style=flat-square)
![Hex.pm Version](https://img.shields.io/hexpm/v/ckeditor5_phoenix?style=flat-square&color=%239245ba)

CKEditor 5 integration library for Phoenix (Elixir) applications. Provides web components and helper functions for seamless editor integration with support for classic, inline, balloon, and decoupled editor types.

> [!IMPORTANT]
> This package is unofficial and not maintained by CKSource. For official CKEditor 5 documentation, visit [ckeditor.com](https://ckeditor.com/docs/ckeditor5/latest/). If you encounter any issues in the editor, please report them on the [GitHub repository](https://github.com/ckeditor/ckeditor5/issues).

<p align="center">
  <img src="docs/intro-classic-editor.png" alt="CKEditor 5 Classic Editor in Phoenix (Elixir) application">
</p>

## Installation 🚀

Add dependency to your project:

```elixir
def deps do
  [
    {:ckeditor5_phoenix, "~> 1.0.8"}
  ]
end
```

Register the hook in your `app.js` file:

```javascript
// If you use `node_modules/` directory then the `ckeditor5-phoenix` NPM package should be used.
import { Hooks } from 'ckeditor5_phoenix';

// .. other configurations

const liveSocket = new LiveSocket('/live', Socket, {
  // ... other options
  hooks: Hooks,
});
```

If you use the CKEditor 5 cloud distribution, you need to configure esbuild to exclude the `ckeditor5` package from the build process. This way, the editor will be loaded from the CDN, not from node_modules.
Edit your `config/dev.exs` and `config/prod.exs` files and add the following configuration:

```elixir
config :demo, DemoWeb.Endpoint,
  # ... other configurations
  watchers: [
    esbuild: {Esbuild, :install_and_run, [
      :demo,
      ~w(
        --sourcemap=inline
        --watch
        --external:ckeditor5
        --external:ckeditor5-premium-features
      )
    ]}
    # ↑ Added --external:ckeditor5 and --external:ckeditor5-premium-features
  ]
```

## Editor placement 🏗️

### Classic editor 📝

The classic editor is the most common type of editor. It provides a toolbar with various formatting options like bold, italic, underline, and link.

It looks like this:

![CKEditor 5 Classic Editor in Elixir Phoenix application with Menubar](docs/classic-editor-with-toolbar.png)

```heex
<%!-- In <head> --%>
<.cke_cloud_assets />

<%!-- In <body> --%>'
<.ckeditor
  type="classic"
  value="<p>Initial content here</p>"
  editable_height="300px"
/>
```

### Multiroot editor 🌳

The multiroot editor allows you to create an editor with multiple editable areas. It's useful when you want to create a CMS with multiple editable areas on a single page.

- `ckeditor` component is used to create the editor container. It'll initialize the editor without any editable nor toolbar. The full list of attributes can be found in the [source](lib/components/editor/editor.ex).
- `cke_editable` component is used to create editable areas within the editor. Each editable area can have its own name and initial value. The full list of attributes can be found in the [source](lib/components/editable.ex).

![CKEditor 5 Multiroot Editor in Elixir Phoenix application](docs/multiroot-editor.png)

```heex
<%!-- In <head> --%>
<.cke_cloud_assets />

<%!-- In <body> --%>
<.ckeditor type="multiroot" />

<.cke_ui_part name="toolbar" />

<div class="flex flex-col gap-4">
  <.cke_editable
    root="header"
    value="<h1>Main Header</h1>"
    class="border border-gray-300"
  />
  <.cke_editable
    root="content"
    value="<p>Main content area</p>"
    class="border border-gray-300"
  />
  <.cke_editable
    root="sidebar"
    value="<p>Sidebar content</p>"
    class="border border-gray-300"
  />
</div>
```

### Inline editor 📝

Inline editor allows you to create an editor that can be placed inside any element. Keep in mind that inline editor does not work with `textarea` elements so it might be not suitable for all use cases.

![CKEditor 5 Inline Editor in Elixir Phoenix application](docs/inline-editor.png)

If you want to use an inline editor, you can pass the `type` keyword argument with the value `:inline`:

```heex
<%!-- In <head> --%>
<.cke_cloud_assets />

<%!-- In <body> --%>
<.ckeditor
  type="inline"
  value="<p>Initial content here</p>"
  editable_height="300px"
/>
```

## Editor configuration ⚙️

You can configure the editor _presets_ in your `config/config.exs` file. The default preset is `:default`, which provides a basic configuration with a toolbar and essential plugins. The preset is a map that contains the editor configuration, including the toolbar items and plugins. There can be multiple presets, and you can switch between them by passing the `preset` keyword argument to the `ckeditor` component.

In order to override the default preset, you can add the following configuration to your `config/config.exs` file:

```elixir
config :ckeditor5_phoenix,
  presets: %{
    default: %{
      config: %{
        toolbar: [
          :undo, :redo, :|, :heading, :|, :fontFamily, :fontSize, :fontColor, :fontBackgroundColor, :alignment, :|,
          :bold, :italic, :underline, :|, :link, :insertImage, :insertTable, :insertTableLayout,
          :blockQuote, :emoji, :mediaEmbed, :|, :bulletedList, :numberedList, :todoList, :outdent, :indent
        ],
        plugins: [
          :Alignment, :AccessibilityHelp, :Autoformat, :AutoImage, :Autosave, :BlockQuote, :Bold, :CloudServices,
          :Essentials, :Emoji, :Mention, :Heading, :FontFamily, :FontSize, :FontColor, :FontBackgroundColor,
          :ImageBlock, :ImageCaption, :ImageInline, :ImageInsert, :ImageInsertViaUrl, :ImageResize, :ImageStyle,
          :ImageTextAlternative, :ImageToolbar, :ImageUpload, :Indent, :IndentBlock, :Italic, :Link, :LinkImage,
          :List, :ListProperties, :MediaEmbed, :Paragraph, :PasteFromOffice, :PictureEditing, :SelectAll, :Table,
          :TableLayout, :TableCaption, :TableCellProperties, :TableColumnResize, :TableProperties, :TableToolbar,
          :TextTransformation, :TodoList, :Underline, :Undo, :Base64UploadAdapter
        ],
        table: %{
          contentToolbar: [
            :tableColumn, :tableRow, :mergeTableCells, :tableProperties, :tableCellProperties, :toggleTableCaption
          ]
        },
        image: %{
          toolbar: [
            :imageTextAlternative, :imageStyle, :imageResize, :imageInsertViaUrl
          ]
        }
      }
    }
  }
```

## Editor value synchronization with LiveView 🔄

Below is an example of how to synchronize the CKEditor 5 editor value with the backend in LiveView, using the component and event handling in Elixir.

### Template (`.heex`)

```heex
<.ckeditor value="Hello world" />

<div class="bg-gray-50 mt-8 p-4 border border-gray-300">
  <h2 class="mb-2 font-bold">Current editor value:</h2>
  <pre class="whitespace-pre-wrap"> <%= @editor_value %> </pre>
</div>
```

### LiveView (`.ex`)

```elixir
defmodule Playground.Live.Classic do
  use Playground, :live_view
  use CKEditor5

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, editor_value: "")}
  end

  @impl true
  def handle_event("ckeditor5:change", %{"data" => data}, socket) do
    {:noreply, assign(socket, editor_value: data["main"])}
  end
end
```

In the above example:

- The `<.ckeditor />` component renders the CKEditor 5 editor.
- The editor value is sent to the backend via the `ckeditor5:change` event.
- The editor value is displayed on the page in the `<pre>` element.

This approach allows for full real-time synchronization of the editor state with the backend.

## Package development 🛠️

In order to run the minimal Phoenix application with CKEditor 5 integration, you need to install the dependencies and run the server:

```bash
mix playground
```

Testing the package is done using the `mix test` command. The tests are located in the `test/` directory.

```bash
mix test
```

To obtain code coverage, you can run the following command:

```bash
mix coveralls.html
```

## Trademarks 📜

CKEditor® is a trademark of [CKSource Holding sp. z o.o.](https://cksource.com/) All rights reserved. For more information about the license of CKEditor® please visit [CKEditor's licensing page](https://ckeditor.com/legal/ckeditor-oss-license/).

This package is not owned by CKSource and does not use the CKEditor® trademark for commercial purposes. It should not be associated with or considered an official CKSource product.

## License 📜

This project is licensed under the terms of the [MIT LICENSE](LICENSE).

This project injects CKEditor 5 which is licensed under the terms of [GNU General Public License Version 2 or later](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html). For more information about CKEditor 5 licensing, please see their [official documentation](https://ckeditor.com/legal/ckeditor-oss-license/).
