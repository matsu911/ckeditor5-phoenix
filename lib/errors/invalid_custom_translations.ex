defmodule CKEditor5.Errors.InvalidCustomTranslations do
  @moduledoc """
  Exception raised when custom translations are invalid.
  """
  defexception [:reason]

  @impl true
  def message(exception) do
    "Invalid Custom Translations: #{inspect(exception.reason)}"
  end
end
