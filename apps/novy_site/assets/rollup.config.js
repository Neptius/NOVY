import path from 'path'
import postcss from 'rollup-plugin-postcss'
import static_files from 'rollup-plugin-static-files';
import typescript from '@rollup/plugin-typescript';
import { nodeResolve } from '@rollup/plugin-node-resolve';
import commonjs from '@rollup/plugin-commonjs';
import del from 'rollup-plugin-delete'
import { terser } from "rollup-plugin-terser";
import license from "rollup-plugin-license";

const devMode = process.env.ROLLUP_WATCH;

export default {
    input: 'ts/app.ts',
    output: {
        format: 'iife',
        name: 'app',
        dir: '../priv/static/',
        entryFileNames: 'js/app.js',
        sourcemap: devMode ? false : 'inline'
    },
    plugins: [
        typescript(),
        commonjs(),
        nodeResolve(),
        postcss({
            extract: path.resolve('../priv/static/css/app.css'),
            minimize: !devMode,
            plugins: []
        }),
        static_files({
            include: ['./static']
        }),
        del({
            targets: '../priv/static/*',
            runOnce: devMode,
            force: true
        }),
        ...!devMode ? [
            terser(),
            license({
                thirdParty: {
                    includePrivate: true, // Default is false.
                    output: {
                        file: path.resolve('../priv/static/js/app.js.LICENSE.txt'),
                        encoding: 'utf-8', // Default is utf-8.
                    },
                },
            }),
        ] : [],
    ]
}