# Github: https://github.com/raingggg/coctohug-manager

param ([string]$ActionName, [string]$ActionParameter)

if ("$ActionName" -eq "h" -or "$ActionName" -eq "help") {
  Write-Host "help:"
  Write-Host "command guide: ccm help"

  Write-Host
  Write-Host "sample commands for the flora fork:"
  Write-Host "install one fork such as flora: ccm install flora"
  Write-Host "start one fork such as flora: ccm start flora"
  Write-Host "stop one fork such as flora: ccm stop flora"
  Write-Host "restart one fork such as flora: ccm restart flora"
  Write-Host "upgrade one fork such as flora: ccm upgrade flora"
  Write-Host "upgrade then start one fork such as flora: ccm upup flora"
  Write-Host "uninstall one fork such as flora: ccm uninstall flora"
  Write-Host 'migrate one fork db such as flora: ccm migrate-db "flora,c:/Users/username/.flora/mainnet/db"'
  Write-Host 'migrate one fork wallet-db such as flora: ccm migrate-wallet "flora,c:/Users/username/.flora/mainnet/wallet/db"'

  Write-Host
  Write-Host "quick commands for all forks:"
  Write-Host "install all forks: ccm install all"
  Write-Host "start all forks: ccm start all"
  Write-Host "stop all forks: ccm stop all"
  Write-Host "restart all forks: ccm restart all"
  Write-Host "upgrade all forks: ccm upgrade all"
  Write-Host "upgrade then start all forks: ccm upup all"
  Write-Host "uninstall all forks: ccm uninstall all"

  Write-Host
  Write-Host "24 mnemonic words:"
  # Write-Host "import mnemonic words: ccm import-key 'flip display churn country relax else smoke hello holiday yard involve lab detect popular climb spirit emerge brush maple glimpse jelly cross ancient female'"
  Write-Host "empty mnemonic words: ccm empty-key"

  Write-Host
  Write-Host "view detailed fork status:"
  Write-Host "view connection info such as flora: ccm vconnection flora"
  Write-Host "view farm summary info such as flora: ccm vsummary flora"
  Write-Host "view wallet info such as flora: ccm vwallet flora"
  Write-Host "view key info such as flora: ccm vkey flora"
  Write-Host "view log info such as flora: ccm vlog flora"
  
  Write-Host
  Write-Host "go to docker/fork container:"
  Write-Host "go inside docker such as flora: ccm docker flora"
  
  Write-Host
  Write-Host "docker management:"
  Write-Host "clean all unused docker images: ccm clean"
  Write-Host "show all docker containers: ccm container"
  Write-Host "show all docker images: ccm image"
    
  exit 0
}

$sleepSeconds = 60
$fcount = (Get-ChildItem -Path compose/*/* -File -Filter  "docker-compose.yml" | Select-String "fullnode" | Measure-Object -Line).Lines
if ($fcount -gt 5) {
  $sleepSeconds = 300
}

$controllerIP = (Get-ChildItem -Path compose/*/* -File -Filter  "docker-compose.yml" | Select-String "controller_address=(.*)" | select -first 1 | Select-String "controller_address=(.*)").matches.groups[1].value

function ccInstall {
  param ([string]$imageName)
  if ($imageName -eq 'all') {
    $files = Get-ChildItem "compose" -Attributes Directory
    foreach ($f in $files) {
      Write-Host "processing $($f) ..."
      docker-compose -f compose/$f/docker-compose.yml pull
    }
  }
  else {
    docker-compose -f compose/$imageName/docker-compose.yml pull  
  }
}

