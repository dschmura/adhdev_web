// See the Tailwind default theme values here:
// https://github.com/tailwindcss/tailwindcss/blob/master/stubs/defaultConfig.stub.js

module.exports = {
  plugins: [
    // Uncomment the following if you'd like to use TailwindUI
    //require('@tailwindcss/ui')({
    //  layout: 'sidebar',
    //})
  ],

  // All the default values will be compiled unless they are overridden below
  theme: {
    // Extend (add to) the default theme in the `extend` key
    extend: {
      colors: {
        "primary-200": "#eef1ff",
        "primary-500": "#4965f6",
        "primary-600": "#1231d0",
        "secondary-200": "#e3f6ed",
        "secondary-500": "#3ecf8e",
        "secondary-600": "#36b47c",
        "tertiary-200": "#eeeeee",
        "tertiary-500": "#57586e",
        "tertiary-600": "#3a3b48",
        "danger-200": "#fff3f3",
        "danger-500": "#F37B7B",
        "danger-600": "#d26969",
        "code-400": "#fefcf9",
        "code-600": "#3c455b",
      },
    },
    // override the default theme using the key directly
    fontFamily: {
      sans: [
        "Lato",
        "-apple-system",
        "BlinkMacSystemFont",
        '"Segoe UI"',
        "Roboto",
        '"Helvetica Neue"',
        "Arial",
        '"Noto Sans"',
        "sans-serif",
        '"Apple Color Emoji"',
        '"Segoe UI Emoji"',
        '"Segoe UI Symbol"',
        '"Noto Color Emoji"',
      ],
    },
  },
}
