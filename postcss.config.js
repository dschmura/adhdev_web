module.exports = {
  plugins: [
    require('tailwindcss')('app/javascript/stylesheets/tailwind.config.js'),
    require('autoprefixer'),
    require('postcss-import'),
  ]
}
