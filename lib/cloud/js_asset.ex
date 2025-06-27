defmodule CKEditor5.Cloud.Bundle.JSAsset do
  @moduledoc """
  Represents a JavaScript asset in a bundle.
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
