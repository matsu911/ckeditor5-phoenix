defmodule CKEditor5.Cloud.AssetPackage do
  @moduledoc """
  Represents a single asset package containing JavaScript and CSS assets.
  This module provides functionality to merge multiple asset packages.
  """

  alias CKEditor5.Cloud.AssetPackage.JSAsset

  defstruct js: [], css: []

  @type js_asset :: JSAsset.t()
  @type css_asset :: binary()
  @type t :: %__MODULE__{
          js: [js_asset()],
          css: [css_asset()]
        }

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
