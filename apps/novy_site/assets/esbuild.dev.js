const esbuild = require('esbuild')

const options = require('./esbuild.common')

async function main() {
    try {
        await esbuild.build(options)
    } catch (e) {
        console.error(e.message)
    }
}

main()