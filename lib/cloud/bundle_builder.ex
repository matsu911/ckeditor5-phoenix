defmodule CKEditor5.Cloud.BundleBuilder do
  @moduledoc """
  Module responsible for building bundlemap entries for CKEditor5 cloud bundles.

  This module creates the necessary bundle entries for different CKEditor5 components
  based on the cloud configuration, including the main editor, premium features, and CKBox.
  """

  alias CKEditor5.Cloud
  alias CKEditor5.Cloud.Bundle
  alias CKEditor5.Cloud.Bundle.{CKEditor5, CKEditor5PremiumFeatures, CKBox}

  @doc """
  Builds the complete bundles map for the given cloud configuration.
  """
  def build(%Cloud{} = cloud) do
    %Bundle{}
    |> add_ckeditor5_bundle(cloud)
    |> add_premium_features_bundle(cloud)
    |> add_ckbox_bundle(cloud)
  end

  # Adds the main CKEditor5 bundle entry to the bundles map
  # This is always included as it's the core editor functionality
  defp add_ckeditor5_bundle(bundle, cloud) do
    ckeditor5_bundle = CKEditor5.build_bundle(cloud.version, cloud.translations)

    Bundle.merge(bundle, ckeditor5_bundle)
  end

  # Adds premium features bundle entry when premium features are enabled
  # Only included when cloud.premium is set to true
  defp add_premium_features_bundle(bundle, %{premium: true} = cloud) do
    premium_bundle = CKEditor5PremiumFeatures.build_bundle(cloud.version, cloud.translations)

    Bundle.merge(bundle, premium_bundle)
  end

  # No-op when premium features are disabled
  defp add_premium_features_bundle(bundle, %{premium: false}), do: bundle

  # Adds CKBox bundle entry when CKBox version is specified
  # Only included when cloud.ckbox contains a version string
  defp add_ckbox_bundle(bundle, %{ckbox: ckbox_version} = cloud) when is_binary(ckbox_version) do
    ckbox_bundle = CKBox.build_bundle(ckbox_version, cloud.translations)

    Bundle.merge(bundle, ckbox_bundle)
  end

  # No-op when CKBox is not configured (ckbox: nil)
  defp add_ckbox_bundle(bundle, %{ckbox: nil}), do: bundle
end
