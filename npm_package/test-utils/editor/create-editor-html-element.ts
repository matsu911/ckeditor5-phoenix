import type { EditorPreset } from '../../src/hooks/editor/typings';

import { html } from '../html';
import { createEditorPreset } from './create-editor-preset';

/**
 * Creates a CKEditor HTML structure for testing.
 */
export function createEditorHtmlElement(
  {
    id = 'test-editor',
    preset = createEditorPreset(),
    initialValue = '<p>Test content</p>',
    editableHeight = null,
    withInput = false,
    pushEvents = false,
    hookAttrs,
  }: {
    id?: string;
    preset?: EditorPreset;
    initialValue?: string | null;
    editableHeight?: number | null;
    withInput?: boolean;
    pushEvents?: boolean;
    hookAttrs?: Record<string, string>;
  } = {},
) {
  return html.div(
    {
      id,
      'phx-hook': 'CKEditor5',
      'phx-update': 'ignore',
      'cke-preset': JSON.stringify(preset),
      ...(pushEvents && {
        'cke-push-events': '',
      }),
      ...initialValue && {
        'cke-initial-value': initialValue,
      },
      ...editableHeight && {
        'cke-editable-height': editableHeight,
      },
      ...hookAttrs,
    },
    html.div({ id: `${id}_editor` }),
    withInput && html.input({
      type: 'hidden',
      id: `${id}_input`,
      name: 'content',
    }),
  );
}
