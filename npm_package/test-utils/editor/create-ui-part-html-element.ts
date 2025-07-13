import { html } from '../html';

export function createUIPartHtmlElement(
  {
    name,
  }: {
    name?: string;
  } = {},
): HTMLElement {
  return html.div(
    {
      'data-cke-ui-part-name': name,
    },
  );
}
