import path from 'path'
import postcss from 'rollup-plugin-postcss'
import { babel } from '@rollup/plugin-babel';
import { nodeResolve } from '@rollup/plugin-node-resolve';
import commonjs from '@rollup/plugin-commonjs';
import { terser } from "rollup-plugin-terser";
import progress from 'rollup-plugin-progress';
import { visualizer } from 'rollup-plugin-visualizer';

const isProduction = process.env.NODE_ENV === 'production';

export default {
    input: './js/app.js',
    output: {
        name: 'app',
        dir: '../priv/static',
        format: 'es',
        sourcemap: true
    },
    plugins: [
        nodeResolve(),
        commonjs(),
        babel({
            babelHelpers: 'bundled'
        }),
        postcss({
            plugins: [],
            extract: path.resolve(__dirname, '../priv/static/css/app.css'),
            minimize: isProduction,
            sourceMap: true
        }),
        progress({
            clearLine: true // default: true
        }),
        (isProduction && terser()),
        visualizer({
            filename: path.resolve(__dirname, '../priv/static/stats.html'),
        })
    ]
};