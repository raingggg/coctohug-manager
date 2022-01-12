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

function ccInstall
{
    imageName=$1
    if [[ $imageName == "all" ]]; then
      for f in compose/*
      do
        echo "processing $f ..."
        docker-compose -f $f/docker-compose.yml pull
      done
    else
      docker-compose -f compose/$imageName/docker-compose.yml pull  
    fi
}

function ccStart
{
    imageName=$1
    if [[ $imageName == "all" ]]; then
      for f in compose/*
      do
        echo "processing $f ..."
        docker-compose -f $f/docker-compose.yml up -d
        echo "sleeping 5 minutes for saving computer resources, and next fork will be processed 5 minutes later..."
        echo `date +"%Y-%m-%d %T"`
        sleep 5m
      done
    else
      docker-compose -f compose/$imageName/docker-compose.yml up -d 
    fi
}

function ccStop
{
    imageName=$1
    if [[ $imageName == "all" ]]; then
      for f in compose/*
      do
        echo "processing $f ..."
        docker-compose -f $f/docker-compose.yml stop
      done
    else
      docker-compose -f compose/$imageName/docker-compose.yml stop  
    fi
}

function ccReStart
{
    imageName=$1
    if [[ $imageName == "all" ]]; then
      for f in compose/*
      do
        echo "processing $f ..."
        docker-compose -f $f/docker-compose.yml restart
        echo "sleeping 5 minutes for saving computer resources, and next fork will be processed 5 minutes later..."
        echo `date +"%Y-%m-%d %T"`
        sleep 5m
      done
    else
      docker-compose -f compose/$imageName/docker-compose.yml restart  
    fi
}

function ccUpgrade
{
    imageName=$1
    if [[ $imageName == "all" ]]; then
      for f in compose/*
      do
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

function ccUpUp
{
    imageName=$1
    if [[ $imageName == "all" ]]; then
      for f in compose/*
      do
        echo "processing $f ..."
        docker-compose -f $f/docker-compose.yml stop
        docker-compose -f $f/docker-compose.yml rm -f
        docker-compose -f $f/docker-compose.yml pull
        docker-compose -f $f/docker-compose.yml up -d
        echo "sleeping 5 minutes for saving computer resources, and next fork will be processed 5 minutes later..."
        echo `date +"%Y-%m-%d %T"`
        sleep 5m
      done
    else
      docker-compose -f compose/$imageName/docker-compose.yml stop
      docker-compose -f compose/$imageName/docker-compose.yml rm -f
      docker-compose -f compose/$imageName/docker-compose.yml pull  
      docker-compose -f compose/$imageName/docker-compose.yml up -d
    fi
}

function ccUnInstall
{
    imageName=$1
    if [[ $imageName == "all" ]]; then
      for f in compose/*
      do
        echo "processing $f ..."
        docker-compose -f $f/docker-compose.yml stop
        docker-compose -f $f/docker-compose.yml rm -f
      done
    else
      docker-compose -f compose/$imageName/docker-compose.yml stop
      docker-compose -f compose/$imageName/docker-compose.yml rm -f
    fi
}

function ccVConnection
{
    imageName=$1
    docker exec -it coctohug-$imageName $imageName show -c
}

function ccVChain
{
    imageName=$1
    docker exec -it coctohug-$imageName $imageName show -s
}

function ccVSummary
{
    imageName=$1
    docker exec -it coctohug-$imageName $imageName farm summary
}

function ccVWallet
{
    imageName=$1
    docker exec -it coctohug-$imageName $imageName wallet show
}

function ccVKey
{
    imageName=$1
    docker exec -it coctohug-$imageName $imageName keys show
}

function ccVLog
{
    imageName=$1
    docker exec -it coctohug-$imageName tail -f /root/.$imageName/mainnet/log/debug.log
}

function ccDocker
{
    imageName=$1
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