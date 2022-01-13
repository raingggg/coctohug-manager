function getTimeZone() {
  let timeZone = '';
  try {
    timeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;
  } catch (e) { console.log(e); }
  return timeZone;
}

function clickGenerateDocker() {
  const mode = document.querySelector('input[name="mode"]:checked').value;
  const controllerIP = document.querySelector('#controllerIP').value.trim();
  const harvesterIP = document.querySelector('#harvesterIP').value.trim();
  const forkNames = [...document.querySelectorAll('input[name="fork-name"]:checked')].map(e => e.value);
  const disks = document.querySelector('#diskVolumesTextarea').value.trim().split('\n').filter(d => !!d);
  const timeZone = getTimeZone();
  console.log([mode, controllerIP, harvesterIP, forkNames, disks, timeZone]);
}

const initClickEvent = (elem, func) => {
  if (elem && func) elem.onclick = func;
};

const initEvents = () => {
  initClickEvent(document.getElementById('downloadGenerateDockerBtn'), clickGenerateDocker);
}

module.exports = {
  initEvents
}