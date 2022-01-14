const {
  generateComposeFiles,
  getDockerContainers,
} = require('./back');

function getTimeZone() {
  let timeZone = '';
  try {
    timeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;
  } catch (e) { console.log(e); }
  return timeZone;
}

const clickGenerateDocker = async () => {
  const mode = document.querySelector('input[name="mode"]:checked').value;
  const controllerIP = document.querySelector('#controllerIP').value.trim();
  const harvesterIP = document.querySelector('#harvesterIP').value.trim();
  const forkNames = [...document.querySelectorAll('input[name="fork-name"]:checked')].map(e => e.value);
  const disks = document.querySelector('#diskVolumesTextarea').value.trim().split('\n').filter(d => !!d);
  const timeZone = getTimeZone();
  await generateComposeFiles({ mode, controllerIP, harvesterIP, forkNames, disks, timeZone });
  await loadDockerContainers();
}

const loadDockerContainers = async () => {
  const containers = await getDockerContainers();
  let tbodyStr = '';
  containers.forEach(ct => {
    tbodyStr += `
    <tr>
      <td>${ct}</td>
      <td>Install</td>
      <td>Start</td>
      <td>Stop</td>
      <td>Restart</td>
      <td>Upgrade</td>
      <td>Upgrade then Start</td>
    </tr>`;
  });

  document.getElementById('dct-body').innerHTML = tbodyStr;
};

const initClickEvent = (elem, func) => {
  if (elem && func) elem.onclick = func;
};

const initEvents = () => {
  initClickEvent(document.getElementById('downloadGenerateDockerBtn'), clickGenerateDocker);
}

module.exports = {
  initEvents
}