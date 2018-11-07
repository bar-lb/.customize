cp $HOME/.config/nvim/nvim.init $HOME/.config/nvim/nvim.init.backup && \
cp $HOME/.custimize/nvim/nvim_init $HOME/.config/nvim/nvim.init

cp -r $HOME/.custimize/nvim/colors $HOME/.config/nvim/colors
echo "nvim plugins & colors installed! open nvim and run InstallPlugins"
