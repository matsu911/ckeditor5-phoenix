/**
 * Creates a deferred object that can be used to resolve or reject a promise later.
 *
 * @template T - The type of the value that the promise will resolve to.
 * @returns An object containing the promise, resolve function, and reject function.
 */
export function createDefer<T>() {
  let resolve: (value: T | PromiseLike<T>) => void;
  let reject: (reason?: any) => void;

  const promise = new Promise<T>((res, rej) => {
    resolve = res;
    reject = rej;
  });

  return {
    promise,
    resolve: resolve!,
    reject: reject!,
  };
}

export type Defer<T> = ReturnType<typeof createDefer<T>>;
