import { defineConfig } from "vite";
import preact from "@preact/preset-vite";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [preact()],
  resolve: {
    alias: [
      { find: "react", replacement: "preact/compat" },
      { find: "react-dom", replacement: "preact/compat" },
    ],
  },
  server: {
    port: 4000,
    proxy: {
      "/api": "http://rails-dev:3000",
    },
  },
});
