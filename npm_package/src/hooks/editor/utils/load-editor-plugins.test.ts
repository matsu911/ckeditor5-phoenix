import { afterEach, describe, expect, it, vi } from 'vitest';

import type { EditorPlugin } from '../typings';

import { registerCustomEditorPlugin, unregisterAllCustomEditorPlugins } from '../custom-editor-plugins';
import { loadEditorPlugins } from './load-editor-plugins';

class CustomPlugin {
  static get pluginName() {
    return 'CustomPlugin';
  }
}

vi.mock('ckeditor5', () => ({
  Plugin1: vi.fn(),
  Plugin2: vi.fn(),
  BasePlugin: vi.fn(),
}));

describe('loadEditorPlugins', () => {
  it('should load plugins from base package', async () => {
    const plugins: EditorPlugin[] = ['Plugin1', 'Plugin2'];
    const { loadedPlugins } = await loadEditorPlugins(plugins);

    expect(loadedPlugins).toHaveLength(2);
    expect(loadedPlugins[0]).toBeDefined();
    expect(loadedPlugins[1]).toBeDefined();
  });

  it('should handle empty plugin array', async () => {
    const plugins: EditorPlugin[] = [];
    const { loadedPlugins } = await loadEditorPlugins(plugins);

    expect(loadedPlugins).toHaveLength(0);
  });

  it('should prioritize base package over premium package', async () => {
    const plugins: EditorPlugin[] = ['Plugin1'];
    const { loadedPlugins } = await loadEditorPlugins(plugins);

    expect(loadedPlugins).toHaveLength(1);
    expect(loadedPlugins[0]).toBeDefined();
  });

  it('should return plugin constructors', async () => {
    const plugins: EditorPlugin[] = ['Plugin1'];
    const { loadedPlugins } = await loadEditorPlugins(plugins);

    expect(loadedPlugins).toHaveLength(1);
    expect(typeof loadedPlugins[0]).toBe('function');
  });

  describe('custom plugins', () => {
    afterEach(() => {
      unregisterAllCustomEditorPlugins();
    });

    it('should load custom plugins', async () => {
      registerCustomEditorPlugin('CustomPlugin', () => CustomPlugin);

      const plugins: EditorPlugin[] = ['CustomPlugin'];
      const { loadedPlugins } = await loadEditorPlugins(plugins);

      expect(loadedPlugins).toHaveLength(1);
      expect(loadedPlugins[0]).toEqual(CustomPlugin);
    });

    it('should prefer loading custom plugins over base package', async () => {
      registerCustomEditorPlugin('Plugin1', () => CustomPlugin);

      const plugins: EditorPlugin[] = ['Plugin1'];
      const { loadedPlugins } = await loadEditorPlugins(plugins);

      expect(loadedPlugins).toHaveLength(1);
      expect(loadedPlugins[0]).toEqual(CustomPlugin);
    });

    it('should be possible to load async custom plugins', async () => {
      registerCustomEditorPlugin('AsyncPlugin', async () => {
        return new Promise((resolve) => {
          setTimeout(() => resolve(CustomPlugin), 20);
        });
      });

      const plugins: EditorPlugin[] = ['AsyncPlugin'];
      const { loadedPlugins } = await loadEditorPlugins(plugins);

      expect(loadedPlugins).toHaveLength(1);
      expect(loadedPlugins[0]).toEqual(CustomPlugin);
    });
  });
});
