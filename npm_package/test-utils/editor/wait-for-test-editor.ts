import type { Editor } from 'ckeditor5';

import { EditorsRegistry } from '../../src/hooks/editor/editors-registry';

/**
 * Waits for the test editor to be registered in the EditorsRegistry.
 */
export function waitForTestEditor(): Promise<Editor> {
  return EditorsRegistry.the.waitForEditor('test-editor');
}
