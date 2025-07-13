import { html } from '../html';

/**
 * Creates a editable element with the given name and initial value.
 */
export function createEditableElement(name: string = 'main', initialValue?: string) {
  return html.div(
    {
      'data-cke-editable-root-name': name,
      ...initialValue && {
        'data-cke-editable-initial-value': initialValue,
      },
    },
    html.div({
      'class': 'editable-content',
      'data-cke-editable-content': '',
    }),
  );
}
