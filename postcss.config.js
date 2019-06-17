let environment = {
  plugins: [
    require('tailwindcss')('app/javascript/stylesheets/tailwind.config.js'),
    require('autoprefixer'),
    require('postcss-import'),
    require('postcss-flexbugs-fixes'),
    require('postcss-preset-env')({
      autoprefixer: {
        flexbox: 'no-2009'
      },
      stage: 3
    }),
  ]
}

if (process.env.RAILS_ENV === "production" || process.env.RAILS_ENV === "staging") {
  // A whitelist of css classes to keep that might not be found in the app
  function collectWhitelist() {
    return ['font-serif', 'tab-active', 'transition', 'text-gray-400'];
  }

  environment.plugins.push(
    require('@fullhuman/postcss-purgecss')({
      content: ['./**/*.html.erb', './app/helpers/**/*.rb'],
      defaultExtractor: content => content.match(/[A-Za-z0-9-_:/]+/g) || [],
      whitelist: collectWhitelist(),
      whitelistPatterns: [],
      whitelistPatternsChildren: [/trix/, /attachment/, /tribute/],
    })
  )
}

module.exports = environment
