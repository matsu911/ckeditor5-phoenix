import type { Editor } from 'ckeditor5';

import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';

import { EditorsRegistry } from './editors-registry';

describe('editors registry', () => {
  let registry: EditorsRegistry;

  beforeEach(() => {
    registry = EditorsRegistry.the;
  });

  afterEach(async () => {
    await registry.destroyAllEditors();
  });

  describe('register', () => {
    it('should register an editor with a given ID', () => {
      const editor = createMockEditor('editor1');

      registry.register('editor1', editor);

      expect(registry.getEditors()).toContain(editor);
    });

    it('should register the first editor as the default (null ID) editor', async () => {
      const editor1 = createMockEditor('editor1');

      registry.register('editor1', editor1);

      const promise = registry.execute(null, editor => editor);

      await expect(promise).resolves.toBe(editor1);
    });

    it('should not override the default editor if one is already set', async () => {
      const editor1 = createMockEditor('editor1');
      const editor2 = createMockEditor('editor2');

      registry.register('editor1', editor1);
      registry.register('editor2', editor2);

      const defaultEditor = await registry.execute(null, editor => editor);

      expect(defaultEditor).toBe(editor1);
      expect(defaultEditor).not.toBe(editor2);
    });

    it('should throw an error if an editor with the same ID is already registered', () => {
      const editor = createMockEditor('editor1');

      registry.register('editor1', editor);
      expect(() => registry.register('editor1', editor)).toThrow('Editor with ID "editor1" is already registered.');
    });
  });

  describe('unregister', () => {
    it('should unregister an editor', () => {
      const editor = createMockEditor('editor1');

      registry.register('editor1', editor);
      registry.unregister('editor1');
      expect(registry.getEditors()).not.toContain(editor);
    });

    it('should throw an error if trying to unregister an editor that is not registered', () => {
      expect(() => registry.unregister('nonexistent')).toThrow('Editor with ID "nonexistent" is not registered.');
    });

    it('should also unregister the default editor if the unregistered editor was the default one', async () => {
      const editor1 = createMockEditor('editor1');

      registry.register('editor1', editor1); // This also registers it as default

      // Check it is the default
      const promise = registry.execute(null, editor => editor);

      await expect(promise).resolves.toBe(editor1);

      registry.unregister('editor1');

      // Now check that the default is also gone
      expect(() => registry.unregister(null)).toThrow('Editor with ID "null" is not registered.');
    });
  });

  describe('execute', () => {
    it('should execute a function on a registered editor', async () => {
      const editor = createMockEditor('editor1');

      registry.register('editor1', editor);
      const result = await registry.execute('editor1', (e: MockEditor) => `executed on ${e.name}`);

      expect(result).toBe('executed on editor1');
    });

    it('should queue a function to be executed when the editor is registered', async () => {
      const promise = registry.execute('editor1', (e: MockEditor) => `executed on ${e.name}`);

      // It shouldn't resolve yet
      const onResolve = vi.fn();

      void promise.then(onResolve);
      await new Promise(resolve => setTimeout(resolve, 0)); // wait for promise to potentially resolve

      expect(onResolve).not.toHaveBeenCalled();

      const editor = createMockEditor('editor1');

      registry.register('editor1', editor);

      const result = await promise;

      expect(result).toBe('executed on editor1');
      expect(onResolve).toHaveBeenCalledWith('executed on editor1');
    });

    it('should execute multiple queued functions for the same editor', async () => {
      const promise1 = registry.execute('editor1', (e: MockEditor) => `executed 1 on ${e.name}`);
      const promise2 = registry.execute('editor1', (e: MockEditor) => `executed 2 on ${e.name}`);
      const editor = createMockEditor('editor1');

      registry.register('editor1', editor);

      const [result1, result2] = await Promise.all([promise1, promise2]);

      expect(result1).toBe('executed 1 on editor1');
      expect(result2).toBe('executed 2 on editor1');
    });

    it('should work with the default editor', async () => {
      const editor1 = createMockEditor('editor1');

      registry.register('editor1', editor1); // Registers as default

      const result = await registry.execute(null, (e: MockEditor) => `executed on default ${e.name}`);

      expect(result).toBe('executed on default editor1');
    });
  });

  describe('getEditors', () => {
    it('should return all registered editors', () => {
      const editor1 = createMockEditor('editor1');
      const editor2 = createMockEditor('editor2');

      registry.register('editor1', editor1);
      registry.register('editor2', editor2);

      const editors = registry.getEditors();

      expect(editors).toHaveLength(3); // editor1, editor2, and default (which is editor1)
      expect(editors).toContain(editor1);
      expect(editors).toContain(editor2);
    });

    it('should return unique editors if some point to the same instance', () => {
      const editor1 = createMockEditor('editor1');

      registry.register('editor1', editor1); // This also registers it as default

      const editors = registry.getEditors();

      expect(editors).toHaveLength(2); // editor1 and default (which is editor1)
      expect(editors.filter(e => e === editor1)).toHaveLength(2);
    });
  });

  describe('hasEditor', () => {
    it('should return true if an editor with the given ID is registered', () => {
      const editor = createMockEditor('editor1');

      registry.register('editor1', editor);

      expect(registry.hasEditor('editor1')).toBe(true);
    });

    it('should return false if an editor with the given ID is not registered', () => {
      expect(registry.hasEditor('nonexistent')).toBe(false);
    });
  });

  describe('waitForEditor', () => {
    it('should return a promise that resolves with the editor instance', async () => {
      const editor1 = createMockEditor('editor1');
      registry.register('editor1', editor1);

      const result = await registry.waitForEditor('editor1');

      expect(result).toBe(editor1);
    });

    it('should wait for the editor to be registered before resolving', async () => {
      const promise = registry.waitForEditor('editor1');
      const editor1 = createMockEditor('editor1');

      registry.register('editor1', editor1);

      expect(await promise).toBe(editor1);
    });
  });

  describe('destroyAllEditors', () => {
    it('should destroy all registered editors', async () => {
      const editor1 = createMockEditor('editor1');
      const editor2 = createMockEditor('editor2');

      registry.register('editor1', editor1);
      registry.register('editor2', editor2);

      await registry.destroyAllEditors();

      expect(registry.getEditors()).toHaveLength(0);
    });

    it('should clear the registry after destroying all editors', async () => {
      const editor1 = createMockEditor('editor1');

      registry.register('editor1', editor1);

      await registry.destroyAllEditors();

      expect(registry.getEditors()).toHaveLength(0);
    });
  });

  describe('watch/unwatch', () => {
    it('should call watcher immediately with current editors state', () => {
      const editor1 = createMockEditor('editor1');
      registry.register('editor1', editor1);

      const watcher = vi.fn();
      registry.watch(watcher);

      expect(watcher).toHaveBeenCalledOnce();
      expect(watcher).toHaveBeenCalledWith(expect.any(Map));

      const callArgs = watcher.mock.calls[0]![0] as Map<string | null, any>;
      expect(callArgs.get('editor1')).toBe(editor1);
      expect(callArgs.get(null)).toBe(editor1); // default editor
    });

    it('should call watcher when editor is registered', () => {
      const watcher = vi.fn();
      registry.watch(watcher);

      expect(watcher).toHaveBeenCalledTimes(1); // Initial call

      const editor1 = createMockEditor('editor1');
      registry.register('editor1', editor1);

      expect(watcher).toHaveBeenCalledTimes(3); // Initial + register + default register
    });

    it('should call watcher when editor is unregistered', () => {
      const editor1 = createMockEditor('editor1');
      registry.register('editor1', editor1);

      const watcher = vi.fn();
      registry.watch(watcher);

      watcher.mockClear(); // Clear initial call

      registry.unregister('editor1');

      expect(watcher).toHaveBeenCalledTimes(2); // Unregister + default unregister
    });

    it('should call watcher when all editors are destroyed', async () => {
      const editor1 = createMockEditor('editor1');
      const editor2 = createMockEditor('editor2');
      registry.register('editor1', editor1);
      registry.register('editor2', editor2);

      const watcher = vi.fn();
      registry.watch(watcher);

      watcher.mockClear(); // Clear initial call

      await registry.destroyAllEditors();

      expect(watcher).toHaveBeenCalledOnce();

      const callArgs = watcher.mock.calls[0]![0] as Map<string | null, any>;
      expect(callArgs.size).toBe(0);
    });

    it('should allow multiple watchers', () => {
      const watcher1 = vi.fn();
      const watcher2 = vi.fn();

      registry.watch(watcher1);
      registry.watch(watcher2);

      const editor1 = createMockEditor('editor1');
      registry.register('editor1', editor1);

      expect(watcher1).toHaveBeenCalled();
      expect(watcher2).toHaveBeenCalled();
    });

    it('should provide a copy of editors map to watchers', () => {
      const editor1 = createMockEditor('editor1');
      registry.register('editor1', editor1);

      const watcher = vi.fn();
      registry.watch(watcher);

      const receivedMap = watcher.mock.calls[0]![0] as Map<string | null, any>;

      // Modifying the received map should not affect the internal state
      receivedMap.clear();

      expect(registry.getEditors()).toHaveLength(2); // Still has editor1 and default
    });

    it('should stop calling watcher after unwatch', () => {
      const watcher = vi.fn();
      registry.watch(watcher);

      registry.unwatch(watcher);
      watcher.mockClear();

      const editor1 = createMockEditor('editor1');
      registry.register('editor1', editor1);

      expect(watcher).not.toHaveBeenCalled();
    });

    it('should return unwatch function from watch', () => {
      const watcher = vi.fn();
      const unwatch = registry.watch(watcher);

      unwatch();
      watcher.mockClear();

      const editor1 = createMockEditor('editor1');
      registry.register('editor1', editor1);

      expect(watcher).not.toHaveBeenCalled();
    });

    it('should handle unwatching non-existent watcher gracefully', () => {
      const watcher = vi.fn();

      expect(() => registry.unwatch(watcher)).not.toThrow();
    });
  });
});

type MockEditor = Editor & {
  name: string;
};

function createMockEditor(name: string): MockEditor {
  return {
    name,
    destroy: () => {},
  } as unknown as MockEditor;
}
