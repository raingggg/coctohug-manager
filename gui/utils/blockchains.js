const {
  WEB_DOCKER,
  CHAINS,
  FREE_CHAINS,
  P1_CHAINS,
  P2_CHAINS,
} = require('./generateChains');

const blks = {
  lastUpdate: new Date().getTime(),
};

const UPDATE_INTERVAL = 1000 * 60 * 60; // 1hour

const generateComposeStr = (mode, controllerIP, harvesterIP, disks, webDocker, checkedChains, includesWebDocker, timeZone, withNetwork) => {
  let configStr = '';

  configStr += "version: '3.7'\n";
  configStr += "services:\n";

  if (includesWebDocker) configStr += generateOneComposeStr(mode, controllerIP, harvesterIP, disks, webDocker, timeZone, withNetwork);
  checkedChains.forEach(chain => {
    configStr += generateOneComposeStr(mode, controllerIP, harvesterIP, disks, chain, timeZone, withNetwork);
  });

  return configStr;
}

const generateOneComposeStr = (mode, controllerIP, harvesterIP, disks, chainRecord, timeZone, withNetwork) => {
  let configStr = '';

  const { name, ports, image } = chainRecord;
  configStr += `  coctohug-${name}:\n`;
  configStr += `    image: ${image}\n`;
  configStr += `    container_name: coctohug-${name}\n`;
  configStr += `    restart: always\n`;
  if (withNetwork) {
    configStr += `    networks:\n`;
    configStr += `      - coctohug-network\n`;
  }
  configStr += `    volumes:\n`;

  configStr += `      - ~/.coctohug:/root/.coctohug\n`;
  if (name === 'web') {
    configStr += `      - ~/.coctohug-${name}:/root/.coctohug-web\n`;
  } else {
    configStr += `      - ~/.coctohug-${name}:/root/.chia\n`;
  }

  const cdisk = [];
  disks.forEach((md, mdi) => {
    const containerPlot = `/plots${mdi + 1}`;
    if (name !== 'web') {
      configStr += `      - ${md}:${containerPlot}\n`;
    }
    cdisk.push(containerPlot);
  });

  configStr += `    environment:\n`;
  if (timeZone) {
    configStr += `      - TZ=${timeZone}\n`;
  }
  configStr += `      - mode=${mode}\n`;
  configStr += `      - controller_address=${controllerIP}\n`;
  if (mode === 'harvester') {
    configStr += `      - worker_address=${harvesterIP}\n`;
  } else {
    configStr += `      - worker_address=${controllerIP}\n`;
  }
  configStr += `      - plots_dir=${cdisk.join(':')}\n`;
  configStr += `    ports:\n`;

  ports.split(',').forEach(p => {
    // if (name === 'silicoin' && p == 10447) {
    //   configStr += `      - ${p}:11447\n`;
    // } else {
    configStr += `      - ${p}:${p}\n`;
    // }
  });
  configStr += '\n';

  if (withNetwork) {
    configStr += `
networks:
  coctohug-network:
    name: coctohug-app-network
  `;
    configStr += '\n';
  }

  return configStr;
};

const getFiledBlockchains = (type) => {
  if (type === 'free') return FREE_CHAINS;
  else if (type === 'P1') return P1_CHAINS;
  else if (type === 'P2') return P2_CHAINS;
  else return [];
};

module.exports = {
  getFiledBlockchains,
  generateComposeStr,
  WEB_DOCKER,
  CHAINS,
}