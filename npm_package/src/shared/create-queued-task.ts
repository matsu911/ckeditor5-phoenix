import type { Defer } from './create-defer';
import type { Ref } from './create-ref';

import { createDefer } from './create-defer';

/**
 * Creates a queued task function that ensures that only one task is executed at a time.
 * Each task will wait for the previous one to complete before starting.
 *
 * @param fn Function to be executed as a queued task.
 * @param ref Optional ref object to hold the queue state. If not provided, a new one will be created.
 * @template T The type of the value that the promise will resolve to.
 * @template TArgs The type of the arguments that the function accepts.
 * @returns A function that can be called with arguments of type TArgs, which returns a promise that resolves to type T.
 */
export function createQueuedTask<T, TArgs extends unknown[]>(
  fn: (queue: Defer<T>, ...args: TArgs) => Promise<T>,
  ref?: QueueRef<T>,
) {
  const queueRef = ref || createQueueRef<T>();

  return async (...args: TArgs) => {
    const previousTaskPromise = queueRef.current?.promise;

    const currentTaskDefer = createDefer<T>();
    queueRef.current = currentTaskDefer;

    await previousTaskPromise;

    try {
      const result = await fn(currentTaskDefer, ...args);

      currentTaskDefer.resolve(result);

      return result;
    }
    catch (error) {
      currentTaskDefer.reject(error);
      throw error;
    }
    finally {
      if (queueRef.current === currentTaskDefer) {
        queueRef.current = null;
      }
    }
  };
}

/**
 * Creates a new queue reference object that holds a deferred promise.
 *
 * @returns A new queue reference object that holds a deferred promise.
 */
export function createQueueRef<T>(): QueueRef<T> {
  return { current: null };
}

/**
 * Type representing a reference to a queue that holds a deferred promise.
 *
 * @template T The type of the value that the deferred promise will resolve to.
 */
export type QueueRef<T> = Ref<Defer<T>>;
