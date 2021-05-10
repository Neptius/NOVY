const path = require("path");
const esbuild = require('esbuild')
const fs = require('fs-extra');
const autoprefixer = require("autoprefixer");
// const postCssPlugin = require("@deanc/esbuild-plugin-postcss");
const postCssPlugin = require("esbuild-plugin-postcss2").default;
const tailwindcss = require("tailwindcss");

const outdir = "./dist/"

let startPlugin = {
    name: 'example',
    setup(build) {
        build.onStart(async() => {
            try {
                console.log('build started')
                await fs.rm(outdir, { recursive: true, force: true })
                await fs.copy("./static/", outdir, { overwrite: true });
            } catch (err) {
                console.error(err)
            }
        })
    },
}

esbuild.build({
    entryPoints: ['ts/app.ts'],
    platform: 'browser',
    bundle: true,
    metafile: true,
    color: true,
    format: 'iife',
    outdir: 'dist/js/',
    loader: {
        ".ttf": "file"
    },
    external: ['*.ttf'],
    plugins: [
        startPlugin,
        postCssPlugin({
            plugins: [
                autoprefixer,
                tailwindcss
            ]
        })
    ]
}).catch((e) => console.error(e.message));