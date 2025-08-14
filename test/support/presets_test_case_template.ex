defmodule CKEditor5.Test.PresetsTestCaseTemplate do
  @moduledoc """
  A test case for asserting CKEditor5 presets.
  This module provides a setup for testing CKEditor5 presets with a focus on cloud license keys
  and preset configurations.
  """

  use ExUnit.CaseTemplate

  alias CKEditor5.Test.{LicenseGenerator, PresetsHelper}

  setup do
    Memoize.invalidate()

    cloud_license_key = LicenseGenerator.generate_key("cloud")
    original_config = PresetsHelper.put_presets_env(%{})

    on_exit(fn -> PresetsHelper.restore_presets_env(original_config) end)

    {:ok, cloud_license_key: cloud_license_key}
  end

  using do
    quote do
      import PresetsHelper
    end
  end
end
