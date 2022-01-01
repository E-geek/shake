process.env.NODE_ENV = process.env.NODE_ENV or 'development'
path = require('path')
dotenv = require('dotenv')
webpack = require('webpack')
TerserPlugin = require('terser-webpack-plugin')
HtmlWebpackPlugin = require('html-webpack-plugin')
HtmlWebpackPugPlugin = require('html-webpack-pug-plugin')
{ BundleAnalyzerPlugin } = require('webpack-bundle-analyzer')

{ version } = require('../package')
env = dotenv.config(path: path.resolve(__dirname, '..', '.env')).parsed
envExample = dotenv.config(path: path.resolve(__dirname, '..', '.env.example')).parsed
envOptionalKeys = []

module.exports = (envCLI, argv) ->
  pKeys = Object.keys(process.env)
  Object.keys(envExample).forEach (key) ->
    if envOptionalKeys.includes(key)
      return
    if !process.env[key] or !(key of env)
      throw '[ERROR]: environment key ${key} is not set'
    return
  envKeys = Object.keys(env).reduce((prev, next) =>
    prev["process.env.#{next}"] = JSON.stringify(env[next])
    return prev
  , {})

  envKeys['process.env.APP_VERSION'] = JSON.stringify(version);
  pKeys.forEach (pKey) =>
    envKeys["process.env.#{pKey}"] = JSON.stringify(process.env[pKey]);

  devtool = 'inline-source-map'
  hash = '.[hash]'
  outputDir = path.join(__dirname, '..', 'public', 'js')
  publicPath = '/js/'
  splitChunks = if argv.mode == 'development' then null else
    chunks: 'async'
    maxSize: 244000

  optimization =
    minimize: true
    moduleIds: 'size'
    splitChunks: splitChunks
    minimizer: [ new TerserPlugin(
      parallel: true
      terserOptions: output: comments: false
      extractComments: false) ]

  plugins = [
    new (webpack.DefinePlugin)(envKeys)
    new HtmlWebpackPlugin
      template: path.join(__dirname, '..', 'views', 'base.pug').toString(),
      filename: '../../views/layout.pug',
      minify: false
    new HtmlWebpackPugPlugin
      adjustIndent: true
    # new (webpack.optimize.OccurrenceOrderPlugin)
  ]

  if argv.analyze
    plugins.push new BundleAnalyzerPlugin

  {
    entry: './front/main.coffee'
    devtool: devtool
    output:
      path: outputDir
      filename: "main#{hash}.js"
      publicPath: publicPath
      clean: true
    resolve:
      modules: [
        path.resolve(__dirname)
        'node_modules'
      ]
      extensions: [
        '.js'
        '.jsx'
        '.coffee'
      ]
    devServer:
      host: '0.0.0.0'
      historyApiFallback: true
      disableHostCheck: true
    # node: fs: 'empty'
    module: rules: [
      {
        test: /\.coffee?$/
        exclude: /node_modules|stories/
        use: [
          {
            loader: 'babel-loader'
            options: presets: [ '@babel/preset-react' ]
          }
          {
            loader: 'coffee-loader'
            ###options:
              transpile: {}###
        }
        ]
      }
      {
        test: /\.styl$/
        use: [
          'style-loader'
          'css-loader'
          'postcss-loader'
          'stylus-loader'
          ###{
            loader: path.resolve(__dirname, 'res', 'modLoader.js')
            options:
              test: /\/components\/[^/]+\/[^/]+\.styl$/
              prepend: "@import \'../../res/css/variables.styl\'\n@import \'../../res/css/mixins.styl\'\n\n`"
          }###
        ]
      }
      {
        test: /\.css$/
        use: [
          'style-loader'
          'css-loader'
          'postcss-loader'
          'resolve-url-loader'
        ]
      }
      {
        test: /\.svg$/
        use: [ '@svgr/webpack' ]
      }
      {
        test: /res\/.*\.png/
        loader: 'file-loader'
        options:
          outputPath: '/evro-stat/images'
          publicPath: '/evro-stat/images'
      }
      {
        test: /node_modules\/.*\.(jpe?g|png|gif|woff|woff2|eot|ttf|svg)(\?[a-z0-9=.]+)?$/
        loader: 'url-loader'
      }
    ]
    optimization: if process.env.NODE_ENV == 'production' then optimization else undefined
    plugins: plugins
  }

# ---
# generated by js2coffee 2.2.0
