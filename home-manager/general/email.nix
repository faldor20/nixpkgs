{ config, lib, pkgs, ... }:
{
  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  #programs.lieer.enable = true;
  services.lieer={enable=true;
                 };
  programs.notmuch = {
    enable = true;
    hooks = {
      preNew = "gmi sync";
	  postNew= ''
	  	notmuch tag +gumtree -- tag:new and from:*@gumtree.com.au
	  '';
    };
};
  programs.astroid={
enable = true;
pollScript= "gmi sync";
externalEditor= "st -f 'Monospace' -w %3 -e nvim %1";
	
  };
  accounts.email = {
    maildirBasePath="mail";
    accounts.eli-gmail = {
      address = "eli.jambu@gmail.com";
 #     gpg = {
  #      key = "F9119EC8FCC56192B5CF53A0BF4F64254BD8C8B5";
   #     signByDefault = true;
    #  };
      flavor="gmail.com";
    #  imap.host = "imap.gmail.com";
      # mbsync = {
      #   enable = true;
      #   create = "maildir";
      # };
      lieer.sync={
        enable=true;
      };
      notmuch.enable = true;
      primary = true;
      realName = "Eli Dowling";
      signature = {
        text = ''
        '';
        showSignature = "append";
      };
      passwordCommand = "echo Whyskeyjack9th";#"cat ~/secrets/emailPassword";
   #   smtp = {
   #     host = "smtp.gmail.com";
   #   };
      userName = "eli.jambu@gmail.com";
    };
	};
}
