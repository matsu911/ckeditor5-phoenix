defmodule CKEditor5.Cloud.Bundle do
  alias CKEditor5.Cloud.Bundle.JSAsset

  @moduledoc """
  Represents a bundle of JavaScript and CSS files for CKEditor 5 Cloud.
  """

  @type js_asset :: JSAsset.t()
  @type css_asset :: binary()

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
