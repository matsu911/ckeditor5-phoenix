import { makeHook } from 'shared';

import { EditableHook } from './editable';
import { EditorHook } from './editor';
import { UIPartHook } from './ui-part';

export const Hooks = {
  CKEditor5: makeHook(EditorHook),
  CKEditable: makeHook(EditableHook),
  CKUIPart: makeHook(UIPartHook),
};
