import { ClassHook, makeHook } from '../hook';

/**
 * CKEditor5 hook for Phoenix LiveView.
 *
 * This class is a hook that can be used with Phoenix LiveView to integrate
 * the CKEditor 5 WYSIWYG editor.
 */
class CKEditor5Impl extends ClassHook {
  override mounted() {
    // eslint-disable-next-line no-console
    console.info('CKEditor5 hook mounted on:', this.el);
  }
}

export const CKEditor5 = makeHook(CKEditor5Impl);
