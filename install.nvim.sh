mkdir $HOME/.config
mkdir $HOME/.config/nvim

cp $HOME/.config/nvim/init.vim $HOME/.config/nvim/init.vim.backup
cp $HOME/.customize/nvim/init.vim $HOME/.config/nvim/init.vim

cp -r $HOME/.customize/nvim/colors $HOME/.config/nvim/
cp -r $HOME/.customize/nvim/after $HOME/.config/nvim/
echo "nvim plugins & colors installed! open nvim and run InstallPlugins"
