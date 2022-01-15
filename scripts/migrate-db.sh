#!/bin/env bash

input=~/.coctohug/db.txt

while IFS= read -r line
do
  echo ""
  if [[ $line = \#* ]] ; then
    echo "skip line: $line "
  else
    echo "processing line: $line "
    fork="$(echo $line | cut -d':' -f1)"
    folder="$(echo $line | cut -d':' -f2)"

    forkName="$(echo $fork | cut -d'|' -f1)"
    dbType="$(echo $fork | cut -d'|' -f2)"

    if [[ -n "$forkName" && -n "$dbType" && -n "$folder" ]] ; then
      mainnetPath=''
      if [[ ${forkName} == "chia" ]]; then
        mainnetPath=~/.coctohug-${forkName}/mainnet
      elif [[ $forkName == "silicoin" ]]; then
        mainnetPath=~/.coctohug-${forkName}/sit/mainnet
      elif [[ $forkName == "nchain" ]]; then
        mainnetPath=~/.coctohug-${forkName}/ext9
      else
        mainnetPath=~/.coctohug-${forkName}/${forkName}/mainnet
      fi

      if [[ ${dbType} == "db" ]]; then
        if [ -n "$(find "$mainnetPath/db/blockchain_v1_mainnet.sqlite" -size +1G)" ]; then
          echo "NOT copying - because $mainnetPath/db/blockchain_v1_mainnet.sqlite is bigger than 1G"
        else
          echo "copying from $folder/*.* to $mainnetPath/db/"
          rm -fr $mainnetPath/db/*.*
          cp -r $folder/*.* $mainnetPath/db/
        fi
      elif [[ $dbType == "wallet" ]]; then
        if [ -n "$(find "$mainnetPath/wallet/db/blockchain_*.sqlite" -size +1G)" ]; then
          echo "NOT copying - because $mainnetPath/wallet/db/blockchain_*.sqlite is bigger than 1G"
        else
          echo "copying from $folder/*.* to $mainnetPath/wallet/db/"
          rm -fr $mainnetPath/wallet/db/*.*
          cp -r $folder/*.* $mainnetPath/wallet/db/
        fi
      fi
    fi
  fi
done < "$input"
