import { parseIntIfNotNull } from 'shared';

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
  override async mounted() {
    const { type, license, config: { plugins, ...config } } = readPresetOrThrow(this.el);

    const Editor = await loadEditorConstructor(type);

    const editor = await Editor.create(this.el as any, {
      ...config,
      licenseKey: license.key,
      plugins: await loadEditorPlugins(plugins),
    });

    const editableHeight = parseIntIfNotNull(this.el.getAttribute('cke-editable-height'));

    if (editableHeight) {
      setEditorEditableHeight(editor, editableHeight);
    }
  }
}
