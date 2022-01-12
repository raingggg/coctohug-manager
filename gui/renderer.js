// This file is required by the index.html file and will
// be executed in the renderer process for that window.
// No Node.js APIs are available in this process because
// `nodeIntegration` is turned off. Use `preload.js` to
// selectively enable features needed in the rendering
// process.

function getTimeZone() {
  let timeZone = '';
  try {
    timeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;
  } catch (e) { console.log(e); }
  return timeZone;
}

$('.app-config .config-item').change(function () {
  const appPage = $('.app-config');
  appPage.find('.alert-item').each(function (index, item) {
    $(this).addClass('visually-hidden');
  });

  const mode = appPage.find('input[name="mode"]:checked').val();
  const controllerIP = appPage.find('#controllerIP').val().trim();
  const harvesterIP = appPage.find('#harvesterIP').val().trim();
  const isHarvesterMode = mode === 'harvester';
  const isWalletMode = mode.includes('wallet');
  const isValidHarvesterIP = !isHarvesterMode || (isHarvesterMode && harvesterIP);

  if (isWalletMode) {
    $('#diskVolumeCol').addClass('visually-hidden');
  } else {
    $('#diskVolumeCol').removeClass('visually-hidden');
  }

  const forkNames = [];
  appPage.find('input:checkbox:checked').each(function (index, item) {
    forkNames.push($(this).val());
  });
  const disks = appPage.find('#diskVolumesTextarea').val().trim().split('\n').filter(d => !!d);

  const harvesterIPCol = appPage.find('#harvesterIPCol');
  if (isHarvesterMode) {
    harvesterIPCol.removeClass('visually-hidden');
  } else {
    harvesterIPCol.addClass('visually-hidden');
  }

  if (controllerIP && isValidHarvesterIP && forkNames.length > 0 && disks.length > 0) {
    appPage.find('#allChecks').addClass('visually-hidden');
    appPage.find('.generate-btns').prop("disabled", false);
  } else {
    appPage.find('#allChecks').removeClass('visually-hidden');
    appPage.find('.generate-btns').prop("disabled", true);

    if (!controllerIP) appPage.find('#missingControllerIP').removeClass('visually-hidden');
    if (!isValidHarvesterIP) appPage.find('#missingHarvesterIP').removeClass('visually-hidden');
    if (forkNames.length === 0) appPage.find('#missingFork').removeClass('visually-hidden');
    if (!isWalletMode && disks.length === 0) appPage.find('#missingDisk').removeClass('visually-hidden');
  }
});

$('#downloadGenerateDockerBtn').click(function () {
  const appPage = $('.app-config');
  // $(this).prop("disabled", true);

  const mode = appPage.find('input[name="mode"]:checked').val();
  const controllerIP = appPage.find('#controllerIP').val().trim();
  const harvesterIP = appPage.find('#harvesterIP').val().trim();
  const forkNames = [];
  appPage.find('input:checkbox:checked').each(function (index, item) {
    forkNames.push($(this).val());
  });
  const disks = appPage.find('#diskVolumesTextarea').val().trim().split('\n').filter(d => !!d);
  const timeZone = getTimeZone();

  alert([mode, controllerIP, harvesterIP, disks, forkNames, timeZone]);
});
