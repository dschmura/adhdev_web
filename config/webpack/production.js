process.env.NODE_ENV = process.env.NODE_ENV || 'production'

const webpackConfig = require('./base')
const { merge } = require('@rails/webpacker')

const customConfig = {
  devtool: false
}

module.exports = merge(webpackConfig, customConfig)
