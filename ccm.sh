#!/bin/env bash

# Github: https://github.com/raingggg/coctohug-manager

if [[ "$1" == "-h" || "$1" == "-help" || "$1" == "help" ]]; then
  echo "help:"
  echo "command guide: ccm help"

  echo
  echo "sample commands for the flora fork:"
  echo "install one fork such as flora: ccm install flora"
  echo "start one fork such as flora: ccm start flora"
  echo "stop one fork such as flora: ccm stop flora"
  echo "restart one fork such as flora: ccm restart flora"
  echo "upgrade one fork such as flora: ccm upgrade flora"
  echo "upgrade then start one fork such as flora: ccm upup flora"
  echo "uninstall one fork such as flora: ccm uninstall flora"
  echo 'migrate one fork db such as flora: ccm migrate-db "flora,/home/username/.flora/mainnet/db"'
  echo 'migrate one fork wallet-db such as flora: ccm migrate-wallet "flora,/home/username/.flora/mainnet/wallet/db"'

  echo
  echo "quick commands for all forks:"
  echo "install all forks: ccm install all"
  echo "start all forks: ccm start all"
  echo "stop all forks: ccm stop all"
  echo "restart all forks: ccm restart all"
  echo "upgrade all forks: ccm upgrade all"
  echo "upgrade then start all forks: ccm upup all"
  echo "uninstall all forks: ccm uninstall all"

  echo
  echo "24 mnemonic words:"
  # echo "import mnemonic words: ccm import-key 'flip display churn country relax else smoke hello holiday yard involve lab detect popular climb spirit emerge brush maple glimpse jelly cross ancient female'"
  echo "empty mnemonic words: ccm empty-key"

  echo
  echo "view detailed fork status:"
  echo "view connection info such as flora: ccm vconnection flora"
  echo "view farm summary info such as flora: ccm vsummary flora"
  echo "view wallet info such as flora: ccm vwallet flora"
  echo "view key info such as flora: ccm vkey flora"
  echo "view log info such as flora: ccm vlog flora"

  echo
  echo "go to docker/fork container:"
  echo "go inside docker such as flora: ccm docker flora"

  echo
  echo "docker management:"
  echo "clean all unused docker images: ccm clean"
  echo "show all docker containers: ccm container"
  echo "show all docker images: ccm image"

  exit 0
fi

sleepSeconds=60
fcount=$(grep -r 'fullnode' compose/*/docker-compose.yml | wc -l)
if [[ $fcount -gt 5 ]]; then
  sleepSeconds=300
fi
controllerIP=$(grep -o -m 1 'controller_address=.*' compose/*/docker-compose.yml | head -1 | sed 's/^.*controller_address=\(.*\)$/\1/g')

