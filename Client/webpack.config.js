const path = require('path')
const webpack = require('webpack')
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const HtmlWebpackPlugin  = require('html-webpack-plugin');
    
module.exports = env => {
    return {
    resolve: {
        extensions: ['.js', '.jsx'],
        fallback: { "path": require.resolve("path-browserify") },
    },
    plugins: [
        new HtmlWebpackPlugin({
            template: './public/index.html',
            filename: './index.html',
            favicon: './public/favicon.ico'
        }),
        new MiniCssExtractPlugin({
            filename: '[name].bundle.css',
            chunkFilename: '[id].css'
        }),
        new webpack.HotModuleReplacementPlugin(),
    ],
    entry: path.resolve(__dirname, 'src', 'index.js'),
    output: {
        path: path.resolve(__dirname, 'public'),
        filename: 'bundle.js'
    },
    devServer: {
        static: {
            directory: path.join(__dirname, "public/"),
        },
        port: 3000,
        devMiddleware: {
            publicPath: "https://localhost:3000",
        },

    },
    module: {
        rules: [
        {
            test: /\.(jsx|js)$/,
            include: path.resolve(__dirname, 'src'),
            exclude: /node_modules/,
            use: [{
            loader: 'babel-loader',
            options: {
                presets: [
                ['@babel/preset-env', {
                    "targets": "defaults" 
                }],
                '@babel/preset-react'
                ]
            }
            }]
        },
        {
            test: /\.css$/i,
            include: path.resolve(__dirname, 'src'),
            exclude: /node_modules/,
            use: [
            {
                loader: MiniCssExtractPlugin.loader,
                options: {
                    // hmr: env.NODE_ENV === 'development',
                }
            },
            {
                loader: 'css-loader',
                options: {
                importLoaders: 0
                }
            }
            ]
        }
        ]
    }
    }
}