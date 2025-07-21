defmodule CKEditor5.PresetsTest do
  use ExUnit.Case, async: true

  alias CKEditor5.{Errors, Preset, Presets}
  alias CKEditor5.Test.LicenseGenerator

  describe "get/1" do
    test "returns {:ok, preset} for the default preset" do
      assert {:ok, %Preset{} = preset} = Presets.get("default")

      # Verify the preset has the expected structure
      assert preset.config.toolbar
      assert preset.config.plugins
      assert preset.config.image
      assert is_list(preset.config.toolbar)
      assert is_list(preset.config.plugins)
      assert is_map(preset.config.image)
    end

    test "returns {:error, %PresetNotFound{}} for non-existent preset" do
      assert {:error, %Errors.PresetNotFound{} = error} = Presets.get("non-existent")

      assert error.preset_name == "non-existent"
      assert is_list(error.available_presets)
      assert "default" in error.available_presets
    end

    test "returns preset from application configuration when available" do
      # Setup a custom preset in the application environment
      custom_preset = %{
        config: %{
          toolbar: [:bold, :italic],
          plugins: [:Bold, :Italic, :Essentials]
        }
      }

      # Store the original config
      original_config = Application.get_env(:ckeditor5, :presets, %{})

      try do
        # Set custom config
        Application.put_env(:ckeditor5, :presets, %{"custom" => custom_preset})

        assert {:ok, %Preset{} = preset} = Presets.get("custom")
        assert preset.config.toolbar == [:bold, :italic]
        assert preset.config.plugins == [:Bold, :Italic, :Essentials]
      after
        # Restore original config
        Application.put_env(:ckeditor5, :presets, original_config)
      end
    end

    test "custom presets override default presets" do
      # Override the default preset
      custom_default = %{
        config: %{
          toolbar: [:bold],
          plugins: [:Bold, :Essentials]
        }
      }

      original_config = Application.get_env(:ckeditor5, :presets, %{})

      try do
        Application.put_env(:ckeditor5, :presets, %{"default" => custom_default})

        assert {:ok, %Preset{} = preset} = Presets.get("default")
        assert preset.config.toolbar == [:bold]
        assert preset.config.plugins == [:Bold, :Essentials]
      after
        Application.put_env(:ckeditor5, :presets, original_config)
      end
    end

    test "returns error when preset parsing fails" do
      # Setup an invalid preset configuration
      invalid_preset = %{
        # This should cause parsing to fail
        type: :invalid_type,
        config: %{}
      }

      original_config = Application.get_env(:ckeditor5, :presets, %{})

      try do
        Application.put_env(:ckeditor5, :presets, %{"invalid" => invalid_preset})

        assert {:error, _reason} = Presets.get("invalid")
      after
        Application.put_env(:ckeditor5, :presets, original_config)
      end
    end

    test "works with license key in preset configuration" do
      key = LicenseGenerator.generate_key("cloud")

      preset_with_license = %{
        config: %{
          toolbar: [:bold],
          plugins: [:Bold, :Essentials]
        },
        license_key: key
      }

      original_config = Application.get_env(:ckeditor5, :presets, %{})

      try do
        Application.put_env(:ckeditor5, :presets, %{"licensed" => preset_with_license})

        assert {:ok, %Preset{} = preset} = Presets.get("licensed")
        assert preset.license.key == key
      after
        Application.put_env(:ckeditor5, :presets, original_config)
      end
    end
  end

  describe "get!/1" do
    test "returns preset for valid preset name" do
      assert %Preset{} = preset = Presets.get!("default")

      # Verify the preset has the expected structure
      assert preset.config.toolbar
      assert preset.config.plugins
      assert preset.config.image
    end

    test "raises PresetNotFound exception for non-existent preset" do
      assert_raise Errors.PresetNotFound, fn ->
        Presets.get!("non-existent")
      end
    end

    test "raises exception when preset parsing fails" do
      invalid_preset = %{
        type: :invalid_type,
        config: %{}
      }

      original_config = Application.get_env(:ckeditor5, :presets, %{})

      try do
        Application.put_env(:ckeditor5, :presets, %{"invalid" => invalid_preset})

        assert_raise Errors.InvalidPreset, fn ->
          Presets.get!("invalid")
        end
      after
        Application.put_env(:ckeditor5, :presets, original_config)
      end
    end

    test "returns custom preset when available" do
      custom_preset = %{
        config: %{
          toolbar: [:bold, :italic],
          plugins: [:Bold, :Italic, :Essentials]
        }
      }

      original_config = Application.get_env(:ckeditor5, :presets, %{})

      try do
        Application.put_env(:ckeditor5, :presets, %{"custom" => custom_preset})

        assert %Preset{} = preset = Presets.get!("custom")
        assert preset.config.toolbar == [:bold, :italic]
      after
        Application.put_env(:ckeditor5, :presets, original_config)
      end
    end
  end

  describe "default preset structure" do
    test "has expected toolbar items" do
      {:ok, preset} = Presets.get("default")

      expected_toolbar_items = [
        :undo,
        :redo,
        :|,
        :heading,
        :|,
        :bold,
        :italic,
        :underline,
        :|,
        :link,
        :insertImage,
        :mediaEmbed,
        :insertTable,
        :blockQuote,
        :|,
        :bulletedList,
        :numberedList,
        :todoList,
        :outdent,
        :indent
      ]

      assert preset.config.toolbar == expected_toolbar_items
    end

    test "has expected plugins" do
      {:ok, preset} = Presets.get("default")

      # Check that essential plugins are present
      essential_plugins = [
        :AccessibilityHelp,
        :Autoformat,
        :AutoImage,
        :Autosave,
        :BlockQuote,
        :Bold,
        :CloudServices,
        :Essentials,
        :Heading,
        :ImageBlock,
        :ImageCaption,
        :ImageInline,
        :ImageInsert,
        :ImageInsertViaUrl,
        :ImageResize,
        :ImageStyle,
        :ImageTextAlternative,
        :ImageToolbar,
        :ImageUpload,
        :Indent,
        :IndentBlock,
        :Italic,
        :Link,
        :LinkImage,
        :List,
        :ListProperties,
        :MediaEmbed,
        :Paragraph,
        :PasteFromOffice,
        :PictureEditing,
        :SelectAll,
        :Table,
        :TableCaption,
        :TableCellProperties,
        :TableColumnResize,
        :TableProperties,
        :TableToolbar,
        :TextTransformation,
        :TodoList,
        :Underline,
        :Undo,
        :Base64UploadAdapter
      ]

      Enum.each(essential_plugins, fn plugin ->
        assert plugin in preset.config.plugins,
               "Plugin #{inspect(plugin)} should be in the default preset"
      end)
    end

    test "has expected image toolbar configuration" do
      {:ok, preset} = Presets.get("default")

      expected_image_toolbar = [
        :imageTextAlternative,
        :imageStyle,
        :imageResize,
        :imageInsertViaUrl
      ]

      assert preset.config.image.toolbar == expected_image_toolbar
    end

    test "default preset type is :classic" do
      {:ok, preset} = Presets.get("default")
      assert preset.type == :classic
    end

    test "default preset has GPL license when no license key provided" do
      {:ok, preset} = Presets.get("default")
      assert preset.license.key == "GPL"
    end
  end

  describe "error handling" do
    test "PresetNotFound error contains helpful information" do
      {:error, error} = Presets.get("non-existent")

      assert %Errors.PresetNotFound{} = error
      assert error.preset_name == "non-existent"
      assert is_list(error.available_presets)
      assert "default" in error.available_presets

      # Test the error message
      message = Exception.message(error)
      assert message =~ "Preset 'non-existent' not found"
      assert message =~ "Available presets:"
      assert message =~ "default"
    end
  end

  describe "application environment integration" do
    test "merges application config with default presets" do
      original_config = Application.get_env(:ckeditor5, :presets, %{})

      try do
        # Add multiple custom presets
        custom_config = %{
          "minimal" => %{
            config: %{
              toolbar: [:bold],
              plugins: [:Bold, :Essentials]
            }
          },
          "rich" => %{
            config: %{
              toolbar: [:bold, :italic, :link, :insertImage],
              plugins: [:Bold, :Italic, :Link, :ImageInsert, :Essentials]
            }
          }
        }

        Application.put_env(:ckeditor5, :presets, custom_config)

        # Default preset should still be available
        assert {:ok, _} = Presets.get("default")

        # Custom presets should be available
        assert {:ok, minimal} = Presets.get("minimal")
        assert minimal.config.toolbar == [:bold]

        assert {:ok, rich} = Presets.get("rich")
        assert rich.config.toolbar == [:bold, :italic, :link, :insertImage]

        # Error should list all available presets
        {:error, error} = Presets.get("non-existent")
        available = error.available_presets
        assert "default" in available
        assert "minimal" in available
        assert "rich" in available
      after
        Application.put_env(:ckeditor5, :presets, original_config)
      end
    end

    test "handles empty application config gracefully" do
      original_config = Application.get_env(:ckeditor5, :presets, %{})

      try do
        Application.put_env(:ckeditor5, :presets, %{})

        # Default preset should still work
        assert {:ok, _} = Presets.get("default")

        # Only default should be available
        {:error, error} = Presets.get("non-existent")
        assert error.available_presets == ["default"]
      after
        Application.put_env(:ckeditor5, :presets, original_config)
      end
    end
  end
end
