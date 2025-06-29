defmodule CKEditor5.Errors.PresetNotFound do
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
