const WEB_DOCKER = { name: 'web', ports: '12630', type: 'free', image: 'raingggg/coctohug-web:develop' };
const CHAINS = [
  { name: 'skynet', ports: '12643,9999,9998', type: 'free', image: 'raingggg/coctohug-skynet:develop' },
  { name: 'stor', ports: '12646,8668,8337', type: 'free', image: 'raingggg/coctohug-stor:develop' },
  { name: 'shibgreen', ports: '12648,18974,7442', type: 'free', image: 'raingggg/coctohug-shibgreen:develop' },
  { name: 'ethgreen', ports: '12649,6262,6258', type: 'free', image: 'raingggg/coctohug-ethgreen:develop' },
  { name: 'btcgreen', ports: '12650,18655,9282', type: 'free', image: 'raingggg/coctohug-btcgreen:develop' },
  { name: 'hddcoin', ports: '12651,28444,28447', type: 'free', image: 'raingggg/coctohug-hddcoin:develop' },
  { name: 'maize', ports: '12652,8644,8647', type: 'free', image: 'raingggg/coctohug-maize:develop' },
  { name: 'flax', ports: '12653,6888,6885', type: 'free', image: 'raingggg/coctohug-flax:develop' },
];

const sortChainByName = (a, b) => {
  if (a.name < b.name) {
    return -1;
  }
  if (a.name > b.name) {
    return 1;
  }
  return 0;
};

const FREE_CHAINS = CHAINS.filter(c => c.type === 'free').sort(sortChainByName);
const P1_CHAINS = CHAINS.filter(c => c.type === 'P1').sort(sortChainByName);
const P2_CHAINS = CHAINS.filter(c => c.type === 'P2').sort(sortChainByName);

module.exports = {
  WEB_DOCKER,
  CHAINS,
  FREE_CHAINS,
  P1_CHAINS,
  P2_CHAINS,
}