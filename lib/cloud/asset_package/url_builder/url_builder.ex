defmodule CKEditor5.Cloud.UrlBuilder do
  @moduledoc """
  Behavior for building URLs for CKEditor 5 Cloud resources.
  """

  @type cdn_type() :: :ckeditor | :ckbox

  @callback build_url(cdn_type(), list(binary())) :: binary()
end
