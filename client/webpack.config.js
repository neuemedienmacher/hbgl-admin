/* eslint comma-dangle: ["error",
 {"functions": "never", "arrays": "only-multiline", "objects":
 "only-multiline"} ] */

const webpack = require('webpack');

const devBuild = process.env.NODE_ENV !== 'production';
const nodeEnv = devBuild ? 'development' : 'production';

const config = {
  entry: {
    // See use of 'vendor' in the CommonsChunkPlugin inclusion below.
    vendor: [
      'es5-shim/es5-shim',
      'es5-shim/es5-sham',
      'babel-polyfill',
      'jquery',
      // 'webpack-hot-middleware/client'
      // 'i18n-js'
    ],
    // This will contain the app entry points defined by webpack.hot.config and webpack.rails.config
    app: [
      'imports-loader?I18n=i18n-js!./vendor/translations',
      './vendor/imports',
      './app/lib/startup/clientRegistration'
    ]
  },

  output: {
    filename: 'webpack-bundle.js',
    path: '../app/assets/webpack',
  },

  resolve: {
    extensions: ['.js', '.jsx'],
    modulesDirectories: [path.resolve(__dirname, 'node_modules')]
  },

  plugins: [
    new webpack.EnvironmentPlugin({ NODE_ENV: nodeEnv }),
    new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery',
        jquery: 'jquery'
    }),
    // https://webpack.js.org/plugins/commons-chunk-plugin/
    new webpack.optimize.CommonsChunkPlugin({

      // This name 'vendor' ties into the entry definition
      name: 'vendor',

      // We don't want the default vendor.js name
      filename: 'vendor-bundle.js',

      // Passing Infinity just creates the commons chunk, but moves no modules into it.
      // In other words, we only put what's in the vendor entry definition in vendor-bundle.js
      minChunks: Infinity,
    }),
    // OccurenceOrderPlugin is needed for webpack 1.x only
    // new webpack.optimize.OccurenceOrderPlugin(),
    // new webpack.HotModuleReplacementPlugin(),
    // new webpack.NoErrorsPlugin()
  ],

  module: {
    rules: [
      {
        test: require.resolve('react'),
        use: {
          loader: 'imports-loader',
          options: {
            shim: 'es5-shim/es5-shim',
            sham: 'es5-shim/es5-sham',
          }
        },
      },
      {
        test: /\.jsx?$/,
        use: 'babel-loader',
        exclude: /node_modules/,
      },
      { test: /\.css$/, use: 'style-loader' },
      { test: /\.css$/, use: 'css-loader' },

      // { test: require.resolve('jquery'), use: { loader: 'expose-loader', options: {} } }


        // // Not all apps require jQuery. Many Rails apps do, such as those using TurboLinks or bootstrap js
        // { test: require.resolve('jquery'), loader: 'expose?jQuery' },
        // { test: require.resolve('jquery'), loader: 'expose?$' },
        // { test: require.resolve('i18n-js'), loader: 'expose?I18n' },
    ],
  },
};

module.exports = config;

if (devBuild) {
  console.log('Webpack dev build for Rails'); // eslint-disable-line no-console
  module.exports.devtool = 'eval-source-map';
} else {
  console.log('Webpack production build for Rails'); // eslint-disable-line no-console
}
