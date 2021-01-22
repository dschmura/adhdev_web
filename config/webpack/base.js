const { webpackConfig, merge } = require('@rails/webpacker')
const customConfig = {
  // Use cheap sourcemap generation
  devtool: 'eval-cheap-module-source-map',
  resolve: {
    extensions: ['.css']
  }
}

module.exports = merge(webpackConfig, customConfig)
