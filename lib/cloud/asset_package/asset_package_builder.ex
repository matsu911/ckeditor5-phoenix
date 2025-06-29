defmodule CKEditor5.Cloud.AssetPackageBuilder do
  @moduledoc """
  Module responsible for building asset packages for CKEditor5 cloud resources.

  This module creates the necessary asset packages for different CKEditor5 components
  based on the cloud configuration, including the main editor, premium features, and CKBox.
  """

  alias CKEditor5.Cloud
  alias CKEditor5.Cloud.AssetPackage
  alias CKEditor5.Cloud.AssetPackage.{CKBox, CKEditor5, CKEditor5PremiumFeatures}

  @doc """
  Builds the complete asset package for the given cloud configuration.
  """
  def build(%Cloud{} = cloud) do
    %AssetPackage{}
    |> add_ckeditor5_package(cloud)
    |> add_premium_features_package(cloud)
    |> add_ckbox_package(cloud)
  end

  # Adds the main CKEditor5 package to the asset package
  # This is always included as it's the core editor functionality
  defp add_ckeditor5_package(asset_package, cloud) do
    ckeditor5_package = CKEditor5.build_package(cloud.version, cloud.translations)

    AssetPackage.merge(asset_package, ckeditor5_package)
  end

  # Adds premium features package when premium features are enabled
  # Only included when cloud.premium is set to true
  defp add_premium_features_package(asset_package, %{premium: true} = cloud) do
    premium_package = CKEditor5PremiumFeatures.build_package(cloud.version, cloud.translations)

    AssetPackage.merge(asset_package, premium_package)
  end

  # No-op when premium features are disabled
  defp add_premium_features_package(asset_package, %{premium: false}), do: asset_package

  # Adds CKBox package when CKBox version is specified
  # Only included when cloud.ckbox contains a version string
  defp add_ckbox_package(asset_package, %{ckbox: ckbox_version} = cloud)
       when is_binary(ckbox_version) do
    ckbox_package = CKBox.build_package(ckbox_version, cloud.translations)

    AssetPackage.merge(asset_package, ckbox_package)
  end

  # No-op when CKBox is not configured (ckbox: nil)
  defp add_ckbox_package(asset_package, %{ckbox: nil}), do: asset_package
end
