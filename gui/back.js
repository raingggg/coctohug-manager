const path = require('path');
const { mkdir, writeFile, readdir } = require('fs/promises');
const {
  generateComposeStr,
  WEB_DOCKER,
  getFiledBlockchains,
} = require('./utils/blockchains');

const downloadTmpPath = path.resolve(__dirname, `../compose`);
const generateComposeFiles = async (params) => {
  try {
    const { mode, controllerIP, harvesterIP, forkNames, disks, timeZone } = params;
    if (mode && controllerIP && forkNames && disks) {

      // write web file
      const includesWebDocker = mode !== 'harvester';
      await generateAndWriteOneFile(downloadTmpPath, 'web', mode, controllerIP, harvesterIP, disks, WEB_DOCKER, [], includesWebDocker, timeZone);

      // write one file per each
      const blockchains = getFiledBlockchains('free');
      const checkedChains = blockchains.filter(b => forkNames.includes(b.name));
      for (let i = 0; i < checkedChains.length; i++) {
        const oneChain = checkedChains[i];
        await generateAndWriteOneFile(downloadTmpPath, oneChain.name, mode, controllerIP, harvesterIP, disks, WEB_DOCKER, [oneChain], false, timeZone);
      }
    }
  } catch (e) {
    console.error(e);
  }
};

const generateAndWriteOneFile = async (parentPath, folderName, mode, controllerIP, harvesterIP, disks, WEB_DOCKER, groupedChains, includesWebDocker, timeZone) => {
  if (!includesWebDocker && groupedChains.length === 0) return;

  const tmpPath = path.resolve(parentPath, `./${folderName}`);
  await mkdir(tmpPath, { recursive: true });
  const composeStr = generateComposeStr(mode, controllerIP, harvesterIP, disks, WEB_DOCKER, groupedChains, includesWebDocker, timeZone, true);
  await writeFile(path.resolve(tmpPath, './docker-compose.yml'), composeStr);
};

const getDockerContainers = async () => {
  return await readdir(downloadTmpPath);
};

module.exports = {
  generateComposeFiles,
  getDockerContainers,
}