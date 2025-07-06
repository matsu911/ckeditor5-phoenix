import type { Editor } from 'ckeditor5';

import {
  createQueuedTask,
  createQueueRef,
  debounce,
  mapObjectValues,
  once,
  parseIntIfNotNull,
} from 'shared';

import type { EditorType } from './typings';

import { ClassHook } from '../../shared/hook';
import {
  isSingleEditingLikeEditor,
  loadEditorConstructor,
  loadEditorPlugins,
  queryAllEditorEditables,
  readPresetOrThrow,
  setEditorEditableHeight,
} from './utils';

/**
 * Editor hook for Phoenix LiveView.
 *
 * This class is a hook that can be used with Phoenix LiveView to integrate
 * the CKEditor 5 WYSIWYG editor.
 */
export class EditorHook extends ClassHook {
  private lockQueueRef = createQueueRef<Editor>();

  private getPreset = once(() => readPresetOrThrow(this.el));

  private getEditorId = once(() => {
    const id = this.el.getAttribute('id');

    if (!id) {
      throw new Error('Editor hook requires an element with an "id" attribute.');
    }

    return id;
  });

  override async mounted() {
    await this.createEditor();
  }

  /**
   * Creates the CKEditor instance. The queue is used to ensure that only one editor instance
   * is created at a time, even if the `mounted` method is called multiple times. The editor might
   * be unstable if multiple instances of the editor are created simultaneously using the same element.
   */
  private createEditor = createQueuedTask(async () => {
    const preset = this.getPreset();
    const editorId = this.getEditorId();

    const { type, license, config: { plugins, ...config } } = preset;

    const Constructor = await loadEditorConstructor(type);
    const rootEditables = getInitialRootsContentElements(editorId, type);

    if (!rootEditables) {
      throw new Error(
        `No root elements found for editor type: ${type}.`
        + ' Ensure the element has the correct ID and editable attributes.',
      );
    }

    const editor = await Constructor.create(
      rootEditables as any,
      {
        ...config,
        initialData: getInitialRootsValues(editorId, type),
        licenseKey: license.key,
        plugins: await loadEditorPlugins(plugins),
      },
    );

    if (isSingleEditingLikeEditor(type)) {
      applyEditorHeight(this.el, editor);
      syncEditorToInput(editorId, editor);
    }

    return editor;
  }, this.lockQueueRef);
}

/**
 * Applies the editor height from the element's attribute to the editor's editable area.
 *
 * @param element The hook's HTML element.
 * @param editor The CKEditor instance.
 */
function applyEditorHeight(element: HTMLElement, editor: Editor) {
  const editableHeight = parseIntIfNotNull(element.getAttribute('cke-editable-height'));

  if (editableHeight) {
    setEditorEditableHeight(editor, editableHeight);
  }
}

/**
 * Synchronizes the editor's content with a hidden input field.
 *
 * @param editorId The editor's ID.
 * @param editor The CKEditor instance.
 */
function syncEditorToInput(editorId: string, editor: Editor) {
  const inputElement = document.getElementById(`${editorId}_input`) as HTMLInputElement | null;

  if (inputElement) {
    const debouncedSync = debounce(100, () => {
      inputElement.value = editor.getData();
    });

    editor.model.document.on('change:data', debouncedSync);
  }
}

/**
 * Gets the initial root elements for the editor based on its type.
 *
 * @param editorId The editor's ID.
 * @param type The type of the editor.
 * @returns The root element(s) for the editor.
 */
function getInitialRootsContentElements(editorId: string, type: EditorType) {
  if (isSingleEditingLikeEditor(type)) {
    return document.getElementById(`${editorId}_editor`);
  }

  const editables = queryAllEditorEditables(editorId);

  return mapObjectValues(editables, ({ content }) => content);
}

/**
 * Gets the initial data for the roots of the editor. If the editor is a single editing-like editor,
 * it retrieves the initial value from the element's attribute. Otherwise, it returns an object mapping
 * editable names to their initial values.
 *
 * @param editorId The editor's ID.
 * @param type The type of the editor.
 * @returns The initial values for the editor's roots.
 */
function getInitialRootsValues(editorId: string, type: EditorType) {
  if (isSingleEditingLikeEditor(type)) {
    return document.getElementById(editorId)!.getAttribute('cke-initial-value') || '';
  }

  const editables = queryAllEditorEditables(editorId);

  return mapObjectValues(editables, ({ initialValue }) => initialValue);
}
