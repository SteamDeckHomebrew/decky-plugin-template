import commonjs from '@rollup/plugin-commonjs';
import json from '@rollup/plugin-json';
import {nodeResolve} from '@rollup/plugin-node-resolve';
import replace from '@rollup/plugin-replace';
import typescript from '@rollup/plugin-typescript';
import {defineConfig} from 'rollup';
import importAssets from 'rollup-plugin-import-assets';

import {name} from "./plugin.json";
import {createPathTransform} from "rollup-sourcemap-path-transform";

const production = process.env.NODE_ENV !== 'development'

export default defineConfig({
  input: './src/ts/index.tsx',
  plugins: [
    commonjs(),
    nodeResolve({browser: true}),
    typescript({sourceMap: !production, inlineSources: !production}),
    json(),
    replace({
      preventAssignment: false,
      'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV),
    }),
    importAssets({
      publicPath: `http://127.0.0.1:1337/plugins/${name}/`
    })
  ],
  context: 'window',
  external: ['react', 'react-dom'],
  output: {
    file: 'dist/index.js',
    sourcemap: !production ? 'inline' : false,
    sourcemapPathTransform: !production ? createPathTransform({
      prefixes: {
        "../src/src/ts/": `/plugins/${name}/src/`,
        "../node_modules/.pnpm/": `/plugins/${name}/node_modules/`
      },
      requirePrefix: true
    }) : undefined,
    footer: () => !production ? `\n//# sourceURL=http://localhost:1337/plugins/${name}/frontend_bundle` : "",
    globals: {
      react: 'SP_REACT',
      'react-dom': 'SP_REACTDOM',
    },
    format: 'iife',
    exports: 'default',
  },
});
