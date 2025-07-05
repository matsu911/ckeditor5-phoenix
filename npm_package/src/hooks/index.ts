import { makeHook } from 'shared';

import { EditorHook } from './editor';

export const Hooks = {
  CKEditor5: makeHook(EditorHook),
};
