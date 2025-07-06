/**
 * Queries all editable elements within a specific editor instance.
 *
 * @param editorId The ID of the editor to query.
 * @returns An object mapping editable names to their corresponding elements and initial values.
 */
export function queryAllEditorEditables(editorId: string) {
  const iterator = document.querySelectorAll<HTMLElement>(
    [
      `[data-cke-editor-id="${editorId}"][data-cke-editable-name]`,
      '[data-cke-editable-name]:not([data-cke-editor-id])',
    ].join(', '),
  );

  return (
    Array
      .from(iterator)
      .reduce<Record<string, EditableItem>>((acc, element) => {
        const name = element.getAttribute('data-cke-editable-name');
        const initialValue = element.getAttribute('data-cke-editable-initial-value') || '';

        if (!name) {
          return acc;
        }

        return {
          ...acc,
          [name]: {
            element,
            initialValue,
          },
        };
      }, Object.create({}))
  );
}

/**
 * Type representing an editable item within an editor.
 */
export type EditableItem = {
  element: HTMLElement;
  initialValue: string;
};
