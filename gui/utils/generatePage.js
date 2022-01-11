const path = require('path');
const { copyFile } = require('fs/promises');
const { generateAll } = require('./generate');

const processAll = async (startLocale) => {
  const templateName = 'index-template.html';
  const destPath = path.resolve(__dirname, '../pages/index');
  await generateAll(startLocale, templateName, destPath);
};


processAll();
// processAll('en');