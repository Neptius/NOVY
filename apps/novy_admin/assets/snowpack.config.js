module.exports = {
    workspaceRoot: "../../..",
    mount: {
        "js": { url: "/build" },
        "css": { url: "/css" },
        "static": { url: "/", static: true, resolve: false }
    },
    buildOptions: {
        out: "../priv/static/"
    },
    optimize: {
        entrypoints: ["./build/app.js"],
        bundle: true,
        minify: true,
        target: "es2020"
    },
    plugins: [
        "@snowpack/plugin-postcss"
    ]
};