defmodule CKEditor5.Cloud.AssetPackage do
  alias CKEditor5.Cloud.AssetPackage.JSAsset

  @moduledoc """
  Represents a package of JavaScript and CSS assets for CKEditor 5 Cloud.
  """

  @type js_asset :: JSAsset.t()
  @type css_asset :: binary()

  defstruct js: [], css: []

  @doc """
  Merges the current asset package with another asset package, combining js and css arrays.
  """
  def merge(%__MODULE__{} = asset_package, %__MODULE__{} = other_asset_package) do
    %__MODULE__{
      js: asset_package.js ++ other_asset_package.js,
      css: asset_package.css ++ other_asset_package.css
    }
  end
end
