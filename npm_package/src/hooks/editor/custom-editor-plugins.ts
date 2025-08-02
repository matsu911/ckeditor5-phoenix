import type { PluginConstructor } from 'ckeditor5';

import type { CanBePromise } from '../../types';

type PluginReader = () => CanBePromise<PluginConstructor>;

const CUSTOM_PLUGINS = new Map<string, PluginReader>();

/**
 * Registers a custom plugin for the CKEditor.
 *
 * @param name The name of the plugin.
 * @param reader The plugin reader function that returns the plugin constructor.
 */
export function registerCustomEditorPlugin(name: string, reader: PluginReader) {
  if (CUSTOM_PLUGINS.has(name)) {
    throw new Error(`Plugin with name "${name}" is already registered.`);
  }

  CUSTOM_PLUGINS.set(name, reader);

  return unregisterCustomEditorPlugin.bind(null, name);
}

/**
 * Removes a custom plugin by its name.
 *
 * @param name The name of the plugin to unregister.
 * @throws Will throw an error if the plugin is not registered.
 */
export function unregisterCustomEditorPlugin(name: string) {
  if (!CUSTOM_PLUGINS.has(name)) {
    throw new Error(`Plugin with name "${name}" is not registered.`);
  }

  CUSTOM_PLUGINS.delete(name);
}

/**
 * Removes all custom editor plugins.
 * This is useful for cleanup in tests or when reloading plugins.
 */
export function unregisterAllCustomEditorPlugins() {
  CUSTOM_PLUGINS.clear();
}

/**
 * Retrieves a custom plugin by its name.
 *
 * @param name The name of the plugin.
 * @returns The plugin constructor or undefined if not found.
 */
export async function getCustomEditorPlugin(name: string): Promise<PluginConstructor | undefined> {
  const reader = CUSTOM_PLUGINS.get(name);

  return reader?.();
}
