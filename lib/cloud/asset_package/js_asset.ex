defmodule CKEditor5.Cloud.AssetPackage.JSAsset do
  @moduledoc """
  Represents a JavaScript asset in an asset package.
  """

  @enforce_keys [:name, :url, :type]
  defstruct name: nil,
            url: nil,
            type: :esm

  @type t :: %__MODULE__{
          name: String.t(),
          url: String.t(),
          type: :esm | :umd
        }
end
