import { execSync } from 'node:child_process';
import process from 'node:process';

import esbuild from 'esbuild';
import * as externalsPkg from 'esbuild-node-externals';

const isWatchMode = process.argv.includes('--watch');

const esmBuildOptions = {
  entryPoints: ['src/index.ts'],
  bundle: true,
  outfile: 'dist/esm/index.js',
  platform: 'neutral',
  format: 'esm',
  plugins: [externalsPkg.nodeExternalsPlugin()],
};

const cjsBuildOptions = {
  entryPoints: ['src/index.ts'],
  bundle: true,
  outdir: 'dist/cjs',
  platform: 'node',
  format: 'cjs',
  plugins: [externalsPkg.nodeExternalsPlugin()],
};

function generateDeclarations() {
  try {
    execSync('tsc --emitDeclarationOnly --outDir dist/esm');
    execSync('tsc --emitDeclarationOnly --outDir dist/cjs --project tsconfig.cjs.json');
  }
  catch (error) {
    console.error('TypeScript declaration generation failed:');
    console.error(error.stdout.toString());
  }
}

const generateDeclarationsPlugin = {
  name: 'regenerate-declarations',
  setup(build) {
    build.onEnd(() => {
      generateDeclarations();
    });
  },
};

async function build() {
  try {
    if (isWatchMode) {
      // Generate declarations once at start
      generateDeclarations();

      // Watch mode
      const esmContext = await esbuild.context({
        ...esmBuildOptions,
        plugins: [
          ...esmBuildOptions.plugins,
          generateDeclarationsPlugin,
        ],
      });

      const cjsContext = await esbuild.context({
        ...cjsBuildOptions,
        plugins: [
          ...cjsBuildOptions.plugins,
          generateDeclarationsPlugin,
        ],
      });

      await esmContext.watch();
      await cjsContext.watch();

      console.error('👀 Watching for changes...');

      // Keep the process alive
      process.on('SIGINT', async () => {
        await esmContext.dispose();
        await cjsContext.dispose();
        process.exit(0);
      });
    }
    else {
      // Regular build
      await esbuild.build(esmBuildOptions);
      await esbuild.build(cjsBuildOptions);

      generateDeclarations();

      console.error('✅ Build finished successfully!');
    }
  }
  catch (error) {
    console.error('Build failed:', error);
    process.exit(1);
  }
}

build();
