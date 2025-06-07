/* globals process */

import esbuild from 'esbuild';
import { sassPlugin } from 'esbuild-sass-plugin';

const isWatch = process.argv.includes('--watch');

const buildOptions = {
  entryPoints: ['playground/js/app.ts'],
  outdir: 'playground/priv/static',
  bundle: true,
  sourcemap: true,
  splitting: true,
  minify: false,
  format: 'esm',
  target: ['esnext'],
  plugins: [
    sassPlugin(),
  ],
};

if (isWatch) {
  const context = await esbuild.context(buildOptions);

  await context.watch();

  process.stdin.pipe(process.stdout);
  process.stdin.on('end', () => {
    context.dispose();
  });
} else {
  esbuild
    .build(buildOptions)
    .catch(() => {
      process.exit(1);
    });
}
