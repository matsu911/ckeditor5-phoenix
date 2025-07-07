import type { MultiRootEditor } from 'ckeditor5';

import { EditorsRegistry } from 'hooks/editor/editors-registry';
import { ClassHook } from 'shared';

/**
 * Editable hook for Phoenix LiveView. It allows you to create editables for multi-root editors.
 */
export class EditableHook extends ClassHook {
  /**
   * The name of the hook.
   */
  private mountedPromise: Promise<void> | null = null;

  /**
   * Attributes for the editable instance.
   */
  private get attrs() {
    const value = {
      editorId: this.el.getAttribute('data-cke-editor-id') || null,
      name: this.el.getAttribute('data-cke-editable-name')!,
      initialValue: this.el.getAttribute('data-cke-editable-initial-value') || '',
    };

    Object.defineProperty(this, 'attrs', {
      value,
      writable: false,
      configurable: false,
      enumerable: true,
    });

    return value;
  }

  /**
   * Mounts the editable component.
   */
  override async mounted() {
    const { editorId, name, initialValue } = this.attrs;

    // If the editor is not registered yet, we will wait for it to be registered.
    this.mountedPromise = EditorsRegistry.the.execute(editorId, (editor: MultiRootEditor) => {
      const { ui, editing, model } = editor;

      if (model.document.getRoot(name)) {
        return;
      }

      editor.addRoot(name, {
        isUndoable: false,
        data: initialValue,
      });

      const root = model.document.getRoot(name);

      if (root && ui.getEditableElement(name)) {
        editor.detachEditable(root);
      }

      const editable = ui.view.createEditable(name, this.el);

      ui.addEditable(editable);
      editing.view.forceRender();
    });
  }

  /**
   * Destroys the editable component. Unmounts root from the editor.
   */
  override async destroyed() {
    const { editorId, name } = this.attrs;

    // Let's wait for the mounted promise to resolve before proceeding with destruction.
    await this.mountedPromise;
    this.mountedPromise = null;

    // Unmount root from the editor.
    await EditorsRegistry.the.execute(editorId, (editor: MultiRootEditor) => {
      const root = editor.model.document.getRoot(name);

      if (root) {
        editor.detachEditable(root);
        editor.detachRoot(name, true);
      }
    });
  }
}
