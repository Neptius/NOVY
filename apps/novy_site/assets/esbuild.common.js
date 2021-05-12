const fs = require('fs-extra');
const autoprefixer = require("autoprefixer");
const postCssPlugin = require("esbuild-plugin-postcss2").default;
const tailwindcss = require("tailwindcss");
const { exists } = require('fs-extra');

const outdir = "../priv/static/"

const fileStructPlugin = {
    name: "Custom Process",
    setup(build) {
        build.onStart(async() => {
            try {
                //* Clear Output
                await fs.rm(outdir, { recursive: true, force: true })

                //* Copy Static
                await fs.copy("./static/", outdir, { overwrite: true });
            } catch (err) {
                console.error(err)
            }
        })


        build.onEnd(async(result) => {
            try {
                //* Move in respective directories
                await fs.move(outdir + "app.js", outdir + "js/app.js", { overwrite: true });
                await fs.move(outdir + "app.css", outdir + "css/app.css", { overwrite: true });
                if (await fs.stat(outdir + "app.js.map")) {
                    await fs.move(outdir + "app.js.map", outdir + "js/app.js.map", { overwrite: true });
                }
            } catch (err) {
                console.error(err)
            }
        })
    }
}

module.exports = {
    entryPoints: ['ts/app.ts'],
    platform: 'browser',
    bundle: true,
    metafile: false,
    minify: false,
    sourcemap: 'both',
    color: true,
    format: 'iife',
    outdir,
    loader: {
        ".ttf": "file"
    },
    external: ['*.ttf'],
    plugins: [
        fileStructPlugin,
        postCssPlugin({
            plugins: [
                autoprefixer,
                tailwindcss
            ]
        })
    ]
}