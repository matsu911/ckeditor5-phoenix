import type { Editor } from 'ckeditor5';

import { ClassicEditor } from 'ckeditor5';
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';

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

  describe('mount', () => {
    it('should create an classic editor with default preset', async () => {
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

    it('should create an editor even if `cke-initial-value` is not set', async () => {
      const hookElement = createClassicEditorHtmlElement({
        preset: createPreset(),
        initialValue: null,
      });

      document.body.appendChild(hookElement);
      EditorHook.mounted.call({ el: hookElement });

      const editor = await waitForTestEditor();

      expect(editor).toBeInstanceOf(ClassicEditor);
      expect(editor.getData()).toBe('');

      expect(isEditorShown()).toBe(true);
    });
  });

  describe('destroy', () => {
    it('should destroy editor on hook destruction', async () => {
      const hookElement = createClassicEditorHtmlElement();

      document.body.appendChild(hookElement);
      EditorHook.mounted.call({ el: hookElement });

      const editor = await waitForTestEditor();

      EditorHook.destroyed.call({ el: hookElement });

      expect(EditorsRegistry.the.getEditors()).toContain(editor);

      await new Promise((resolve) => {
        editor.once('destroy', resolve);
        editor.destroy();
      });

      expect(EditorsRegistry.the.getEditors()).not.toContain(editor);
    });

    it('should mark the element as hidden during destruction', async () => {
      const hookElement = createClassicEditorHtmlElement();

      document.body.appendChild(hookElement);
      EditorHook.mounted.call({ el: hookElement });

      await waitForTestEditor();

      expect(hookElement.style.display).toBe('');

      EditorHook.destroyed.call({ el: hookElement });

      expect(hookElement.style.display).toBe('none');
    });
  });

  describe('`cke-initial-value` attribute', () => {
    beforeEach(() => {
      vi.useFakeTimers();
    });

    afterEach(() => {
      vi.useRealTimers();
    });

    it('should not crash if input is not present', async () => {
      const initialValue = `<p>Test content</p>`;
      const hookElement = createClassicEditorHtmlElement({
        preset: createPreset(),
        initialValue,
        withInput: false,
      });

      document.body.appendChild(hookElement);
      EditorHook.mounted.call({ el: hookElement });

      await waitForTestEditor();
    });

    it('should initialize the input with the initial value', async () => {
      const initialValue = `<p>Test content</p>`;
      const hookElement = createClassicEditorHtmlElement({
        preset: createPreset(),
        initialValue,
        withInput: true,
      });

      document.body.appendChild(hookElement);
      EditorHook.mounted.call({ el: hookElement });

      await waitForTestEditor();

      const input = getTestEditorInput();

      expect(input.value).toBe(initialValue);
    });

    it('should sync editor data with a hidden input', async () => {
      const initialValue = `<p>Initial content</p>`;
      const hookElement = createClassicEditorHtmlElement({
        preset: createPreset(),
        initialValue,
        withInput: true,
      });

      document.body.appendChild(hookElement);
      EditorHook.mounted.call({ el: hookElement });

      const editor = await waitForTestEditor();
      const input = getTestEditorInput();

      editor.setData('<p>Updated content</p>');

      // Test if sync is debounced
      expect(input.value).toBe(initialValue);

      await vi.advanceTimersByTimeAsync(500);

      expect(input.value).toBe('<p>Updated content</p>');
    });
  });

  describe('`cke-editable-height` attribute', () => {
    it('should set the height of the editable area', async () => {
      const editableHeight = 255;
      const hookElement = createClassicEditorHtmlElement({
        preset: createPreset(),
        editableHeight,
      });

      document.body.appendChild(hookElement);
      EditorHook.mounted.call({ el: hookElement });

      const editor = await waitForTestEditor();
      const editable = editor.editing.view.document.getRoot('main');

      expect(editable?.getStyle('height')).toBe(`${editableHeight}px`);
    });
  });
});

/**
 * Creates a classic editor HTML element for testing.
 */
function getTestEditorInput() {
  return document.getElementById('test-editor_input') as HTMLInputElement;
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
    preset = createClassicPreset(),
    initialValue = '<p>Test content</p>',
    editableHeight = null,
    withInput = false,
    hookAttrs,
  }: {
    id?: string;
    preset?: ReturnType<typeof createClassicPreset>;
    initialValue?: string | null;
    editableHeight?: number | null;
    withInput?: boolean;
    hookAttrs?: Record<string, string>;
  } = {},
) {
  return html.div(
    {
      id,
      'phx-hook': 'CKEditor5',
      'phx-update': 'ignore',
      'cke-preset': JSON.stringify(preset),
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

/**
 * Creates a preset configuration for testing purposes.
 */
function createClassicPreset(type: EditorType = 'classic', config: Partial<EditorConfig> = {}) {
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
