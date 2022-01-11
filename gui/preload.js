// All of the Node.js APIs are available in the preload process.
// It has the same sandbox as a Chrome extension.
window.addEventListener('DOMContentLoaded', () => {
  const replaceText = (selector, text) => {
    const element = document.getElementById(selector)
    if (element) element.innerText = text
  }

  for (const type of ['chrome', 'node', 'electron']) {
    replaceText(`${type}-version`, process.versions[type])
  }

  const path = require('path');
  const { readdir, writeFile } = require('fs/promises');

  const getForks = async () => {
    const localePath = path.resolve(__dirname, '../compose');
    let files = await readdir(path.resolve(localePath));
    console.log(files);
  };

  getForks();
})