function ccStart {
  param ([string]$imageName)
  if ($imageName -eq 'all') {
    $files = Get-ChildItem "compose" -Attributes Directory
    foreach ($f in $files) {
      Write-Host "processing $($f) ..."
      docker-compose -f compose/$f/docker-compose.yml up -d
      Write-Host "sleeping $sleepSeconds seconds for saving computer resources, and next fork will be processed $sleepSeconds seconds later..."
      Write-Host $(Get-Date -format "yyyy-MM-dd HH:mm:ss")
      Start-Sleep -Seconds $sleepSeconds
    }
  }
  else {
    docker-compose -f compose/$imageName/docker-compose.yml up -d  
  }
  
  try { $ProgressPreference = 'SilentlyContinue'; (Invoke-WebRequest -Uri "http://$($controllerIP):12630/reviewWeb") | out-null; $ProgressPreference = 'Continue' } catch {}
  Write-Host "Done. Please open browser with url http://$($controllerIP):12630 to watch the forks status - it might need around 30 minutes to fully load fork status"
}

function ccStop {
  param ([string]$imageName)
  if ($imageName -eq 'all') {
    $files = Get-ChildItem "compose" -Attributes Directory
    foreach ($f in $files) {
      Write-Host "processing $($f) ..."
      docker-compose -f compose/$f/docker-compose.yml stop
    }
  }
  else {
    docker-compose -f compose/$imageName/docker-compose.yml stop
  }
}

function ccReStart {
  param ([string]$imageName)
  if ($imageName -eq 'all') {
    $files = Get-ChildItem "compose" -Attributes Directory
    foreach ($f in $files) {
      Write-Host "processing $($f) ..."
      docker-compose -f compose/$f/docker-compose.yml stop
      docker-compose -f compose/$f/docker-compose.yml up -d
      Write-Host "sleeping $sleepSeconds seconds for saving computer resources, and next fork will be processed $sleepSeconds seconds later..."
      Write-Host $(Get-Date -format "yyyy-MM-dd HH:mm:ss")
      Start-Sleep -Seconds $sleepSeconds
    }
  }
  else {
    docker-compose -f compose/$imageName/docker-compose.yml stop
    docker-compose -f compose/$imageName/docker-compose.yml up -d
  }
  
  try { $ProgressPreference = 'SilentlyContinue'; (Invoke-WebRequest -Uri "http://$($controllerIP):12630/reviewWeb") | out-null; $ProgressPreference = 'Continue' } catch {}
  Write-Host "Done. Please open browser with url http://$($controllerIP):12630 to watch the forks status - it might need around 30 minutes to fully load fork status"
}

function ccUpgrade {
  param ([string]$imageName)

  if ($imageName -eq 'all') {
    $files = Get-ChildItem "compose" -Attributes Directory
    foreach ($f in $files) {
      Write-Host "processing $($f) ..."
      docker-compose -f compose/$f/docker-compose.yml stop
      docker-compose -f compose/$f/docker-compose.yml rm -f
      docker-compose -f compose/$f/docker-compose.yml pull
    }
  }
  else {
    docker-compose -f compose/$imageName/docker-compose.yml stop
    docker-compose -f compose/$imageName/docker-compose.yml rm -f
    docker-compose -f compose/$imageName/docker-compose.yml pull
  }
}

function ccUpUp {
  param ([string]$imageName)

  if ($imageName -eq 'all') {
    $files = Get-ChildItem "compose" -Attributes Directory
    foreach ($f in $files) {
      Write-Host "processing $($f) ..."
      docker-compose -f compose/$f/docker-compose.yml stop
      docker-compose -f compose/$f/docker-compose.yml rm -f
      docker-compose -f compose/$f/docker-compose.yml pull
      docker-compose -f compose/$f/docker-compose.yml up -d
      Write-Host "sleeping $sleepSeconds seconds for saving computer resources, and next fork will be processed $sleepSeconds seconds later..."
      Write-Host $(Get-Date -format "yyyy-MM-dd HH:mm:ss")
      Start-Sleep -Seconds $sleepSeconds
    }
  }
  else {
    docker-compose -f compose/$imageName/docker-compose.yml stop
    docker-compose -f compose/$imageName/docker-compose.yml rm -f
    docker-compose -f compose/$imageName/docker-compose.yml pull
    docker-compose -f compose/$imageName/docker-compose.yml up -d
  }
  
  try { $ProgressPreference = 'SilentlyContinue'; (Invoke-WebRequest -Uri "http://$($controllerIP):12630/reviewWeb") | out-null; $ProgressPreference = 'Continue' } catch {}
  Write-Host "Done. Please open browser with url http://$($controllerIP):12630 to watch the forks status - it might need around 30 minutes to fully load fork status"
}

