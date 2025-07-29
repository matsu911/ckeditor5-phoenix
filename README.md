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

## Table of Contents

- [CKEditor 5 Phoenix Integration ✨](#ckeditor-5-phoenix-integration-)
  - [Table of Contents](#table-of-contents)
  - [Installation 🚀](#installation-)
  - [Installation Methods 🛠️](#installation-methods-️)
    - [📡 CDN Distribution (Recommended)](#-cdn-distribution-recommended)
    - [🏠 Self-hosted](#-self-hosted)
  - [Basic Usage 🏁](#basic-usage-)
    - [Simple Editor ✏️](#simple-editor-️)
    - [With LiveView Sync 🔄](#with-liveview-sync-)
  - [Editor Types 🖊️](#editor-types-️)
    - [Classic editor 📝](#classic-editor-)
    - [Multiroot editor 🌳](#multiroot-editor-)
    - [Inline editor 📝](#inline-editor-)
    - [Decoupled editor 📝](#decoupled-editor-)
  - [Forms Integration 🧾](#forms-integration-)
    - [Phoenix Form Helper 🧑‍💻](#phoenix-form-helper-)
    - [LiveView Handler ⚡](#liveview-handler-)
  - [Configuration ⚙️](#configuration-️)
    - [Custom Presets 🧩](#custom-presets-)
    - [Use Custom Preset 🧩](#use-custom-preset-)
    - [Providing the License Key 🗝️](#providing-the-license-key-️)
  - [Localization 🌍](#localization-)
    - [CDN Translation Loading 🌐](#cdn-translation-loading-)
    - [Global Translation Config 🛠️](#global-translation-config-️)
  - [Package development 🛠️](#package-development-️)
  - [Psst... 👀](#psst-)
  - [Trademarks 📜](#trademarks-)
  - [License 📜](#license-)

## Installation 🚀

Easily add CKEditor 5 Phoenix to your Phoenix (Elixir) project. This section explains how to add the dependency, register the JavaScript hook, and use the editor in your templates.

Add dependency to your project:

```elixir
def deps do
  [
    {:ckeditor5_phoenix, "~> 1.4.0"}
  ]
end
```

Register the JavaScript hook:

```javascript
import { Hooks } from 'ckeditor5_phoenix';

const liveSocket = new LiveSocket('/live', Socket, {
  hooks: Hooks,
});
```

Add editor to your template:

```heex
<%!-- CDN version (recommended for quick start, place it in `<head>`) --%>
<.cke_cloud_assets />

<%!-- Place it in <body> where you want the editor to appear --%>
<.ckeditor type="classic" value="<p>Hello world!</p>" />
```

That's it! 🎉

## Installation Methods 🛠️

Choose how you want to include CKEditor 5 in your project. Use the CDN for a quick start or self-host for more control and customization.

### 📡 CDN Distribution (Recommended)

> [!WARNING]
> **CDN usage requires a license key from CKSource.**
> The first 1,000 loads per month are free; above that, usage is paid.
> See [CKEditor 5 Pricing](https://ckeditor.com/pricing/) for details.

Load CKEditor 5 directly from CDN - no build required. This is the fastest way to get started and is ideal for most users.

**Setup:**

1. Use `<.cke_cloud_assets />` in your layout's `<head>`
2. Exclude CKEditor from your bundler:

```elixir
# config/config.exs
config :my_app, MyAppWeb.Endpoint,
  watchers: [
    esbuild: {Esbuild, :install_and_run, [
      :my_app,
      ~w(--external:ckeditor5 --external:ckeditor5-premium-features)
    ]}
  ]
```

3. Add license key to your preset or environment variable. See [Providing the License Key 🗝️](#providing-the-license-key-%EF%B8%8F) section for details.

### 🏠 Self-hosted

Bundle CKEditor 5 with your application for full control over assets and configuration. Recommended for advanced users or those with custom builds.

**Setup:**

1. **Don't** use `<.cke_cloud_assets />`
2. Install `ckeditor5` package via npm `npm install ckeditor5`
3. Import styles manually in your CSS:

```css
/* assets/css/app.css */
@import "ckeditor5/ckeditor5.css";
```

## Basic Usage 🏁

Get started with the most common usage patterns. Learn how to render the editor in your templates and handle content changes.

### Simple Editor ✏️

The lightest way to use CKEditor 5 in your Phoenix application. Just include the editor component with initial content. The editor will be rendered with a default toolbar and basic features defined in `:default` preset.

```heex
<%!-- CDN only: Load assets in <head> --%>
<.cke_cloud_assets />

<%!-- Editor --%>
<.ckeditor
  type="classic"
  value="<p>Initial content</p>"
  editable_height="300px"
/>
```

### With LiveView Sync 🔄

Editor with LiveView support for real-time content updates. In other words, the editor will send changes to the server when the content is modified. Use the `change_event` attribute to handle changes in your LiveView.

```heex
<.ckeditor value={@content} change_event />
```

```elixir
def handle_event("ckeditor5:change", %{"data" => data}, socket) do
  {:noreply, assign(socket, content: data["main"])}
end
```

The events are send automatically when the content is modified. It's possible to change debounce time for the events by setting `debounce` attribute on the editor component:

```heex
<.ckeditor value={@content} change_event debounce_ms={500} />
```

It may improve performance by reducing the number of events sent to the server, especially for large content or frequent changes.

## Editor Types 🖊️

CKEditor 5 supports multiple editor types to fit different use cases. This section shows how to use classic, inline, multiroot, and decoupled editors.

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

### Decoupled editor 📝

The decoupled editor is a more advanced type of editor that allows you to separate the toolbar from the editable area. This is useful when you want to create a custom layout or use the editor in a more complex UI.

![CKEditor 5 Decoupled Editor in Elixir Phoenix application](docs/decoupled-editor.png)

```heex
<%!-- In <head> --%>
<.cke_cloud_assets />

<%!-- In <body> --%>
<.ckeditor type="decoupled" >

<div class="flex flex-col gap-4">
  <.cke_ui_part name="toolbar" />
  <.cke_editable
    root="main"
    value="<p>Initial content here</p>"
    class="border border-gray-300"
    editable_height="300px"
  />
</div>
```

## Forms Integration 🧾

Integrate CKEditor 5 with Phoenix forms and LiveView. Learn how to use the editor in forms and handle events for real-time updates.

### Phoenix Form Helper 🧑‍💻

The `ckeditor` creates hidden input field that is used to store value of the editor within the form. The `name` of such input is built from `field` attribute of the `ckeditor` component. The value of the input is set to the content of the editor.

```heex
<.form for={@form} phx-submit="save">
  <.live_component
    id="content-editor"
    module={CKEditor5.Components.Editor}
    field={@form[:content]}
  />

  <button type="submit">Save</button>
</.form>
```

### LiveView Handler ⚡

```elixir
defmodule MyApp.PageLive do
  use MyAppWeb, :live_view
  use CKEditor5  # Adds event handlers

  def mount(_params, _session, socket) do
    form = to_form(%{"content" => ""}, as: :form)
    {:ok, assign(socket, form: form)}
  end

  def handle_event("validate", %{"form" => params}, socket) do
    {:noreply, assign(socket, form: to_form(params, as: :form))}
  end

  def handle_event("save", %{"form" => params}, socket) do
    # Process form data
    {:noreply, socket}
  end
end
```

## Configuration ⚙️

You can configure the editor _presets_ in your `config/config.exs` file. The default preset is `:default`, which provides a basic configuration with a toolbar and essential plugins. The preset is a map that contains the editor configuration, including the toolbar items and plugins. There can be multiple presets, and you can switch between them by passing the `preset` keyword argument to the `ckeditor` component.

### Custom Presets 🧩

In order to override the default preset or add custom presets, you can add the following configuration to your `config/config.exs` file:

```elixir
# config/config.exs
config :ckeditor5_phoenix,
  presets: %{
    minimal: %{
      config: %{
        toolbar: [:bold, :italic, :link],
        plugins: [:Bold, :Italic, :Link, :Essentials, :Paragraph]
      }
    },
    full: %{
      config: %{
        toolbar: [
          :heading, :|, :bold, :italic, :underline, :|,
          :link, :insertImage, :insertTable, :|,
          :bulletedList, :numberedList, :blockQuote
        ],
        plugins: [
          :Heading, :Bold, :Italic, :Underline, :Link,
          :ImageBlock, :ImageUpload, :Table, :List, :BlockQuote,
          :Essentials, :Paragraph
        ]
      }
    }
  }
```

### Use Custom Preset 🧩

To use a custom preset, pass the `preset` keyword argument to the `ckeditor` component. For example, to use the `minimal` preset defined above:

```heex
<.ckeditor preset="minimal" value="<p>Simple editor</p>" />
```

### Providing the License Key 🗝️

CKEditor 5 requires a license key when using the official CDN or premium features. You can provide the license key in two simple ways:

1. **Environment variable**: Set the `CKEDITOR5_LICENSE_KEY` environment variable before starting your Phoenix app. This is the easiest and most common way.
2. **Preset config**: You can also set the license key directly in your preset configuration in `config/config.exs`:

   ```elixir
   config :ckeditor5_phoenix,
     presets: %{
       default: %{
         license_key: "your-license-key-here"
       }
     }
   ```

If you use CKEditor 5 under the GPL license, you do not need to provide a license key. However, if you choose to set one, it must be set to `GPL`.

If both are set, the preset config takes priority. For more details, see the [CKEditor 5 licensing guide](https://ckeditor.com/docs/ckeditor5/latest/getting-started/licensing/license-and-legal.html).

## Localization 🌍

Support multiple languages in the editor UI and content. Learn how to load translations via CDN or configure them globally.

### CDN Translation Loading 🌐

Depending on your setup, you can preload translations via CDN or let your bundler handle them automatically using lazy imports.

```heex
<%!-- CDN only: Load specific translations --%>
<.cke_cloud_assets translations={["pl", "de", "fr"]} />

<.ckeditor
  language="pl"
  content_language="en"
  value="<p>Content in English, UI in Polish</p>"
/>
```

### Global Translation Config 🛠️

You can also configure translations globally in your `config/config.exs` file. This is useful if you want to load translations for multiple languages at once or set a default language for the editor. Keep in mind that this configuration is only used when loading translations via CDN. If you are using self-hosted setup, translations are handled by your bundler automatically.

```elixir
# config/config.exs
config :ckeditor5_phoenix,
  presets: %{
    default: %{
      cloud: %{
        translations: ["pl", "de", "fr"]  # CDN only
      }
    }
  }
```

**Note:** For self-hosted setups, translations are handled by your bundler automatically.

## Package development 🛠️

In order to contribute to CKEditor 5 Phoenix or run it locally for manual testing, here are some handy commands to get you started.

To run the minimal Phoenix application with CKEditor 5 integration, install dependencies and start the server:

```bash
mix playground
```

Run tests using the `mix test` command. All tests are located in the `test/` directory.

```bash
mix test
```

To generate a code coverage report, use:

```bash
mix coveralls.html
```

## Psst... 👀

Discover related projects for other frameworks and languages. Find inspiration or alternative integrations for CKEditor 5.

Looking for similar projects or inspiration? Check out these repositories:

- [ckeditor5-rails](https://github.com/Mati365/ckeditor5-rails)
  Effortless CKEditor 5 integration for Ruby on Rails. Works seamlessly with standard forms, Turbo, and Hotwire. Easy setup, custom builds, and localization support.

- [ckeditor5-livewire](https://github.com/Mati365/ckeditor5-livewire)
  Plug-and-play CKEditor 5 solution for Laravel + Livewire applications. Fully compatible with Blade forms. Includes JavaScript hooks, flexible configuration, and easy customization.

## Trademarks 📜

Information about CKEditor® trademarks and licensing. Clarifies the relationship between this package and CKSource.

CKEditor® is a trademark of [CKSource Holding sp. z o.o.](https://cksource.com/) All rights reserved. For more information about the license of CKEditor® please visit [CKEditor's licensing page](https://ckeditor.com/legal/ckeditor-oss-license/).

This package is not owned by CKSource and does not use the CKEditor® trademark for commercial purposes. It should not be associated with or considered an official CKSource product.

## License 📜

Details about the MIT license for this project and CKEditor 5's GPL license. Make sure to review both licenses for compliance.

This project is licensed under the terms of the [MIT LICENSE](LICENSE).

This project injects CKEditor 5 which is licensed under the terms of [GNU General Public License Version 2 or later](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html). For more information about CKEditor 5 licensing, please see their [official documentation](https://ckeditor.com/legal/ckeditor-oss-license/).
