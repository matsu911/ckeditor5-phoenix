import { ClassHook, makeHook } from '../../shared';

/**
 * Context hook for Phoenix LiveView. It allows you to create contexts for collaboration editors.
 */
class ContextHookImpl extends ClassHook {
  /**
   * Attributes for the context instance.
   */
  private get attrs() {
    const value = {
      editableId: this.el.getAttribute('id')!,
      editorId: this.el.getAttribute('data-cke-editor-id') || null,
      rootName: this.el.getAttribute('data-cke-editable-root-name')!,
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
   * Mounts the context component.
   */
  override async mounted() {
  }

  /**
   * Destroys the context component. Unmounts root from the editor.
   */
  override async destroyed() {
    // Let's hide the element during destruction to prevent flickering.
    this.el.style.display = 'none';
  }
}

/**
 * Phoenix LiveView hook for CKEditor 5 context elements.
 */
export const ContextHook = makeHook(ContextHookImpl);
