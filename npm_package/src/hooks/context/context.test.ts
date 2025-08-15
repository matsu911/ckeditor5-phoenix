import { ContextWatchdog } from 'ckeditor5';
import { afterEach, beforeEach, describe, expect, it } from 'vitest';

import { createContextHtmlElement, waitForTestContext } from '~/test-utils/editor';

import { ContextHook } from './context';
import { ContextsRegistry } from './contexts-registry';

Error.stackTraceLimit = Infinity;
describe('context hook', () => {
  beforeEach(() => {
    document.body.innerHTML = '';
  });

  afterEach(async () => {
    await ContextsRegistry.the.destroyAll();
  });

  describe('mount', () => {
    it('should save the context instance in the registry with provided id', async () => {
      const hookElement = createContextHtmlElement({ id: 'magic-context' });

      document.body.appendChild(hookElement);
      ContextHook.mounted.call({ el: hookElement });

      expect(await waitForTestContext('magic-context')).toBeInstanceOf(ContextWatchdog);
    });
  });

  describe('`cke-language` and `cke-content-language` options', () => {
    it('should pass the correct language to the editor (ui and content)', async () => {
      const hookElement = createContextHtmlElement({
        language: { ui: 'pl', content: 'de' },
      });

      hookElement.setAttribute('cke-language', 'pl');
      hookElement.setAttribute('cke-content-language', 'de');

      document.body.appendChild(hookElement);
      ContextHook.mounted.call({ el: hookElement });

      const { context } = await waitForTestContext();
      const configLanguage = context?.config.get('language') as any;

      expect(configLanguage).toBeDefined();
      expect(configLanguage?.ui).toBe('pl');
      expect(configLanguage?.content).toBe('de');
    });

    it('should use default language if not set', async () => {
      const hookElement = createContextHtmlElement({
        config: {
          watchdogConfig: {},
          config: { plugins: [] },
          customTranslations: {
            dictionary: {
              pl: { Bold: 'Custom Pogrubienie' },
            },
          },
        },
      });

      document.body.appendChild(hookElement);
      ContextHook.mounted.call({ el: hookElement });

      const { context } = await waitForTestContext();
      const configLanguage = context?.config.get('language') as any;

      expect(configLanguage).toBeDefined();
      expect(configLanguage?.ui).toBe('en');
      expect(configLanguage?.content).toBe('en');
    });

    it('should pass custom translations to the editor', async () => {
      const hookElement = createContextHtmlElement({
        config: {
          watchdogConfig: {},
          config: { plugins: [] },
          customTranslations: {
            dictionary: {
              pl: { Bold: 'Custom Pogrubienie' },
            },
          },
        },
        language: {
          ui: 'pl',
          content: 'pl',
        },
      });

      document.body.appendChild(hookElement);
      ContextHook.mounted.call({ el: hookElement });

      const { context } = await waitForTestContext();
      const translation = context?.t('Bold');

      expect(translation).toBe('Custom Pogrubienie');
    });
  });
});
