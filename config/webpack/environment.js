const { environment } = require('@rails/webpacker')
const webpack = require('webpack')

const coffee =  require('./loaders/coffee')

environment.loaders.prepend('coffee', coffee)
module.exports = environment


environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    jquery: 'jquery'
  })
)