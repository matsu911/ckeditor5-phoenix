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

## Psst... 👀

If you're looking for similar stuff, check these out:

* [ckeditor5-rails](https://github.com/Mati365/ckeditor5-rails)
  Smooth CKEditor 5 integration for Ruby on Rails. Works with standard forms, Turbo, and Hotwire. Easy setup, custom builds, and localization support.

* [ckeditor5-livewire](https://github.com/Mati365/ckeditor5-livewire)
  Drop-in CKEditor 5 solution for Laravel + Livewire apps. Works great with Blade forms too. Includes JS hooks, flexible config, and easy customization.

## Installation 🚀

Add dependency to your project:

```elixir
def deps do
  [
    {:ckeditor5_phoenix, "~> 1.3.0"}
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

Next, add CKEditor 5 to your view as follows:

```heex
<%!-- In your <head> section, include the CKEditor 5 cloud assets --%>
<.cke_cloud_assets />

<%!-- In your <body>, you can use the classic editor as a function component: --%>
<.ckeditor
  type="classic"
  value="<p>Initial content here</p>"
  editable_height="300px"
/>

<%!-- Or, if you prefer, as a LiveComponent for more advanced scenarios: --%>
<.live_component
  id="editor"
  module={CKEditor5.Components.Editor}
  type="classic"
/>
```

🎉 Voila! You now have CKEditor 5 integrated into your Phoenix application. The editor will be loaded from the CKEditor 5 cloud distribution, and you can start using it right away. 🚀

## Using translations (localization) 🌐

You can easily enable different languages in CKEditor 5 by specifying which translation files should be loaded. There are two ways to do this:

1. **Via the `cloud.translations` preset option**: In your config, you can set which language files will be included in the import map and preloaded automatically.
2. **Directly in the `translations` parameter of the `<.cke_cloud_assets />` component**: You can pass a list of language codes (like `["pl", "de"]`) to load only those translations for the editor.

### Minimal usage example

In your layout or page template:

```heex
<.cke_cloud_assets translations={["pl", "de"]} />
```

This will preload only the Polish and German translation files for CKEditor 5 from the cloud. The editor UI will then be able to use these languages.

You can also control available translations globally in your config using the `cloud.translations` preset.

#### Setting editor UI and content language

You can control the language of the editor interface (UI) and the language of the content separately using the `language` and `content_language` attributes in the `.ckeditor` component:

```heex
<.ckeditor
  language="de"           # Editor UI in German
  content_language="pl"   # Content (editable area) in Polish
/>
```

**Difference:**

* `language` sets the language for the editor's UI (toolbars, tooltips, menus, etc.).
* `content_language` sets the `lang` attribute for the editable area, which is important for spellchecking, screen readers, and content semantics. If not set, it defaults to the same as `language`.

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
<.ckeditor value="Hello world" change_event />

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

This approach allows for full real-time synchronization of the editor state with the backend.

## CKEditor 5 in a Phoenix LiveView form 📝

Here is a simple example of how to use CKEditor 5 inside a Phoenix LiveView form. The editor value is kept in sync with the backend. When you save the form, the content is shown below the form.

### Template (`.html.heex`)

```heex
<.form for={@form} phx-change="validate" phx-submit="save" class="space-y-4">
  <div>
    <label class="block mb-1 font-bold">Content</label>
    <.live_component
      id="editor"
      module={CKEditor5.Components.Editor}
      field={@form[:content]}
    />
  </div>
  <button type="submit" class="bg-blue-600 px-4 py-2 rounded text-white">Save</button>
</.form>

<%= if @saved do %>
  <div class="bg-green-100 mt-4 p-4 border border-green-400">
    <strong>Saved content:</strong>
    <div class="mt-2 max-w-none prose" style="white-space: pre-wrap;">
      <%= @form[:content].value %>
    </div>
  </div>
<% end %>
```

### LiveView (`.ex`)

```elixir
defmodule Playground.Live.ClassicForm do
  @moduledoc """
  LiveView for demonstrating CKEditor5 Classic integration with a form.
  """

  alias Phoenix.Component

  use Playground, :live_view
  use CKEditor5

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, saved: false, form: Component.to_form(%{"content" => "Initial content"}, as: :form))}
  end

  @impl true
  def handle_event("validate", %{"form" => form}, socket) do
    {:noreply, assign(socket, saved: false, form: Component.to_form(form, as: :form))}
  end

  @impl true
  def handle_event("save", %{"form" => form}, socket) do
    {:noreply, assign(socket, saved: true, form: Component.to_form(form, as: :form))}
  end
end
```

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
