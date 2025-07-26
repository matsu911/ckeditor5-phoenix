defmodule CKEditor5.Cloud.CKEditorCloudUrlBuilder do
  @moduledoc """
  Builds URLs for CKEditor 5 Cloud resources (CKEditor CDN and CKBox CDN).
  Implements the CKEditor5.Cloud.UrlBuilder behavior.
  """

  @behaviour CKEditor5.Cloud.UrlBuilder

  @ckeditor_base_url "https://cdn.ckeditor.com/"
  @ckbox_base_url "https://cdn.ckbox.io/"

  @impl true
  def build_url(cdn_type, path_segments) when is_atom(cdn_type) and is_list(path_segments) do
    resource_path = Enum.join(path_segments, "/")
    build_url(cdn_type, resource_path)
  end

  @impl true
  def build_url(cdn_type, resource_path) when is_atom(cdn_type) and is_binary(resource_path) do
    base_url = get_base_url(cdn_type)
    "#{base_url}#{resource_path}"
  end

  defp get_base_url(:ckeditor), do: @ckeditor_base_url
  defp get_base_url(:ckbox), do: @ckbox_base_url
end
