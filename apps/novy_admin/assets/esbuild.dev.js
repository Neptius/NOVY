const esbuild = require('esbuild')

const options = require('./esbuild.common')

async function main() {
    try {
        let result = await esbuild.build(options)
        result.stop()
    } catch (e) {
        console.error(e.message)
    }
}

main()