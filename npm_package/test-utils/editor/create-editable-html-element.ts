import { html } from '../html';

/**
 * Creates a editable element with the given name and initial value.
 */
export function createEditableHtmlElement(
  {
    name = 'main',
    id = `${name}-editable`,
    initialValue,
    withInput = false,
  }: {
    id?: string;
    name?: string;
    initialValue?: string;
    withInput?: boolean;
  } = {},
) {
  return html.div(
    {
      'id': id,
      'data-cke-editable-root-name': name,
      ...initialValue && {
        'data-cke-editable-initial-value': initialValue,
      },
    },
    html.div({
      'class': 'editable-content',
      'data-cke-editable-content': '',
    }),
    withInput && html.input({
      type: 'hidden',
      id: `${id}_input`,
      name: 'content',
    }),
  );
}
