import { defineConfig } from 'vite'
import tsrxSolid from '@tsrx/vite-plugin-solid'
import solid from 'vite-plugin-solid'

export default defineConfig({
  plugins: [tsrxSolid(), solid({ dev: false, hot: false })],
  optimizeDeps: {
    noDiscovery: true,
  },
})
