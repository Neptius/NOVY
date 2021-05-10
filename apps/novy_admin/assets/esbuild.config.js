const esbuild = require('esbuild')
const fs = require('fs-extra');
const autoprefixer = require("autoprefixer");
const postCssPlugin = require("esbuild-plugin-postcss2").default;
const tailwindcss = require("tailwindcss");

const outdir = "../priv/static/"

const customPlugin = {
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
                await fs.move(outdir + "app.js", outdir + "js/app.js");
                await fs.move(outdir + "app.css", outdir + "css/app.css");
                // console.log(`build ended with ${result.errors.length} errors`)
            } catch (err) {
                console.error(err)
            }
        })
    }
}



async function main() {
    const result = await esbuild.build({
        entryPoints: ['ts/app.ts'],
        platform: 'browser',
        watch: true,
        bundle: true,
        metafile: true,
        color: true,
        format: 'iife',
        outdir,
        loader: {
            ".ttf": "file"
        },
        external: ['*.ttf'],
        plugins: [
            customPlugin,
            postCssPlugin({
                plugins: [
                    autoprefixer,
                    tailwindcss
                ]
            })
        ]
    })

    await fs.writeFile(outdir + 'meta.json',
        JSON.stringify(result.metafile))
}

main()

// .catch((e) => console.error(e.message));

// fs.writeFileSync('meta.json',
//     JSON.stringify(result.metafile))