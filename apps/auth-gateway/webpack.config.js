const { NxAppWebpackPlugin } = require('@nx/webpack/app-plugin');

const path = require('path');
const outDir = path.join(__dirname, '../../dist/apps/auth-gateway');

module.exports = {
  output: {
    devtoolModuleFilenameTemplate(info) {
      const { absoluteResourcePath, namespace, resourcePath } = info;

      if (path.isAbsolute(absoluteResourcePath)) {
        return path.relative(outDir, absoluteResourcePath);
      }

      // Mimic Webpack's default behavior:
      return `webpack://${namespace}/${resourcePath}`;
    },
    path: outDir,
  },
  plugins: [
    new NxAppWebpackPlugin({
      target: 'node',
      compiler: 'tsc',
      main: './src/main.ts',
      tsConfig: './tsconfig.app.json',
      assets: ['./src/assets'],
      optimization: false,
      outputHashing: 'none',
      sourceMap: true,
    }),
  ],
};
