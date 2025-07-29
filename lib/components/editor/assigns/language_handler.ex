defmodule CKEditor5.Components.Editor.LanguageHandler do
  @moduledoc """
  Provides a list of supported CKEditor 5 language codes and handles language code normalization for CKEditor integration.
  """

  import CKEditor5.Components.LanguageNormalizer, only: [normalize_language: 1]

  @doc """
  Assigns the normalized language and content_language to the assigns map. The language is used in UI of the editor,
  while content language is used for editable content.

  If no language is provided, it defaults to "en".
  """
  def assign_language(%{language: language, content_language: content_language} = assigns) do
    new_language = normalize_language(language)
    new_content_language = normalize_language(content_language || language)

    assigns
    |> Map.put(:language, new_language)
    |> Map.put(:content_language, new_content_language)
  end
end
