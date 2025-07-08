import type { PluginConstructor } from 'ckeditor5';

import type { EditorPlugin } from '../typings';

/**
 * Loads CKEditor plugins from base and premium packages.
 * First tries to load from the base 'ckeditor5' package, then falls back to 'ckeditor5-premium-features'.
 *
 * @param plugins - Array of plugin names to load
 * @returns Promise that resolves to an array of loaded Plugin instances
 * @throws Error if a plugin is not found in either package
 */
export async function loadEditorPlugins(plugins: EditorPlugin[]): Promise<PluginConstructor[]> {
  const basePackage: Record<string, any> = await import('ckeditor5');
  let premiumPackage: Record<string, any> | null = null;

  const loaders = plugins.map(async (plugin) => {
    // Let's first try to load the plugin from the base package.
    // Coverage is disabled due to Vitest issues with mocking dynamic imports.

    /* v8 ignore start */
    const { [plugin]: basePkgImport } = basePackage;

    if (basePkgImport) {
      return basePkgImport as PluginConstructor;
    }

    // Plugin not found in base package, try premium package.
    if (!premiumPackage) {
      try {
        premiumPackage = await import('ckeditor5-premium-features');
      }
      catch (error) {
        console.error(`Failed to load premium package: ${error}`);
      }
    }

    const { [plugin]: premiumPkgImport } = premiumPackage || {};

    if (premiumPkgImport) {
      return premiumPkgImport as PluginConstructor;
    }

    // Plugin not found in either package, throw an error.
    throw new Error(`Plugin "${plugin}" not found in base or premium packages.`);
    /* v8 ignore end */
  });

  return Promise.all(loaders);
}
