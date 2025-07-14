import type { Editor } from 'ckeditor5';

import type { EditorId } from '../../src/hooks/editor/typings';

import { EditorsRegistry } from '../../src/hooks/editor/editors-registry';

/**
 * Waits for the test editor to be registered in the EditorsRegistry.
 */
export function waitForTestEditor<E extends Editor>(id: EditorId = 'test-editor'): Promise<E> {
  return EditorsRegistry.the.waitForEditor<E>(id);
}
