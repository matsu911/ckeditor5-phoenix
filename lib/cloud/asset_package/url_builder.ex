defmodule CKEditor5.Cloud.UrlBuilder do
  @moduledoc """
  Builds URLs for CKEditor 5 Cloud resources.
  """

  @type cdn_type() :: :ckeditor | :ckbox

  @ckeditor_base_url "https://cdn.ckeditor.com/"
  @ckbox_base_url "https://cdn.ckbox.io/"

  @doc """
  Builds the URL for a specific Cloud resource.

  ## Parameters

    * `cdn_type`: The CDN type, either `:ckeditor` or `:ckbox`.
    * `path_segments` or `resource_path`: A list of path segments that will be joined with "/" or a single resource path string.

  ## Examples

      iex> CKEditor5.Cloud.UrlBuilder.build_url(:ckeditor, ["path", "to", "resource"])
      "https://cdn.ckeditor.com/path/to/resource"

      iex> CKEditor5.Cloud.UrlBuilder.build_url(:ckbox, "path/to/resource")
      "https://cdn.ckbox.io/path/to/resource"

  """
  @spec build_url(cdn_type(), list(binary())) :: binary()
  def build_url(cdn_type, path_segments) when is_atom(cdn_type) and is_list(path_segments) do
    resource_path = Enum.join(path_segments, "/")
    build_url(cdn_type, resource_path)
  end

  @spec build_url(cdn_type(), binary()) :: binary()
  def build_url(cdn_type, resource_path) when is_atom(cdn_type) and is_binary(resource_path) do
    base_url = get_base_url(cdn_type)
    "#{base_url}#{resource_path}"
  end

  defp get_base_url(:ckeditor), do: @ckeditor_base_url
  defp get_base_url(:ckbox), do: @ckbox_base_url
end
