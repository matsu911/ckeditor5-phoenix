/**
 * Creates a function that can be called only once.
 *
 * @param fn Function to be called once.
 * @template T Type of the function.
 * @returns A function that can be called only once.
 */
export function once<T extends (...args: any[]) => any>(fn: T): T {
  let called = false;
  let result: ReturnType<T>;

  return function (this: any, ...args: Parameters<T>): ReturnType<T> {
    if (!called) {
      called = true;
      result = fn.apply(this, args);
    }

    return result;
  } as T;
}
