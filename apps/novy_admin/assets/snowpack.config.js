module.exports = {
    workspaceRoot: "../../..",
    mount: {
        "js": { url: "/js" },
        "css": { url: "/css" },
        "static": { url: "/", static: true, resolve: false }
    },
    buildOptions: {
        out: "../priv/static/"
    },
    optimize: {
        entrypoints: ["./js/app.js"],
        bundle: false,
        minify: true,
        target: "es2020"
    },
    plugins: [
        "@snowpack/plugin-postcss"
    ]
};