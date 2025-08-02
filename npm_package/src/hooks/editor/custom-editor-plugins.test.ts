import { Plugin } from 'ckeditor5';
import { afterEach, describe, expect, it } from 'vitest';

import { getCustomEditorPlugin, registerCustomEditorPlugin, unregisterAllCustomEditorPlugins, unregisterCustomEditorPlugin } from './custom-editor-plugins';

class MockPlugin1 extends Plugin {
  static get pluginName() {
    return 'MockPlugin1';
  }
}

class MockPlugin2 extends Plugin {
  static get pluginName() {
    return 'MockPlugin2';
  }
}

describe('custom-editor-plugins', () => {
  afterEach(unregisterAllCustomEditorPlugins);

  describe('registerCustomEditorPlugin', () => {
    it('should register a plugin successfully', async () => {
      const unregister = registerCustomEditorPlugin('test-plugin', () => MockPlugin1);

      expect(await getCustomEditorPlugin('test-plugin')).toBe(MockPlugin1);
      expect(typeof unregister).toBe('function');
    });

    it('should throw an error when registering a plugin with the same name', () => {
      registerCustomEditorPlugin('duplicate-plugin', () => MockPlugin1);

      expect(() => {
        registerCustomEditorPlugin('duplicate-plugin', () => MockPlugin2);
      }).toThrow('Plugin with name "duplicate-plugin" is already registered.');
    });

    it('should return an unregister function that removes the plugin', async () => {
      const unregister = registerCustomEditorPlugin('removable-plugin', () => MockPlugin1);

      expect(await getCustomEditorPlugin('removable-plugin')).toBe(MockPlugin1);

      unregister();

      expect(await getCustomEditorPlugin('removable-plugin')).toBeUndefined();
    });
  });

  describe('unregisterCustomEditorPlugin', () => {
    it('should unregister an existing plugin', async () => {
      registerCustomEditorPlugin('temp-plugin', () => MockPlugin1);

      expect(await getCustomEditorPlugin('temp-plugin')).toBe(MockPlugin1);

      unregisterCustomEditorPlugin('temp-plugin');

      expect(await getCustomEditorPlugin('temp-plugin')).toBeUndefined();
    });

    it('should throw an error when unregistering a non-existent plugin', () => {
      expect(() => {
        unregisterCustomEditorPlugin('non-existent');
      }).toThrow('Plugin with name "non-existent" is not registered.');
    });
  });

  describe('unregisterAllCustomEditorPlugins', () => {
    it('should clear all registered plugins', async () => {
      registerCustomEditorPlugin('plugin-1', () => MockPlugin1);
      registerCustomEditorPlugin('plugin-2', () => MockPlugin2);

      expect(await getCustomEditorPlugin('plugin-1')).toBe(MockPlugin1);
      expect(await getCustomEditorPlugin('plugin-2')).toBe(MockPlugin2);

      unregisterAllCustomEditorPlugins();

      expect(await getCustomEditorPlugin('plugin-1')).toBeUndefined();
      expect(await getCustomEditorPlugin('plugin-2')).toBeUndefined();
    });
  });

  describe('getCustomEditorPlugin', () => {
    it('should return the correct plugin when it exists', async () => {
      registerCustomEditorPlugin('existing-plugin', () => MockPlugin1);

      expect(await getCustomEditorPlugin('existing-plugin')).toBe(MockPlugin1);
    });

    it('should return undefined for non-existent plugins', async () => {
      expect(await getCustomEditorPlugin('non-existent-plugin')).toBeUndefined();
    });

    it('should distinguish between different plugins', async () => {
      registerCustomEditorPlugin('plugin-1', () => MockPlugin1);
      registerCustomEditorPlugin('plugin-2', () => MockPlugin2);

      expect(await getCustomEditorPlugin('plugin-1')).toBe(MockPlugin1);
      expect(await getCustomEditorPlugin('plugin-2')).toBe(MockPlugin2);
    });

    it('should always return the same reference for the same plugin', async () => {
      registerCustomEditorPlugin('consistent-plugin', () => MockPlugin1);

      const plugin1 = await getCustomEditorPlugin('consistent-plugin');
      const plugin2 = await getCustomEditorPlugin('consistent-plugin');

      expect(plugin1).toBe(plugin2);
      expect(plugin1).toBe(MockPlugin1);
    });
  });

  describe('integration tests', () => {
    it('should handle multiple plugins registration and unregistration', async () => {
      registerCustomEditorPlugin('multi-1', () => MockPlugin1);
      registerCustomEditorPlugin('multi-2', () => MockPlugin2);

      expect(await getCustomEditorPlugin('multi-1')).toBe(MockPlugin1);
      expect(await getCustomEditorPlugin('multi-2')).toBe(MockPlugin2);

      unregisterCustomEditorPlugin('multi-1');

      expect(await getCustomEditorPlugin('multi-1')).toBeUndefined();
      expect(await getCustomEditorPlugin('multi-2')).toBe(MockPlugin2);
    });

    it('should allow re-registration after unregistration', async () => {
      registerCustomEditorPlugin('reusable-name', () => MockPlugin1);
      expect(await getCustomEditorPlugin('reusable-name')).toBe(MockPlugin1);

      unregisterCustomEditorPlugin('reusable-name');
      expect(await getCustomEditorPlugin('reusable-name')).toBeUndefined();

      registerCustomEditorPlugin('reusable-name', () => MockPlugin2);
      expect(await getCustomEditorPlugin('reusable-name')).toBe(MockPlugin2);
    });
  });
});
