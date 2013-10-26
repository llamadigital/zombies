#!/bin/bash

# ssh
cp -fv /home/master/.ssh/*id_rsa* /home/vagrant/.ssh
chown -Rv vagrant:vagrant /home/vagrant/.ssh

# dotfiles
ln -fvs /home/master/dotfiles/vimrc /home/vagrant/.vimrc
ln -fvs /home/master/dotfiles/tmux.conf /home/vagrant/.tmux.conf
ln -fvs /home/master/dotfiles/bash_profile /home/vagrant/.bash_profile
ln -fvs /home/master/dotfiles/bashrc /home/vagrant/.bashrc
ln -fvs /home/master/dotfiles/ackrc /home/vagrant/.ackrc
ln -fvs /home/master/dotfiles/vim /home/vagrant/.vim
ln -fvs /home/master/dotfiles/bash /home/vagrant/.bash
ln -fvs /home/master/dotfiles/gitignore /home/vagrant/.gitignore
ln -fvs /home/master/dotfiles/tmx /home/vagrant/.tmx
ln -fvs /home/master/.gitconfig /home/vagrant/.gitconfig

