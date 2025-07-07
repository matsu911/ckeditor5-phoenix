/// <reference types="vitest" />
import { resolve } from 'node:path';

import { defineConfig } from 'vite';
import dts from 'vite-plugin-dts';
import tsconfigPaths from 'vite-tsconfig-paths';

export default defineConfig({
  plugins: [
    dts({
      insertTypesEntry: true,
    }),
    tsconfigPaths(),
  ],
  build: {
    sourcemap: true,
    lib: {
      entry: resolve(__dirname, 'src/index.ts'),
      name: 'CKEditor5Phoenix',
      formats: ['es', 'cjs'],
      fileName: format => `index.${format === 'es' ? 'mjs' : 'cjs'}`,
    },
    rollupOptions: {
      external: ['ckeditor5', 'ckeditor5-premium-features', 'phoenix_live_view'],
      output: {
        globals: {
          'ckeditor5': 'CKEditor5',
          'ckeditor5-premium-features': 'CKEditor5PremiumFeatures',
          'phoenix_live_view': 'PhoenixLiveView',
        },
      },
    },
  },
  test: {
    globals: true,
    watch: false,
    environment: 'jsdom',
  },
});
