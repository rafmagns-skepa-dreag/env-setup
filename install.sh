#!/bin/bash

INSTALLER=""

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  INSTALLER="apt install -y"
  PYENV_INSTALL="curl https://pyenv.run | /bin/bash"
  apt update
  apt upgrade -y
  $INSTALLER software-properties-common
  source /etc/lsb-release
  echo $DISTRIB_RELEASE
  if [[ $(eval "python3 -c \"print(int($DISTRIB_RELEASE > 18))\"") -eq 1 ]]; then
      $INSTALLER ripgrep neovim
  else
      add-apt-repository -y ppa:neovim-ppa/stable
      apt update
      $INSTALLER neovim
  fi

elif [[ "$OSTYPE" == "darwin" ]]; then
  xcode-select --install
  INSTALLER="brew install"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  PYENV_INSTALL="brew install pyenv"
else
  echo "unkown platform. Exiting"
  exit 1
fi

$INSTALLER curl zsh powerline tmux git

# Install pyenv
eval $PYENV_INSTALL

# Install poetry
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3

# Install vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Install rustup
# TODO fix this to install for user and not root
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Move config files to appropriate places
mkdir -p ~/.config/nvim
mv ./init.vim ~/.config/nvim/
mv ./.tmux.conf ~/
mv ./.zshrc ~/
mv ./.python_history.py ~/

git config --global --add user.username rafmagns-skepa-dreag
git config --global --add user.email rafmagns-skepa-dreag@users.noreply.github.com

# Install OMZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
