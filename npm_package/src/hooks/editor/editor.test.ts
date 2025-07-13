import { ClassicEditor, DecoupledEditor, InlineEditor, MultiRootEditor } from 'ckeditor5';
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';

import {
  createEditableElement,
  createEditorHtmlElement,
  createEditorPreset,
  getTestEditorInput,
  isEditorShown,
  waitForTestEditor,
} from '~/test-utils';

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
    describe('classic', () => {
      it('should create an classic editor with default preset', async () => {
        const hookElement = createEditorHtmlElement();

        document.body.appendChild(hookElement);
        EditorHook.mounted.call({ el: hookElement });

        const editor = await waitForTestEditor();

        expect(editor).to.toBeInstanceOf(ClassicEditor);
        expect(isEditorShown()).toBe(true);
      });

      it('should assign default value to the editor using "cke-initial-value" attribute', async () => {
        const initialValue = `<p>Hello World! Today is ${new Date().toLocaleDateString()}</p>`;
        const hookElement = createEditorHtmlElement({
          initialValue,
        });

        document.body.appendChild(hookElement);
        EditorHook.mounted.call({ el: hookElement });

        const editor = await waitForTestEditor();

        expect(editor.getData()).toBe(initialValue);
      });

      it('should create an editor even if `cke-initial-value` is not set', async () => {
        const hookElement = createEditorHtmlElement({
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

    describe('decoupled', () => {
      it('should be possible to create decoupled editor without any editable', async () => {
        const hookElement = createEditorHtmlElement({
          preset: createEditorPreset('decoupled'),
        });

        document.body.appendChild(hookElement);
        document.body.appendChild(createEditableElement());

        EditorHook.mounted.call({ el: hookElement });

        const editor = await waitForTestEditor();

        expect(editor).toBeInstanceOf(DecoupledEditor);
        expect(editor.getData()).toBe('<p>Test content</p>');

        expect(isEditorShown()).toBe(true);
      });
    });

    describe('inline', () => {
      it('should create an inline editor with default preset', async () => {
        const hookElement = createEditorHtmlElement({
          preset: createEditorPreset('inline'),
        });

        document.body.appendChild(hookElement);
        EditorHook.mounted.call({ el: hookElement });

        const editor = await waitForTestEditor();

        expect(editor).toBeInstanceOf(InlineEditor);
        expect(isEditorShown()).toBe(true);
      });
    });

    describe('multiroot', () => {
      it('should create a multiroot editor without editables', async () => {
        const hookElement = createEditorHtmlElement({
          preset: createEditorPreset('multiroot'),
        });

        document.body.appendChild(hookElement);
        EditorHook.mounted.call({ el: hookElement });

        const editor = await waitForTestEditor();

        expect(editor).toBeInstanceOf(MultiRootEditor);
      });

      it('should create a multiroot editor with editables', async () => {
        const hookElement = createEditorHtmlElement({
          preset: createEditorPreset('multiroot'),
        });

        document.body.appendChild(hookElement);
        document.body.appendChild(createEditableElement('main', '<p>Main root</p>'));
        document.body.appendChild(createEditableElement('second', '<p>Second root</p>'));

        EditorHook.mounted.call({ el: hookElement });

        const editor = await waitForTestEditor();

        expect(editor).toBeInstanceOf(MultiRootEditor);
        expect(editor.getData({ rootName: 'main' })).toBe('<p>Main root</p>');
        expect(editor.getData({ rootName: 'second' })).toBe('<p>Second root</p>');
      });
    });
  });

  describe('destroy', () => {
    it('should destroy editor on hook destruction', async () => {
      const hookElement = createEditorHtmlElement();

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
      const hookElement = createEditorHtmlElement();

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
      const hookElement = createEditorHtmlElement({
        initialValue,
        withInput: false,
      });

      document.body.appendChild(hookElement);
      EditorHook.mounted.call({ el: hookElement });

      await waitForTestEditor();
    });

    it('should initialize the input with the initial value', async () => {
      const initialValue = `<p>Test content</p>`;
      const hookElement = createEditorHtmlElement({
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
      const hookElement = createEditorHtmlElement({
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
      const hookElement = createEditorHtmlElement({
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
