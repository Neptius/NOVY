module.exports = {
    purge: {
        enabled: process.env.MIX_ENV === "prod",
        content: [
            "../**/*.html.eex",
            "../**/*.html.leex",
            "../**/views/**/*.ex",
            "../**/live/**/*.ex",
            "./ts/**/*.ts",
        ],
        options: {
            whitelist: []
        }
    },
    darkMode: false, // or 'media' or 'class'
    theme: {
        extend: {},
    },
    variants: {
        extend: {},
    },
    plugins: [
        require('@tailwindcss/forms'),
    ]
}