defmodule CKEditor5.Errors.Error do
  @moduledoc """
  Represents an error in the CKEditor 5 integration.
  """

  defexception [:message, :reason]

  @doc """
  Creates a new CKEditor5 error with the given reason.
  """
  def exception(message, reason \\ nil) do
    %__MODULE__{message: message, reason: reason}
  end
end
