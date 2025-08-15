import type { ContextConfig } from '../../src/hooks/context/typings';

import { html } from '../html';

type ContextCreatorAttrs = {
  id?: string;
  config?: ContextConfig;
  language?: { ui?: string; content?: string; };
  hookAttrs?: Record<string, string>;
};

/**
 * Creates a CKEditor Context HTML structure for testing.
 */
export function createContextHtmlElement(
  {
    id = 'test-context',
    config = {
      watchdogConfig: {},
      config: {},
      customTranslations: null,
    },
    language,
    hookAttrs = {},
  }: ContextCreatorAttrs = {},
) {
  return html.div(
    {
      id,
      'phx-hook': 'CKContext',
      'phx-update': 'ignore',
      'cke-context': JSON.stringify(config),
      ...language?.ui && {
        'cke-language': language.ui,
      },
      ...language?.content && {
        'cke-content-language': language.content,
      },
      ...hookAttrs,
    },
  );
}
