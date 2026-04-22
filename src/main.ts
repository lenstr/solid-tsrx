import { createComponent } from 'solid-js'
import { render } from '@solidjs/web'
import './index.css'
import App from './App.tsrx'

const root = document.getElementById('root')

if (!root) {
  throw new Error('Missing #root element')
}

render(() => createComponent(App, {}), root)
