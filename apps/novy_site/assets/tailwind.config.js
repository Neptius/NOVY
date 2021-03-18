module.exports = {
  purge: [
    "../**/*.html.eex",
    "../**/*.html.leex",
    "../**/views/**/*.ex",
    "../**/live/**/*.ex",
    "./js/**/*.js",
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      colors: {
        steam: {
          lighter: "#45474c",
          default: "#1e1f21",
          dark: "#0d0d0e"
        },
        discord: {
          lighter: "#95a0c7",
          default: "#7289da",
          dark: "#4e5d94"
        },
        twitch: {
          lighter: "#7d6a9e",
          default: "#6441a3",
          dark: "#4a366b"
        }
      }
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
