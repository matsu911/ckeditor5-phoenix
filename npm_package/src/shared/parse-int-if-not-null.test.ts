import { describe, expect, it } from 'vitest';

import { parseIntIfNotNull } from './parse-int-if-not-null';

describe('parseIntIfNotNull', () => {
  it('should return null if value is null', () => {
    expect(parseIntIfNotNull(null)).toBeNull();
  });

  it('should return a number if value is a valid number string', () => {
    expect(parseIntIfNotNull('123')).toBe(123);
  });

  it('should return null if value is not a valid number string', () => {
    expect(parseIntIfNotNull('abc')).toBeNull();
  });

  it('should handle zero correctly', () => {
    expect(parseIntIfNotNull('0')).toBe(0);
  });

  it('should handle negative numbers correctly', () => {
    expect(parseIntIfNotNull('-42')).toBe(-42);
  });
});
