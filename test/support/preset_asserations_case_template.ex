defmodule CKEditor5.Test.PresetAssertionsCaseTemplate do
  @moduledoc """
  A test case for asserting CKEditor5 presets.
  This module provides a setup for testing CKEditor5 presets with a focus on cloud license keys
  and preset configurations.
  """

  use ExUnit.CaseTemplate

  alias CKEditor5.Test.{LicenseGenerator, PresetsHelper}

  setup do
    cloud_license_key = LicenseGenerator.generate_key("cloud")
    original_config = PresetsHelper.put_presets_env(%{})

    on_exit(fn -> PresetsHelper.restore_presets_env(original_config) end)

    {:ok, cloud_license_key: cloud_license_key}
  end

  using do
    quote do
      def default_preset(key, opts \\ []) do
        Map.merge(
          %{
            license_key: key,
            config: %{},
            cloud: %{
              version: "40.0.0",
              premium: false,
              translations: ["pl"]
            }
          },
          Enum.into(opts, %{})
        )
      end
    end
  end
end
