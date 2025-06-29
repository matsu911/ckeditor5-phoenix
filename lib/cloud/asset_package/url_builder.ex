defmodule CKEditor5.Cloud.UrlBuilder do
  @moduledoc """
  Builds URLs for CKEditor 5 Cloud resources.
  """

  @base_url "https://cdn.ckeditor.com/"

  @doc """
  Builds the URL for a specific CKEditor 5 Cloud resource.
  Accepts multiple path segments that will be joined with "/".
  """
  def build_url(path_segments) when is_list(path_segments) do
    resource_path = Enum.join(path_segments, "/")

    build_url(resource_path)
  end

  def build_url(resource_path) when is_binary(resource_path) do
    "#{@base_url}#{resource_path}"
  end
end
