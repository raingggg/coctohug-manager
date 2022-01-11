allCaPath=~/.coctohug/farmer_ca/*

for f in $allCaPath
do
  fork=$(basename "$f")
  echo ""
  echo "processing $fork ..."

  home="~/.coctohug-${fork}"
  fca="~/.coctohug-${fork}/${fork}/farmer_ca/"
  
  if [[ ${fork} == "nchain" ]]; then
    fca="~/.coctohug-${fork}/farmer_ca/"
  fi

  if [ -f $home ]; then
    mkdir -p $fca
    cp -r $f/*.* $fca
    echo "$fork ca copied to $fca"
  else
    echo "$fork ingored - this fork is not available on your machine"
  fi

  # echo ${!fca}
  # docker-compose -f $f/docker-compose.yml up -d
done
