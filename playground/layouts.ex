defmodule Playground.Layouts do
  @moduledoc """
  Layout templates for the playground application.

  This module handles the rendering of layout templates used throughout the playground.
  """

  use Playground, :html

  embed_templates "layouts/*"
end
