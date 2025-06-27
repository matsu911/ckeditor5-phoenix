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

  @doc """
  Unwraps a result tuple `{:ok, value}` or raises an error for `{:error, reason}`.
  """
  defmacro unwrap_or_raise(result, opts) do
    prefix = Keyword.get(opts, :prefix, "Error")
    inspect_reason = Keyword.get(opts, :inspect, false)

    quote do
      case unquote(result) do
        {:ok, value} ->
          value

        {:error, reason} ->
          message =
            if unquote(inspect_reason) do
              "#{unquote(prefix)}: #{inspect(reason)}"
            else
              "#{unquote(prefix)}: #{reason}"
            end

          raise CKEditor5.Error, message

        _ ->
          raise CKEditor5.Error, message: "#{unquote(prefix)}: Unexpected result format"
      end
    end
  end

  @doc """
  Checks if a given version string is in semantic versioning format (e.g., "1.0.0").
  """
  def is_semver_version?(version) when is_binary(version) do
    String.match?(version, ~r/^\d+\.\d+\.\d+$/)
  end
end
