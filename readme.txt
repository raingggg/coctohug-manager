# setup
- Open terminal and change working directory to the folder contains ccm.sh
- (Linux / Mac)Init ccm by creating link: sudo ln -s /full/path/to/your/file/ccm.sh /usr/local/bin/ccm

# help
- command guide: ccm help

# sample commands for the flora fork
- install one fork such as flora: ccm install flora
- start one fork such as flora: ccm start flora
- stop one fork such as flora: ccm stop flora
- restart one fork such as flora: ccm restart flora
- upgrade one fork such as flora: ccm upgrade flora
- upgrade then start one fork such as flora: ccm upup flora
- uninstall one fork such as flora: ccm uninstall flora
- migrate one fork db such as flora: ccm migrate-db "flora,/home/username/.flora/mainnet/db"
- migrate one fork wallet-db such as flora: ccm migrate-wallet "flora,/home/username/.flora/mainnet/wallet/db"

# quick commands for all forks
- install all forks: ccm install all
- start all forks: ccm start all
- stop all forks: ccm stop all
- restart all forks: ccm restart all
- upgrade all forks: ccm upgrade all
- upgrade then start all forks: ccm upup all
- uninstall all forks: ccm uninstall all

# view detailed fork status
- view connection info such as flora: ccm vconnection flora
- view farm summary info such as flora: ccm vsummary flora
- view wallet info such as flora: ccm vwallet flora
- view key info such as flora: ccm vkey flora
- view log info such as flora: ccm vlog flora


# go to docker/fork container
- go inside docker such as flora: ccm docker flora


# docker management
- clean all unused docker images: ccm clean
- show all docker containers: ccm container
- show all docker images: ccm image

# more
- [Github](https://github.com/raingggg/coctohug-manager)