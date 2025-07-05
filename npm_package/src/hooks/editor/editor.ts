import { debounce, parseIntIfNotNull } from 'shared';

import { ClassHook } from '../../shared/hook';
import {
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
  get id() {
    return this.el.getAttribute('id');
  }

  override async mounted() {
    const { type, license, config: { plugins, ...config } } = readPresetOrThrow(this.el);

    const elements = {
      editor: document.getElementById(`${this.id}_editor`),
      input: document.getElementById(`${this.id}_input`) as HTMLInputElement | null,
    };

    const Editor = await loadEditorConstructor(type);
    const editor = await Editor.create(
      elements.editor as any,
      {
        ...config,
        initialData: this.el.getAttribute('cke-initial-value') || '',
        licenseKey: license.key,
        plugins: await loadEditorPlugins(plugins),
      },
    );

    // Apply editor height if specified.
    const editableHeight = parseIntIfNotNull(this.el.getAttribute('cke-editable-height'));

    if (editableHeight) {
      setEditorEditableHeight(editor, editableHeight);
    }

    // Sync input value if present
    if (elements.input) {
      const debouncedSync = debounce(100, () => {
        elements.input!.value = editor.getData();
      });

      editor.model.document.on('change:data', debouncedSync);
    }
  }
}
