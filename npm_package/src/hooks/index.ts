import { makeHook } from 'shared';

import { Editor } from './editor';

export const Hooks = {
  CKEditor5: makeHook(Editor),
};
