defmodule CKEditor5.Components.Cloud.Assigns do
  @moduledoc """
  Provides module responsible for creating %Cloud{} structures based on the provided assigns.
  """

  alias CKEditor5.Cloud
  alias CKEditor5.Preset.CloudCompatibilityChecker
  alias CKEditor5.Presets

  @doc """
  Normalizes the assigns to create a %Cloud{} structure.
  """
  defmacro cloud_build_attrs do
    quote do
      attr :preset, :string, default: "default", doc: "The name of the preset to use."

      attr :ckbox, :any,
        default: nil,
        doc: "The CKBox configuration to use. If not provided, the `cloud.ckbox` will be used."

      attr :premium, :boolean,
        default: nil,
        doc:
          "Whether to use the premium features of CKEditor 5. If true, the `cloud.premium` will be used."

      attr :translations, :any,
        default: nil,
        doc:
          "The languages codes for the editor (e.g., 'en', 'pl', 'de', etc.)." <>
            "If not provided, then the `cloud.translations` will be used to load language files."
    end
  end

  @doc """
  Builds the cloud configuration based on the provided assigns.
  It retrieves the preset by name, checks if the cloud configuration is valid,
  and overrides translations and other cloud settings if necessary.
  """
  def build_cloud!(assigns) do
    preset = Presets.get!(assigns.preset)

    CloudCompatibilityChecker.ensure_cloud_configured!(preset)

    overrides =
      Map.take(assigns, [:translations, :premium, :ckbox])
      |> Enum.reject(fn {_k, v} -> is_nil(v) end)
      |> Map.new()

    Cloud.merge(preset.cloud, overrides)
  end
end
