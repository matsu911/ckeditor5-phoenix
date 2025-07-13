import type { Editor } from 'ckeditor5';

import type { EditorId } from './typings';

/**
 * Allows other hooks to communicate with specific editors.
 * It provides a way to register editors and execute callbacks on them when they are available.
 */
export class EditorsRegistry {
  static readonly the = new EditorsRegistry();

  /**
   * Map of registered editors.
   */
  private readonly editors = new Map<EditorId | null, Editor>();

  /**
   * Map of callbacks that are waiting for an editor to be registered.
   */
  private readonly callbacks = new Map<EditorId | null, EditorCallback<any>[]>();

  /**
   * Private constructor to enforce singleton pattern.
   */
  private constructor() {}

  /**
   * Executes a function on an editor.
   * If the editor is not yet registered, it will wait for it to be registered.
   *
   * @param editorId The ID of the editor.
   * @param fn The function to execute.
   * @returns A promise that resolves with the result of the function.
   */
  execute<T, E extends Editor = Editor>(editorId: EditorId | null, fn: (editor: E) => T): Promise<Awaited<T>> {
    const { callbacks, editors } = this;
    const editor = editors.get(editorId);

    if (editor) {
      return Promise.resolve(fn(editor as E));
    }

    return new Promise((resolve) => {
      const callback = async (editor: E) => resolve(await fn(editor));

      if (!this.callbacks.has(editorId)) {
        callbacks.set(editorId, []);
      }

      callbacks.set(editorId, [
        ...callbacks.get(editorId)!,
        callback,
      ]);
    });
  }

  /**
   * Registers an editor.
   *
   * @param editorId The ID of the editor.
   * @param editor The editor instance.
   */
  register(editorId: EditorId | null, editor: Editor): void {
    const { editors, callbacks } = this;
    const callbacksForEditor = callbacks.get(editorId);

    if (editors.has(editorId)) {
      throw new Error(`Editor with ID "${editorId}" is already registered.`);
    }

    editors.set(editorId, editor);

    if (callbacksForEditor) {
      callbacksForEditor.forEach(callback => callback(editor));
      callbacks.delete(editorId);
    }

    // Register the first editor as the default editor.
    // This is useful for editables that do not specify an editor ID.
    if (this.editors.size === 1) {
      this.register(null, editor);
    }
  }

  /**
   * Un-registers an editor.
   *
   * @param editorId The ID of the editor.
   */
  unregister(editorId: EditorId | null): void {
    const { editors, callbacks } = this;

    if (!editors.has(editorId)) {
      throw new Error(`Editor with ID "${editorId}" is not registered.`);
    }

    if (editorId && this.editors.get(null) === editors.get(editorId)) {
      this.unregister(null);
    }

    editors.delete(editorId);
    callbacks.delete(editorId);
  }

  /**
   * Gets all registered editors.
   */
  getEditors(): Editor[] {
    return Array.from(this.editors.values());
  }

  /**
   * Checks if an editor with the given ID is registered.
   *
   * @param editorId The ID of the editor.
   * @returns `true` if the editor is registered, `false` otherwise.
   */
  hasEditor(editorId: EditorId | null): boolean {
    return this.editors.has(editorId);
  }

  /**
   * Gets a promise that resolves with the editor instance for the given ID.
   * If the editor is not registered yet, it will wait for it to be registered.
   *
   * @param editorId The ID of the editor.
   * @returns A promise that resolves with the editor instance.
   */
  waitForEditor(editorId: EditorId | null): Promise<Editor> {
    return this.execute(editorId, editor => editor);
  }

  /**
   * Destroys all registered editors and clears the registry.
   * This will call the `destroy` method on each editor.
   */
  async destroyAllEditors() {
    const promises = (
      Array
        .from(this.editors.values())
        .map(editor => editor.destroy())
    );

    this.editors.clear();
    this.callbacks.clear();

    await Promise.all(promises);
  }
}

/**
 * Callback type for editor operations.
 */
type EditorCallback<E extends Editor = Editor> = (editor: E) => void;
