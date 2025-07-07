import { makeHook } from 'shared';

import { EditableHook } from './editable';
import { EditorHook } from './editor';

export const Hooks = {
  CKEditor5: makeHook(EditorHook),
  CKEditable: makeHook(EditableHook),
};
