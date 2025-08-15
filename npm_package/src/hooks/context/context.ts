import type { ContextConfig, WatchdogConfig } from 'ckeditor5';

import { Context, ContextWatchdog } from 'ckeditor5';

import { ClassHook, deepCamelCaseKeys, makeHook } from '../../shared';
import { ContextsRegistry } from './contexts-registry';

/**
 * Context hook for Phoenix LiveView. It allows you to create contexts for collaboration editors.
 */
class ContextHookImpl extends ClassHook {
  /**
   * The promise that resolves to the context instance.
   */
  private contextPromise: Promise<ContextWatchdog<Context>> | null = null;

  /**
   * Attributes for the context instance.
   */
  private get attrs() {
    const get = (attr: string) => this.el.getAttribute(attr) || null;
    const getConfig = <T>(attr: string): T | null => deepCamelCaseKeys(
      JSON.parse(get(attr)!),
    );

    const value = {
      id: this.el.id,
      watchdogConfig: getConfig<WatchdogConfig>('cke-watchdog-config')!,
      config: getConfig<ContextConfig>('cke-context-config')!,
    };

    Object.defineProperty(this, 'attrs', {
      value,
      writable: false,
      configurable: false,
      enumerable: true,
    });

    return value;
  }

  /**
   * Mounts the context component.
   */
  override async mounted() {
    const { id, config, watchdogConfig } = this.attrs;

    this.contextPromise = (async () => {
      const instance = new ContextWatchdog(Context, {
        crashNumberLimit: 10,
        ...watchdogConfig,
      });

      instance.create(config);
      instance.on('itemError', (...args) => {
        console.error('Context item error:', ...args);
      });

      return instance;
    })();

    ContextsRegistry.the.register(id, await this.contextPromise);
  }

  /**
   * Destroys the context component. Unmounts root from the editor.
   */
  override async destroyed() {
    // Let's hide the element during destruction to prevent flickering.
    this.el.style.display = 'none';

    // Let's wait for the mounted promise to resolve before proceeding with destruction.
    const context = await this.contextPromise;
    await context?.destroy();
    this.contextPromise = null;

    ContextsRegistry.the.unregister(this.attrs.id);
  }
}

/**
 * Type guard to check if an element is a context hook HTMLElement.
 */
function isContextHookHTMLElement(el: HTMLElement): el is HTMLElement & { instance: ContextHookImpl; } {
  return el.hasAttribute('cke-context-config');
}

/**
 * Gets the nearest context hook parent element.
 */
function getNearestContextParent(el: HTMLElement) {
  let parent: HTMLElement | null = el;

  while (parent) {
    if (isContextHookHTMLElement(parent)) {
      return parent;
    }

    parent = parent.parentElement;
  }

  return null;
}

/**
 * Gets the nearest context parent element as a promise.
 */
export async function getNearestContextParentPromise(el: HTMLElement): Promise<ContextWatchdog<Context> | null> {
  const parent = getNearestContextParent(el);

  if (!parent) {
    return null;
  }

  return ContextsRegistry.the.waitFor(parent.id);
}

/**
 * Phoenix LiveView hook for CKEditor 5 context elements.
 */
export const ContextHook = makeHook(ContextHookImpl);
