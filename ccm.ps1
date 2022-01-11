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

function ccInstall
{
    param ([string]$imageName)
    if ($imageName -eq 'all') {
      $files = Get-ChildItem "compose" -Attributes Directory
      foreach ($f in $files) {
        Write-Host "processing $($f) ..."
        docker-compose -f compose/$f/docker-compose.yml pull
      }
    } else {
      docker-compose -f compose/$imageName/docker-compose.yml pull  
    }
}

function ccStart
{
    param ([string]$imageName)
    if ($imageName -eq 'all') {
      $files = Get-ChildItem "compose" -Attributes Directory
      foreach ($f in $files) {
        Write-Host "processing $($f) ..."
        docker-compose -f compose/$f/docker-compose.yml up -d
        Write-Host "sleeping 5 minutes for saving computer resources, and next fork will be processed 5 minutes later..."
        Write-Host $(Get-Date -format "yyyy-MM-dd HH:mm:ss")
        Start-Sleep -Seconds 300
      }
    } else {
      docker-compose -f compose/$imageName/docker-compose.yml up -d  
    }
}

function ccStop
{
    param ([string]$imageName)
    if ($imageName -eq 'all') {
      $files = Get-ChildItem "compose" -Attributes Directory
      foreach ($f in $files) {
        Write-Host "processing $($f) ..."
        docker-compose -f compose/$f/docker-compose.yml stop
      }
    } else {
      docker-compose -f compose/$imageName/docker-compose.yml stop
    }
}

function ccReStart
{
    param ([string]$imageName)
    if ($imageName -eq 'all') {
      $files = Get-ChildItem "compose" -Attributes Directory
      foreach ($f in $files) {
        Write-Host "processing $($f) ..."
        docker-compose -f compose/$f/docker-compose.yml restart
        Write-Host "sleeping 5 minutes for saving computer resources, and next fork will be processed 5 minutes later..."
        Write-Host $(Get-Date -format "yyyy-MM-dd HH:mm:ss")
        Start-Sleep -Seconds 300
      }
    } else {
      docker-compose -f compose/$imageName/docker-compose.yml restart 
    }
}

function ccUpgrade
{
    param ([string]$imageName)

    if ($imageName -eq 'all') {
      $files = Get-ChildItem "compose" -Attributes Directory
      foreach ($f in $files) {
        Write-Host "processing $($f) ..."
        docker-compose -f compose/$f/docker-compose.yml stop
        docker-compose -f compose/$f/docker-compose.yml rm -f
        docker-compose -f compose/$f/docker-compose.yml pull
      }
    } else {
      docker-compose -f compose/$imageName/docker-compose.yml stop
      docker-compose -f compose/$imageName/docker-compose.yml rm -f
      docker-compose -f compose/$imageName/docker-compose.yml pull
    }
}

function ccUpUp
{
    param ([string]$imageName)

    if ($imageName -eq 'all') {
      $files = Get-ChildItem "compose" -Attributes Directory
      foreach ($f in $files) {
        Write-Host "processing $($f) ..."
        docker-compose -f compose/$f/docker-compose.yml stop
        docker-compose -f compose/$f/docker-compose.yml rm -f
        docker-compose -f compose/$f/docker-compose.yml pull
        docker-compose -f compose/$f/docker-compose.yml up -d
        Write-Host "sleeping 5 minutes for saving computer resources, and next fork will be processed 5 minutes later..."
        Write-Host $(Get-Date -format "yyyy-MM-dd HH:mm:ss")
        Start-Sleep -Seconds 300
      }
    } else {
      docker-compose -f compose/$imageName/docker-compose.yml stop
      docker-compose -f compose/$imageName/docker-compose.yml rm -f
      docker-compose -f compose/$imageName/docker-compose.yml pull
      docker-compose -f compose/$imageName/docker-compose.yml up -d
    }
}

function ccUnInstall
{
    param ([string]$imageName)

    if ($imageName -eq 'all') {
      $files = Get-ChildItem "compose" -Attributes Directory
      foreach ($f in $files) {
        Write-Host "processing $($f) ..."
		    docker-compose -f compose/$f/docker-compose.yml stop
        docker-compose -f compose/$f/docker-compose.yml rm -f
      }
    } else {
	    docker-compose -f compose/$imageName/docker-compose.yml stop
      docker-compose -f compose/$imageName/docker-compose.yml rm -f
    }
}

function ccVConnection
{
    param ([string]$imageName)
    docker exec -it coctohug-$imageName $imageName show -c
}

function ccVChain
{
    param ([string]$imageName)
    docker exec -it coctohug-$imageName $imageName show -s
}

function ccVSummary
{
    param ([string]$imageName)
    docker exec -it coctohug-$imageName $imageName farm summary
}

function ccVWallet
{
    param ([string]$imageName)
    docker exec -it coctohug-$imageName $imageName wallet show
}

function ccVKey
{
    param ([string]$imageName)
    docker exec -it coctohug-$imageName $imageName keys show
}

function ccVLog
{
    param ([string]$imageName)
    docker exec -it coctohug-$imageName tail -f /root/.$imageName/mainnet/log/debug.log
}

function ccDocker
{
    param ([string]$imageName)
    docker exec -it coctohug-$imageName /bin/bash
}

function ccClean
{
    docker image prune -a
}

function ccContainer
{
    docker ps -a
}

function ccImage
{
    docker images
}

if ($ActionName -eq 'install') {
  ccInstall $ActionParameter
} elseif ($ActionName -eq 'start') {
  ccStart $ActionParameter
} elseif ($ActionName -eq 'stop') {
  ccStop $ActionParameter
} elseif ($ActionName -eq 'restart') {
  ccReStart $ActionParameter
} elseif ($ActionName -eq 'upgrade') {
  ccUpgrade $ActionParameter
} elseif ($ActionName -eq 'upup') {
  ccUpUp $ActionParameter
} elseif ($ActionName -eq 'uninstall') {
  ccUnInstall $ActionParameter
} elseif ($ActionName -eq 'vconnection') {
  ccVConnection $ActionParameter
} elseif ($ActionName -eq 'vchain') {
  ccVChain $ActionParameter
} elseif ($ActionName -eq 'vsummary') {
  ccVSummary $ActionParameter
} elseif ($ActionName -eq 'vwallet') {
  ccVWallet $ActionParameter
} elseif ($ActionName -eq 'vkey') {
  ccVKey $ActionParameter
} elseif ($ActionName -eq 'vlog') {
  ccVLog $ActionParameter
} elseif ($ActionName -eq 'docker') {
  ccDocker $ActionParameter
} elseif ($ActionName -eq 'clean') {
  ccClean $ActionParameter
} elseif ($ActionName -eq 'container') {
  ccContainer $ActionParameter
} elseif ($ActionName -eq 'image') {
  ccImage $ActionParameter
}


