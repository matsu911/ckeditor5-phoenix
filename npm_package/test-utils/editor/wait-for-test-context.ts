import { ContextsRegistry } from '../../src/hooks/context/contexts-registry';

/**
 * Waits for the test context instance to be available in the registry.
 * @param id The context id (default: 'test-context')
 */
export function waitForTestContext(id: string = 'test-context') {
  return ContextsRegistry.the.waitFor(id);
}
