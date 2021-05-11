const esbuild = require('esbuild')
const fs = require('fs-extra');

const options = require('./esbuild.common')

async function main() {
    try {
        const result = await esbuild.build({
            ...options,
            watch: false,
            minify: true,
            metafile: true
        })
        await fs.writeFile(options.outdir + 'meta.json',
            JSON.stringify(result.metafile))
    } catch (e) {
        console.error(e.message)
    }
}

main()