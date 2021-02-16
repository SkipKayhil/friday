// @ts-check
import { resolve } from "path";
import preactRefresh from "@prefresh/vite";

/**
 * @type { import('vite').UserConfig }
 */
const config = {
  resolve: {
    alias: [
      { find: "react", replacement: "preact/compat" },
      { find: "react-dom", replacement: "preact/compat" },
    ],
  },
  build: {
    manifest: true,
    outDir: "../../public/dist",
    rollupOptions: {
      input: resolve(__dirname, "app/vite/main.jsx"),
    },
  },
  esbuild: {
    jsxFactory: "h",
    jsxFragment: "Fragment",
    jsxInject: `import { h, Fragment } from 'preact'`,
  },
  plugins: [preactRefresh()],
  root: process.cwd() + "/app/vite",
  server: {
    port: 4000,
  },
};

export default config;
