{pkgs,lib,...}:
{
  
  stylix.targets.helix.enable=false;
  stylix.targets.nixvim.enable=false;

stylix.image=../assets/wallpaper.jpg;
stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
	
}
