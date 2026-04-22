declare module '*.tsrx' {
  import type { Component } from 'solid-js'

  const component: Component<any>
  export default component
}
