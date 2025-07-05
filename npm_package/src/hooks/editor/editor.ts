import type { EditorHookConfig } from './config';

import { ClassHook } from '../../shared/hook';
import { readHookConfigOrThrow } from './config';
import { loadEditorPlugins } from './utils';
import { loadEditorConstructor } from './utils/load-editor-constructor';

/**
 * Editor hook for Phoenix LiveView.
 *
 * This class is a hook that can be used with Phoenix LiveView to integrate
 * the CKEditor 5 WYSIWYG editor.
 */
export class Editor extends ClassHook {
  private hookConfig: EditorHookConfig | null = null;

  override async mounted() {
    this.hookConfig = readHookConfigOrThrow(this.el);

    const Editor = await loadEditorConstructor(this.hookConfig.type);
    const { license, config: { plugins, ...config } } = this.hookConfig;

    Editor.create(this.el as any, {
      ...config,
      licenseKey: license.key,
      plugins: await loadEditorPlugins(plugins),
    });
  }
}
