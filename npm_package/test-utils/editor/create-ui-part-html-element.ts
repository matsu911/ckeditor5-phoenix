import type { EditorId } from '../../src/hooks/editor/typings';

import { html } from '../html';

export function createUIPartHtmlElement(
  {
    name,
    editorId,
  }: {
    name?: string;
    editorId?: EditorId;
  } = {},
): HTMLElement {
  return html.div(
    {
      'data-cke-ui-part-name': name,
      ...editorId && {
        'data-cke-editor-id': editorId,
      },
    },
  );
}
