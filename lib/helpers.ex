defmodule CKEditor5.Helpers do
  @moduledoc """
  Common helper functions for CKEditor5 components.
  """

  @doc """
  Assigns a unique ID if one is not already present in assigns.
  Generates a random UUID-based ID only when :id key is missing.
  """
  def assign_id_if_missing(assigns, prefix) do
    Phoenix.Component.assign_new(assigns, :id, fn ->
      uuid = :crypto.strong_rand_bytes(16) |> Base.encode16(case: :lower)
      "#{prefix}-#{uuid}"
    end)
  end
end
