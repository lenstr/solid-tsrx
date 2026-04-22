export async function delayImport<T>(loader: () => Promise<T>, ms = 1200): Promise<T> {
  const [module] = await Promise.all([
    loader(),
    new Promise((resolve) => window.setTimeout(resolve, ms)),
  ])

  return module
}
