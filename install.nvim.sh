cp $HOME/.config/nvim/init.vim $HOME/.config/nvim/init.vim.backup && \
cp $HOME/.customize/nvim/init.vim $HOME/.config/nvim/init.vim

cp -r $HOME/.customize/nvim/colors $HOME/.config/nvim/
echo "nvim plugins & colors installed! open nvim and run InstallPlugins"