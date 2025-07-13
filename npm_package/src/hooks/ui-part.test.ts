import { DecoupledEditor } from 'ckeditor5';
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';

import {
  createEditorHtmlElement,
  createEditorPreset,
  createUIPartHtmlElement,
  waitForTestEditor,
} from '~/test-utils';

import { EditorHook } from './editor';
import { EditorsRegistry } from './editor/editors-registry';
import { UIPartHook } from './ui-part';

describe('ui part hook', () => {
  beforeEach(async () => {
    document.body.innerHTML = '';

    await appendDecoupledEditor();
  });

  afterEach(async () => {
    vi.restoreAllMocks();
    await EditorsRegistry.the.destroyAllEditors();
  });

  describe('mount', () => {
    it.for(['toolbar', 'menubar'])('should create a %s UI part', async (partName) => {
      const uiElement = createUIPartHtmlElement({ name: partName });

      document.body.appendChild(uiElement);
      UIPartHook.mounted.call({ el: uiElement });

      await vi.waitFor(() => {
        expect(uiElement.querySelector('.ck')).not.toBeNull();
      });
    });

    it('should log error when the UI part name is unknown', async () => {
      const consoleErrorSpy = vi.spyOn(console, 'error').mockImplementation(() => {});
      const uiElement = createUIPartHtmlElement({ name: 'unknown' });

      document.body.appendChild(uiElement);
      UIPartHook.mounted.call({ el: uiElement });

      await vi.waitFor(() => {
        expect(consoleErrorSpy).toHaveBeenCalledWith(
          expect.stringContaining('Unknown UI part name: "unknown". Supported names are "toolbar" and "menubar".'),
        );
      });
    });
  });

  describe('destroyed', () => {
    it('should remove the UI part element from the DOM', async () => {
      const uiElement = createUIPartHtmlElement({ name: 'toolbar' });

      document.body.appendChild(uiElement);
      UIPartHook.mounted.call({ el: uiElement });

      await vi.waitFor(() => {
        expect(uiElement.querySelector('.ck')).not.toBeNull();
      });

      UIPartHook.destroyed.call({ el: uiElement });

      await vi.waitFor(() => {
        expect(uiElement.querySelector('.ck')).toBeNull();
      });
    });

    it('should hide the element during destruction to prevent flickering', async () => {
      const uiElement = createUIPartHtmlElement({ name: 'toolbar' });

      document.body.appendChild(uiElement);
      UIPartHook.mounted.call({ el: uiElement });

      await vi.waitFor(() => {
        expect(uiElement.style.display).toBe('');
      });

      UIPartHook.destroyed.call({ el: uiElement });

      await vi.waitFor(() => {
        expect(uiElement.style.display).toBe('none');
      });
    });
  });
});

async function appendDecoupledEditor() {
  const hookElement = createEditorHtmlElement({
    preset: createEditorPreset('decoupled', {
      menuBar: {
        isVisible: true,
      },
    }),
  });

  document.body.appendChild(hookElement);
  EditorHook.mounted.call({ el: hookElement });

  const editor = (await waitForTestEditor()) as DecoupledEditor;

  expect(editor).toBeInstanceOf(DecoupledEditor);

  return editor;
}
