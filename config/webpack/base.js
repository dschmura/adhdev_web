const { webpackConfig, merge } = require('@rails/webpacker')
const customConfig = {
  plugins: [],
  resolve: {
    extensions: ['.css']
  }
}

module.exports = merge(webpackConfig, customConfig)
