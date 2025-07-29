import { describe, expect, it, vi } from 'vitest';

import type { EditorPlugin } from '../typings';

import { loadEditorPlugins } from './load-editor-plugins';

// Mock the ckeditor5 package
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
});