function ccUnInstall {
  param ([string]$imageName)

  if ($imageName -eq 'all') {
    $files = Get-ChildItem "compose" -Attributes Directory
    foreach ($f in $files) {
      Write-Host "processing $($f) ..."
		    docker-compose -f compose/$f/docker-compose.yml stop
      docker-compose -f compose/$f/docker-compose.yml rm -f
    }
  }
  else {
    docker-compose -f compose/$imageName/docker-compose.yml stop
    docker-compose -f compose/$imageName/docker-compose.yml rm -f
  }
}

function ccMigrateDb {
  param ([string]$migrateParams)
  $imageName = $migrateParams.split(",")[0]
  $folder = $migrateParams.split(",")[1]
  $mainnetPath = ''
  if ($imageName -eq "chia") {
    $mainnetPath = "$HOME/.coctohug-$imageName/mainnet"
  }
  elseif ($imageName -eq "silicoin") {
    $mainnetPath = "$HOME/.coctohug-$imageName/sit/mainnet"
  }
  elseif ($imageName -eq "nchain") {
    $mainnetPath = "$HOME/.coctohug-$imageName/ext9"
  }
  else {
    $mainnetPath = "$HOME/.coctohug-$imageName/$imageName/mainnet"
  }

  docker-compose -f compose/$imageName/docker-compose.yml stop
  rm -r -fo $mainnetPath/db/*.*
  robocopy $folder $mainnetPath/db *.* /r:3 /w:10 /mt:1 /njh /njs /ndl /nc /ns
  docker-compose -f compose/$imageName/docker-compose.yml up -d
  
  try { $ProgressPreference = 'SilentlyContinue'; (Invoke-WebRequest -Uri "http://$($controllerIP):12630/reviewWeb") | out-null; $ProgressPreference = 'Continue' } catch {}
  Write-Host "Done. Please open browser with url http://$($controllerIP):12630 to watch the forks status - it might need around 30 minutes to fully load fork status"
}

function ccMigrateWallet {
  param ([string]$migrateParams)
  $imageName = $migrateParams.split(",")[0]
  $folder = $migrateParams.split(",")[1]
  $mainnetPath = ''
  if ($imageName -eq "chia") {
    $mainnetPath = "$HOME/.coctohug-$imageName/mainnet"
  }
  elseif ($imageName -eq "silicoin") {
    $mainnetPath = "$HOME/.coctohug-$imageName/sit/mainnet"
  }
  elseif ($imageName -eq "nchain") {
    $mainnetPath = "$HOME/.coctohug-$imageName/ext9"
  }
  else {
    $mainnetPath = "$HOME/.coctohug-$imageName/$imageName/mainnet"
  }

  docker-compose -f compose/$imageName/docker-compose.yml stop
  rm -r -fo $mainnetPath/wallet/db/*.*
  robocopy $folder $mainnetPath/wallet/db *.* /r:3 /w:10 /mt:1 /njh /njs /ndl /nc /ns
  docker-compose -f compose/$imageName/docker-compose.yml up -d
  
  try { $ProgressPreference = 'SilentlyContinue'; (Invoke-WebRequest -Uri "http://$($controllerIP):12630/reviewWeb") | out-null; $ProgressPreference = 'Continue' } catch {}
  Write-Host "Done. Please open browser with url http://$($controllerIP):12630 to watch the forks status - it might need around 30 minutes to fully load fork status"
}

function ccImportKey {
  keywords="$1"
  # Write-Host "$keywords" > $HOME/.coctohug/mnc.txt
  # Write-Host ""
  # Write-Host "Imported. To use it, you may run 'ccm start flax' for flax fork"
}

function ccEmptyKey {
  Write-Host '' > $HOME/.coctohug/mnc.txt
}

function ccVConnection {
  param ([string]$1)
  $imageName = $1
  $binName = $1
  if ($1 -eq "nchain" -or $1 -eq "rose") {
    $binName = "chia"
  }
  elseif ($1 -eq "silicoin") {
    $binName = "sit"
  }
  docker exec -it coctohug-$imageName $binName show -c
}

function ccVChain {
  param ([string]$1)
  $imageName = $1
  $binName = $1
  if ($1 -eq "nchain" -or $1 -eq "rose") {
    $binName = "chia"
  }
  elseif ($1 -eq "silicoin") {
    $binName = "sit"
  }
  docker exec -it coctohug-$imageName $binName show -s
}

function ccVSummary {
  param ([string]$1)
  $imageName = $1
  $binName = $1
  if ($1 -eq "nchain" -or $1 -eq "rose") {
    $binName = "chia"
  }
  elseif ($1 -eq "silicoin") {
    $binName = "sit"
  }
  docker exec -it coctohug-$imageName $binName farm summary
}

function ccVWallet {
  param ([string]$1)
  $imageName = $1
  $binName = $1
  if ($1 -eq "nchain" -or $1 -eq "rose") {
    $binName = "chia"
  }
  elseif ($1 -eq "silicoin") {
    $binName = "sit"
  }
  docker exec -it coctohug-$imageName $binName wallet show
}

function ccVKey {
  param ([string]$1)
  $imageName = $1
  $binName = $1
  if ($1 -eq "nchain" -or $1 -eq "rose") {
    $binName = "chia"
  }
  elseif ($1 -eq "silicoin") {
    $binName = "sit"
  }
  docker exec -it coctohug-$imageName $binName keys show
}

function ccVLog {
  param ([string]$1)
  $imageName = $1
  $pathName = $1
  if ($1 -eq "silicoin") {
    $pathName = "sit"
  }
  docker exec -it coctohug-$imageName tail -f /root/.$pathName/mainnet/log/debug.log
}

function ccDocker {
  param ([string]$imageName)
  docker exec -it coctohug-$imageName /bin/bash
}

function ccClean {
  docker image prune -a
}

function ccContainer {
  docker ps -a
}

function ccImage {
  docker images
}

if ($ActionName -eq 'install') {
  ccInstall $ActionParameter
}
elseif ($ActionName -eq 'start') {
  ccStart $ActionParameter
}
elseif ($ActionName -eq 'stop') {
  ccStop $ActionParameter
}
elseif ($ActionName -eq 'restart') {
  ccReStart $ActionParameter
}
elseif ($ActionName -eq 'upgrade') {
  ccUpgrade $ActionParameter
}
elseif ($ActionName -eq 'upup') {
  ccUpUp $ActionParameter
}
elseif ($ActionName -eq 'uninstall') {
  ccUnInstall $ActionParameter
}
elseif ($ActionName -eq 'migrate-db') {
  ccMigrateDb $ActionParameter
}
elseif ($ActionName -eq 'migrate-wallet') {
  ccMigrateWallet $ActionParameter
  # } elseif ($ActionName -eq 'import-key') {
  #   ccImportKey $ActionParameter
}
elseif ($ActionName -eq 'empty-key') {
  ccEmptyKey $ActionParameter
}
elseif ($ActionName -eq 'vconnection') {
  ccVConnection $ActionParameter
}
elseif ($ActionName -eq 'vchain') {
  ccVChain $ActionParameter
}
elseif ($ActionName -eq 'vsummary') {
  ccVSummary $ActionParameter
}
elseif ($ActionName -eq 'vwallet') {
  ccVWallet $ActionParameter
}
elseif ($ActionName -eq 'vkey') {
  ccVKey $ActionParameter
}
elseif ($ActionName -eq 'vlog') {
  ccVLog $ActionParameter
}
elseif ($ActionName -eq 'docker') {
  ccDocker $ActionParameter
}
elseif ($ActionName -eq 'clean') {
  ccClean $ActionParameter
}
elseif ($ActionName -eq 'container') {
  ccContainer $ActionParameter
}
elseif ($ActionName -eq 'image') {
  ccImage $ActionParameter
}


