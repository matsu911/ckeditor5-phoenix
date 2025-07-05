defmodule Playground.PageHTML do
  @moduledoc """
  HTML templates and helpers for page rendering in the playground.

  This module contains the HTML templates and helper functions used
  for rendering pages in the playground application.
  """

  use Playground, :html

  embed_templates "page_html/*"
end
