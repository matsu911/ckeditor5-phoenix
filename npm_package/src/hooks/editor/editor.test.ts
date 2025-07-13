import type { Editor } from 'ckeditor5';

import { ClassicEditor } from 'ckeditor5';
import { describe, it } from 'vitest';

import { html } from '~/test-utils';

import type { EditorConfig, EditorType } from './typings';

import { EditorHook } from './editor';
import { EditorsRegistry } from './editors-registry';

describe('editor hook', () => {
  beforeEach(() => {
    document.body.innerHTML = '';
  });

  afterEach(async () => {
    await EditorsRegistry.the.destroyAllEditors();
  });

  it('should create a classic editor with default preset', async () => {
    const hookElement = createClassicEditorHtmlElement();

    document.body.appendChild(hookElement);
    EditorHook.mounted.call({ el: hookElement });

    const editor = await waitForTestEditor();

    expect(editor).to.toBeInstanceOf(ClassicEditor);
    expect(isEditorShown()).toBe(true);
  });

  it('should assign default value to the editor using "cke-initial-value" attribute', async () => {
    const initialValue = `<p>Hello World! Today is ${new Date().toLocaleDateString()}</p>`;
    const hookElement = createClassicEditorHtmlElement({
      preset: createPreset(),
      initialValue,
    });

    document.body.appendChild(hookElement);
    EditorHook.mounted.call({ el: hookElement });

    const editor = await waitForTestEditor();

    expect(editor.getData()).toBe(initialValue);
  });
});

/**
 * Creates a preset configuration for testing purposes.
 */
function createPreset(type: EditorType = 'classic', config: Partial<EditorConfig> = {}) {
  const defaultConfig: EditorConfig = {
    plugins: ['Essentials', 'Paragraph', 'Bold', 'Italic', 'Undo'],
    toolbar: ['undo', 'redo', '|', 'bold', 'italic'],
  };

  return {
    type,
    config: { ...defaultConfig, ...config },
    license: { key: 'GPL' },
  };
}

/**
 * Ensures that the editor is shown in the DOM.
 */
function isEditorShown() {
  return document.querySelector('.ck-editor__editable')?.classList.contains('ck-hidden') === false;
}

/**
 * Waits for the test editor to be registered in the EditorsRegistry.
 */
function waitForTestEditor(): Promise<Editor> {
  return EditorsRegistry.the.waitForEditor('test-editor');
}

/**
 * Creates a classic CKEditor HTML structure for testing.
 */
function createClassicEditorHtmlElement(
  {
    id = 'test-editor',
    preset = createPreset(),
    initialValue = '<p>Test content</p>',
    ...hookAttrs
  } = {},
) {
  return html.div(
    {
      id,
      'phx-hook': 'CKEditor5',
      'phx-update': 'ignore',
      'cke-preset': JSON.stringify(preset),
      'cke-initial-value': initialValue,
      ...hookAttrs,
    },
    html.div({ id: `${id}_editor` }),
    html.input({
      type: 'hidden',
      id: `${id}_input`,
      name: 'content',
      value: '<p>Test content</p>',
    }),
  );
}
