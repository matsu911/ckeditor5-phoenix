defmodule CKEditor5.Cloud.Bundle do
  @moduledoc """
  Represents a bundle of JavaScript and CSS files for CKEditor 5 Cloud.
  """

  defstruct js: [], css: []

  @doc """
  Merges the current bundle with another bundle, combining js and css arrays.
  """
  def merge(%__MODULE__{} = bundle, %__MODULE__{} = other_bundle) do
    %__MODULE__{
      js: bundle.js ++ other_bundle.js,
      css: bundle.css ++ other_bundle.css
    }
  end
end
