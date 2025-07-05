import { debounce, parseIntIfNotNull } from 'shared';

import { ClassHook } from '../../shared/hook';
import {
  isSingleEditingLikeEditor,
  loadEditorConstructor,
  loadEditorPlugins,
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
  override async mounted() {
    const { type, license, config: { plugins, ...config } } = readPresetOrThrow(this.el);

    const id = this.el.getAttribute('id');
    const editorElement = document.getElementById(`${id}_editor`);

    const Editor = await loadEditorConstructor(type);
    const editor = await Editor.create(
      editorElement as any,
      {
        ...config,
        initialData: this.el.getAttribute('cke-initial-value') || '',
        licenseKey: license.key,
        plugins: await loadEditorPlugins(plugins),
      },
    );

    // Apply some attributes related to the editor types with single editing text area.
    if (isSingleEditingLikeEditor(type)) {
      // Apply editor height if specified.
      const editableHeight = parseIntIfNotNull(this.el.getAttribute('cke-editable-height'));

      if (editableHeight) {
        setEditorEditableHeight(editor, editableHeight);
      }

      // Sync input value if present
      const inputElement = document.getElementById(`${id}_input`) as HTMLInputElement | null;

      if (inputElement) {
        const debouncedSync = debounce(100, () => {
          inputElement.value = editor.getData();
        });

        editor.model.document.on('change:data', debouncedSync);
      }
    }
  }
}
