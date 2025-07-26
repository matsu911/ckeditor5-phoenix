# CKEditor 5 Phoenix Integration ✨

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-green.svg?style=flat-square)](http://makeapullrequest.com)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/mati365/ckeditor5-phoenix?style=flat-square)
[![GitHub issues](https://img.shields.io/github/issues/mati365/ckeditor5-phoenix?style=flat-square)](https://github.com/Mati365/ckeditor5-phoenix/issues)
[![Elixir Coverage](https://img.shields.io/badge/Elixir-100%25-brightgreen?logo=elixir&logoColor=white&style=flat-square)](https://coveralls.io/github/Mati365/ckeditor5-phoenix?branch=main)
[![TS Coverage](https://img.shields.io/badge/TypeScript-100%25-brightgreen?logo=typescript&logoColor=white&style=flat-square)](https://codecov.io/gh/Mati365/ckeditor5-phoenix?flag=npm)

CKEditor 5 integration library for Phoenix (Elixir) applications. Provides web components and helper functions for seamless editor integration with support for classic, inline, balloon, and decoupled editor types.

> [!IMPORTANT]
> This package is unofficial and not maintained by CKSource. For official CKEditor 5 documentation, visit [ckeditor.com](https://ckeditor.com/docs/ckeditor5/latest/). If you encounter any issues in the editor, please report them on the [GitHub repository](https://github.com/ckeditor/ckeditor5/issues).

<p align="center">
  <img src="docs/intro-classic-editor.png" alt="CKEditor 5 Classic Editor in Phoenix (Elixir) application">
</p>

## Installation 🚀

```bash
def deps do
  [
    {:ckeditor5, "~> 1.0.4"}
  ]
end
```

(optionally) If you use `npm` and `node_modules` in your Phoenix application, you can install the frontend assets using the following command:

```bash
npm install ckeditor5-phoenix
```

However, the ckeditor5 NPM dependency should be also installed within deps of mix package.

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
