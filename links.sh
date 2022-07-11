#This links the neovim config in here to te neovim config out there
ln -s "/home/eli/.config/nixpkgs/config/nvim" ~/.config/nvim
ln -s "/home/eli/.config/nixpkgs/config/.doom.d" ~/.doom.d
ln -s "/home/eli/.config/nixpkgs/config/waybar" ~/.config/waybar
#must make an mpd data directory
mkdir ~/.mpd
mkdir ~/.mpd/data
mkdir ~/.mpd/data/playlists