function ccInstall {
  imageName=$1
  if [[ $imageName == "all" ]]; then
    for f in compose/*; do
      echo "processing $f ..."
      docker-compose -f $f/docker-compose.yml pull
    done
  else
    docker-compose -f compose/$imageName/docker-compose.yml pull
  fi
}

function ccStart {
  imageName=$1
  if [[ $imageName == "all" ]]; then
    for f in compose/*; do
      echo "processing $f ..."
      docker-compose -f $f/docker-compose.yml up -d
      echo "sleeping $sleepSeconds seconds for saving computer resources, and next fork will be processed $sleepSeconds seconds later..."
      echo $(date +"%Y-%m-%d %T")
      sleep ${sleepSeconds}s
    done
  else
    docker-compose -f compose/$imageName/docker-compose.yml up -d
  fi

  curl --silent --output /dev/null http://${controllerIP}:12630/reviewWeb
  echo "Done. Please open browser with url http://${controllerIP}:12630 to watch the forks status - it might need around 30 minutes to fully load fork status"
}

function ccStop {
  imageName=$1
  if [[ $imageName == "all" ]]; then
    for f in compose/*; do
      echo "processing $f ..."
      docker-compose -f $f/docker-compose.yml stop
    done
  else
    docker-compose -f compose/$imageName/docker-compose.yml stop
  fi
}

function ccReStart {
  imageName=$1
  if [[ $imageName == "all" ]]; then
    for f in compose/*; do
      echo "processing $f ..."
      docker-compose -f $f/docker-compose.yml restart
      echo "sleeping $sleepSeconds seconds for saving computer resources, and next fork will be processed $sleepSeconds seconds later..."
      echo $(date +"%Y-%m-%d %T")
      sleep ${sleepSeconds}s
    done
  else
    docker-compose -f compose/$imageName/docker-compose.yml restart
  fi

  curl --silent --output /dev/null http://${controllerIP}:12630/reviewWeb
  echo "Done. Please open browser with url http://${controllerIP}:12630 to watch the forks status - it might need around 30 minutes to fully load fork status"
}

function ccUpgrade {
  imageName=$1
  if [[ $imageName == "all" ]]; then
    for f in compose/*; do
      echo "processing $f ..."
      docker-compose -f $f/docker-compose.yml stop
      docker-compose -f $f/docker-compose.yml rm -f
      docker-compose -f $f/docker-compose.yml pull
    done
  else
    docker-compose -f compose/$imageName/docker-compose.yml stop
    docker-compose -f compose/$imageName/docker-compose.yml rm -f
    docker-compose -f compose/$imageName/docker-compose.yml pull
  fi
}

function ccUpUp {
  imageName=$1
  if [[ $imageName == "all" ]]; then
    for f in compose/*; do
      echo "processing $f ..."
      docker-compose -f $f/docker-compose.yml stop
      docker-compose -f $f/docker-compose.yml rm -f
      docker-compose -f $f/docker-compose.yml pull
      docker-compose -f $f/docker-compose.yml up -d
      echo "sleeping $sleepSeconds seconds for saving computer resources, and next fork will be processed $sleepSeconds seconds later..."
      echo $(date +"%Y-%m-%d %T")
      sleep ${sleepSeconds}s
    done
  else
    docker-compose -f compose/$imageName/docker-compose.yml stop
    docker-compose -f compose/$imageName/docker-compose.yml rm -f
    docker-compose -f compose/$imageName/docker-compose.yml pull
    docker-compose -f compose/$imageName/docker-compose.yml up -d
  fi

  curl --silent --output /dev/null http://${controllerIP}:12630/reviewWeb
  echo "Done. Please open browser with url http://${controllerIP}:12630 to watch the forks status - it might need around 30 minutes to fully load fork status"
}

function ccUnInstall {
  imageName=$1
  if [[ $imageName == "all" ]]; then
    for f in compose/*; do
      echo "processing $f ..."
      docker-compose -f $f/docker-compose.yml stop
      docker-compose -f $f/docker-compose.yml rm -f
    done
  else
    docker-compose -f compose/$imageName/docker-compose.yml stop
    docker-compose -f compose/$imageName/docker-compose.yml rm -f
  fi
}

function ccMigrateDb {
  imageName="$(echo $1 | cut -d',' -f1)"
  folder="$(echo $1 | cut -d',' -f2)"
  mainnetPath=''
  if [[ ${imageName} == "chia" ]]; then
    mainnetPath=~/.coctohug-${imageName}/mainnet
  elif [[ $imageName == "silicoin" ]]; then
    mainnetPath=~/.coctohug-${imageName}/sit/mainnet
  elif [[ $imageName == "nchain" ]]; then
    mainnetPath=~/.coctohug-${imageName}/ext9
  else
    mainnetPath=~/.coctohug-${imageName}/${imageName}/mainnet
  fi

  docker-compose -f compose/$imageName/docker-compose.yml stop
  rm -fr $mainnetPath/db/*.*
  cp -r $folder/*.* $mainnetPath/db/
  docker-compose -f compose/$imageName/docker-compose.yml up -d

  curl --silent --output /dev/null http://${controllerIP}:12630/reviewWeb
  echo "Done. Please open browser with url http://${controllerIP}:12630 to watch the forks status - it might need around 30 minutes to fully load fork status"
}

function ccMigrateWallet {
  imageName="$(echo $1 | cut -d',' -f1)"
  folder="$(echo $1 | cut -d',' -f2)"
  mainnetPath=''
  if [[ ${imageName} == "chia" ]]; then
    mainnetPath=~/.coctohug-${imageName}/mainnet
  elif [[ $imageName == "silicoin" ]]; then
    mainnetPath=~/.coctohug-${imageName}/sit/mainnet
  elif [[ $imageName == "nchain" ]]; then
    mainnetPath=~/.coctohug-${imageName}/ext9
  else
    mainnetPath=~/.coctohug-${imageName}/${imageName}/mainnet
  fi

  docker-compose -f compose/$imageName/docker-compose.yml stop
  rm -fr $mainnetPath/wallet/db/*.*
  cp -r $folder/*.* $mainnetPath/wallet/db/
  docker-compose -f compose/$imageName/docker-compose.yml up -d

  curl --silent --output /dev/null http://${controllerIP}:12630/reviewWeb
  echo "Done. Please open browser with url http://${controllerIP}:12630 to watch the forks status - it might need around 30 minutes to fully load fork status"
}

function ccImportKey {
  keywords="$1"
  # echo "$keywords" > ~/.coctohug/mnc.txt
  # echo ""
  # echo "Imported. To use it, you may run 'ccm start flax' for flax fork"
}

function ccEmptyKey {
  echo '' >~/.coctohug/mnc.txt
}

function ccVConnection {
  imageName=$1
  docker exec -it coctohug-$imageName $imageName show -c
}

function ccVChain {
  imageName=$1
  docker exec -it coctohug-$imageName $imageName show -s
}

function ccVSummary {
  imageName=$1
  docker exec -it coctohug-$imageName $imageName farm summary
}

function ccVWallet {
  imageName=$1
  docker exec -it coctohug-$imageName $imageName wallet show
}

function ccVKey {
  imageName=$1
  docker exec -it coctohug-$imageName $imageName keys show
}

function ccVLog {
  imageName=$1
  docker exec -it coctohug-$imageName tail -f /root/.$imageName/mainnet/log/debug.log
}

function ccDocker {
  imageName=$1
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

ActionName=$1
ActionParameter=$2
if [[ ${ActionName} == "install" ]]; then
  ccInstall $ActionParameter
elif [[ $ActionName == "start" ]]; then
  ccStart $ActionParameter
elif [[ $ActionName == "stop" ]]; then
  ccStop $ActionParameter
elif [[ $ActionName == "restart" ]]; then
  ccReStart $ActionParameter
elif [[ $ActionName == "upgrade" ]]; then
  ccUpgrade $ActionParameter
elif [[ $ActionName == "upup" ]]; then
  ccUpUp $ActionParameter
elif [[ $ActionName == "uninstall" ]]; then
  ccUnInstall $ActionParameter
elif [[ $ActionName == "migrate-db" ]]; then
  ccMigrateDb $ActionParameter
elif [[ $ActionName == "migrate-wallet" ]]; then
  ccMigrateWallet $ActionParameter
# elif [[ $ActionName == "import-key" ]]; then
#   ccImportKey "$ActionParameter"
elif [[ $ActionName == "empty-key" ]]; then
  ccEmptyKey $ActionParameter
elif [[ $ActionName == "vconnection" ]]; then
  ccVConnection $ActionParameter
elif [[ $ActionName == "vchain" ]]; then
  ccVChain $ActionParameter
elif [[ $ActionName == "vsummary" ]]; then
  ccVSummary $ActionParameter
elif [[ $ActionName == "vwallet" ]]; then
  ccVWallet $ActionParameter
elif [[ $ActionName == "vkey" ]]; then
  ccVKey $ActionParameter
elif [[ $ActionName == "vlog" ]]; then
  ccVLog $ActionParameter
elif [[ $ActionName == "docker" ]]; then
  ccDocker $ActionParameter
elif [[ $ActionName == "clean" ]]; then
  ccClean $ActionParameter
elif [[ $ActionName == "container" ]]; then
  ccContainer $ActionParameter
elif [[ $ActionName == "image" ]]; then
  ccImage $ActionParameter
fi
