defmodule CKEditor5.Error do
  @moduledoc """
  Represents an error in the CKEditor 5 integration.
  """

  defexception [:message, :reason]

  @doc """
  Creates a new CKEditor5 error with the given reason.
  """
  def exception(message, reason \\ nil) do
    %__MODULE__{message: message, reason: reason}
  end
end

defmodule CKEditor5.PresetNotFoundError do
  @moduledoc """
  Exception raised when a CKEditor5 preset is not found.
  """
  defexception [:preset_name, :available_presets]

  @impl true
  def message(exception) do
    available = exception.available_presets |> Enum.sort() |> Enum.join(", ")
    "Preset '#{exception.preset_name}' not found. Available presets: #{available}"
  end
end

defmodule CKEditor5.InvalidPresetError do
  @moduledoc """
  Exception raised when a CKEditor5 preset configuration is invalid.
  """
  defexception [:reason]

  @impl true
  def message(exception) do
    "Invalid preset configuration: #{inspect(exception.reason)}"
  end
end

defmodule CKEditor5.InvalidCloudConfigurationError do
  @moduledoc """
  Exception raised when a Cloud configuration is invalid.
  """
  defexception [:reason]

  @impl true
  def message(exception) do
    "Invalid Cloud configuration: #{inspect(exception.reason)}"
  end
end

defmodule CKEditor5.CloudNotAvailableInLicenseError do
  @moduledoc """
  Exception raised when Cloud is not available in the current license.
  """
  defexception [:license_key]

  @impl true
  def message(exception) do
    "Cloud is not available in the current license: #{exception.license_key}"
  end
end
