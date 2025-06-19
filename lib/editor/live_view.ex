defmodule CKEditor5.Editor.LiveView do
  @moduledoc """
  LiveView module for CKEditor 5 integration in Phoenix Framework.

  This module provides the necessary functionality to render and manage CKEditor 5 instances within Phoenix LiveView.
  """

  use Phoenix.LiveView
  import CKEditor5.Helpers

  @doc """
  Renders the CKEditor 5 component in a LiveView.
  """
  def ckeditor5(assigns) do
    assigns = assigns |> assign_id_if_missing("cke")

    ~H"""
    <div id={assigns[:id]} phx-update="ignore" phx-hook="CKEditor5"></div>
    """
  end
end
