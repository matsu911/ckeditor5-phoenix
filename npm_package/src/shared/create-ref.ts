/**
 * Creates a ref object that can be used to hold a mutable value.
 *
 * @param initialValue Initial value for the ref. If not provided, it will default to `null`.
 * @template T Type of the value that the ref will hold.
 * @returns A ref object with a `current` property.
 */
export function createRef<T>(initialValue?: T): Ref<T> {
  return {
    current: initialValue ?? null,
  };
}

export type Ref<T> = { current: T | null; };
