/**
 * List of supported CKEditor5 editor types.
 */
const EDITOR_TYPES = ['inline', 'classic', 'balloon', 'decoupled', 'multiroot'] as const;

/**
 * Reads the hook configuration from the element's attribute and parses it as JSON.
 *
 * @param element - The HTML element that contains the hook configuration.
 * @returns The parsed hook configuration.
 */
export function readHookConfigOrThrow(element: HTMLElement): EditorHookConfig {
  const attributeValue = element.getAttribute('cke-hook-config');

  if (!attributeValue) {
    throw new Error('CKEditor5 hook requires a "cke-hook-config" attribute on the element.');
  }

  const { type, config, license } = JSON.parse(attributeValue);

  if (!type || !config || !license) {
    throw new Error('CKEditor5 hook configuration must include "editor", "config", and "license" properties.');
  }

  if (!EDITOR_TYPES.includes(type)) {
    throw new Error(`Invalid editor type: ${type}. Must be one of: ${EDITOR_TYPES.join(', ')}.`);
  }

  return {
    type,
    config,
    license,
  };
}

/**
 * Defines editor type supported by CKEditor5. It must match list of available
 * editor types specified in `preset/parser.ex` file.
 */
export type EditorType = (typeof EDITOR_TYPES)[number];

/**
 * Represents a CKEditor5 plugin as a string identifier.
 */
export type EditorPlugin = string;

/**
 * Configuration object for CKEditor5 editor instance.
 */
export type EditorConfig = {
  /**
   * Array of plugin identifiers to be loaded by the editor.
   */
  plugins: EditorPlugin[];

  /**
   * Other configuration options are flexible and can be any key-value pairs.
   */
  [key: string]: any;
};

/**
 * Represents a license key for CKEditor5.
 */
export type EditorLicense = {
  key: string;
};

/**
 * Configuration object for the CKEditor5 hook.
 */
export type EditorHookConfig = {
  /**
   * The type of CKEditor5 editor to use.
   * Must be one of the predefined types: 'inline', 'classic', 'balloon', 'decoupled', or 'multiroot'.
   */
  type: EditorType;

  /**
   * The configuration object for the CKEditor5 editor.
   * This should match the configuration expected by CKEditor5.
   */
  config: EditorConfig;

  /**
   * The license key for CKEditor5.
   * This is required for using CKEditor5 with a valid license.
   */
  license: EditorLicense;
};
