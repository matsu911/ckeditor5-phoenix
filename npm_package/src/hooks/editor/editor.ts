import type { Editor } from 'ckeditor5';

import type { EditorId, EditorType } from './typings';

import {
  debounce,
  mapObjectValues,
  parseIntIfNotNull,
} from '../../shared';
import { ClassHook, makeHook } from '../../shared/hook';
import { EditorsRegistry } from './editors-registry';
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
class EditorHookImpl extends ClassHook {
  /**
   * The name of the hook.
   */
  private editorPromise: Promise<Editor> | null = null;

  /**
   * Attributes for the editor instance.
   */
  private get attrs() {
    const value = {
      editorId: this.el.getAttribute('id')!,
      preset: readPresetOrThrow(this.el),
      editableHeight: parseIntIfNotNull(this.el.getAttribute('cke-editable-height')),
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
   * Mounts the editor component.
   */
  override async mounted() {
    this.editorPromise = this.createEditor();

    EditorsRegistry.the.register(this.attrs.editorId, await this.editorPromise);

    return this;
  }

  /**
   * Destroys the editor instance when the component is destroyed.
   * This is important to prevent memory leaks and ensure that the editor is properly cleaned up.
   */
  override async destroyed() {
    // Let's hide the element during destruction to prevent flickering.
    this.el.style.display = 'none';

    // Let's wait for the mounted promise to resolve before proceeding with destruction.
    (await this.editorPromise)?.destroy();
    this.editorPromise = null;

    EditorsRegistry.the.unregister(this.attrs.editorId);
  }

  /**
   * Creates the CKEditor instance.
   */
  private async createEditor() {
    const { preset, editorId, editableHeight } = this.attrs;
    const { type, license, config: { plugins, ...config } } = preset;

    const Constructor = await loadEditorConstructor(type);
    const rootEditables = getInitialRootsContentElements(editorId, type);

    const editor = await Constructor.create(
      rootEditables as any,
      {
        ...config,
        initialData: getInitialRootsValues(editorId, type),
        licenseKey: license.key,
        plugins: await loadEditorPlugins(plugins),
      },
    );

    this.setupContentSync(editorId, editor);

    if (isSingleEditingLikeEditor(type)) {
      const input = document.getElementById(`${editorId}_input`) as HTMLInputElement | null;

      if (input) {
        syncEditorToInput(input, editor);
      }

      if (editableHeight) {
        setEditorEditableHeight(editor, editableHeight);
      }
    }

    return editor;
  };

  /**
   * Sets up the content synchronization for the editor.
   */
  private setupContentSync(editorId: EditorId, editor: Editor) {
    const pushContentChange = () => {
      this.pushEvent(
        'ckeditor5:change',
        {
          editorId,
          data: getEditorRootsValues(editor),
        },
      );
    };

    // Send content changes to the server.
    editor.model.document.on('change:data', debounce(250, pushContentChange));
    pushContentChange();

    // Handle incoming data from the server.
    this.handleEvent('ckeditor5:set-data', ({ data }) => {
      editor.setData(data);
    });
  }
}

/**
 * Gets the values of the editor's roots.
 *
 * @param editor The CKEditor instance.
 * @returns An object mapping root names to their content.
 */
function getEditorRootsValues(editor: Editor) {
  const roots = editor.model.document.getRootNames();

  return roots.reduce<Record<string, string>>((acc, rootName) => {
    acc[rootName] = editor.getData({ rootName });
    return acc;
  }, Object.create({}));
}

/**
 * Synchronizes the editor's content with a hidden input field.
 *
 * @param input The input element to synchronize with the editor.
 * @param editor The CKEditor instance.
 */
function syncEditorToInput(input: HTMLInputElement, editor: Editor) {
  const sync = () => {
    input.value = editor.getData();
  };

  editor.model.document.on('change:data', debounce(250, sync));
  sync();
}

/**
 * Gets the initial root elements for the editor based on its type.
 *
 * @param editorId The editor's ID.
 * @param type The type of the editor.
 * @returns The root element(s) for the editor.
 */
function getInitialRootsContentElements(editorId: EditorId, type: EditorType) {
  if (isSingleEditingLikeEditor(type)) {
    return document.getElementById(`${editorId}_editor`)!;
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
function getInitialRootsValues(editorId: EditorId, type: EditorType) {
  // If the editor is decoupled, the initial value might be specified in the `main` editable.
  if (type === 'decoupled') {
    const mainEditableValue = queryAllEditorEditables(editorId)['main']?.initialValue;

    if (mainEditableValue) {
      return mainEditableValue;
    }
  }

  // Let's check initial value assigned to the editor element.
  if (isSingleEditingLikeEditor(type)) {
    const initialValue = document.getElementById(editorId)?.getAttribute('cke-initial-value') || '';

    return initialValue;
  }

  const editables = queryAllEditorEditables(editorId);

  return mapObjectValues(editables, ({ initialValue }) => initialValue);
}

/**
 * Phoenix LiveView hook for CKEditor 5.
 */
export const EditorHook = makeHook(EditorHookImpl);
