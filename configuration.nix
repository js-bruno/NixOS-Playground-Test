{ config, pkgs, callPackage, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./shell.nix
    ];
  environment.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };

  time.timeZone = "America/Fortaleza"; # <- Muito bom morar aqui

  services.radarr = { enable = true; openFirewall = true; };   #localhost:7878
  services.sonarr = { enable = true; openFirewall = true; };   #localhost:8989
  services.prowlarr = { enable = true; openFirewall = true; }; #localhost:9696
  services.jellyfin = { enable = true; openFirewall = true; }; #localhost:9696

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.interfaces.eth0.ipv4.addresses = [ { address = "192.168.1.99"; prefixLength = 24; } ];
  networking.defaultGateway = "192.168.1.1";
  networking.nameservers = [ "8.8.8.8" ];
  networking.useDHCP = false;

  # internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  services.xserver.displayManager.lightdm.enable = true;
  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw 
  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };
   
    displayManager = {
        defaultSession = "none+i3";
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3blocks #if you are planning on using i3blocks over i3status
     ];
    };
  };
  programs.i3lock.enable = true; #default i3 screen locker



  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;

  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lacon = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "lacon";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  programs.firefox.enable = true;

  environment.etc."series/readme.md".text = ''
	WELCOME
	TO MY CONFIG FILE
   '';

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka-term
    nerd-fonts.comic-shanns-mono
  ];
  environment.systemPackages = with pkgs; [
    lazygit
    git
    rofi
    stow
    zoxide
    librewolf
    vim
    alacritty
    tmux
    neovim
    wget
    dysk
    xclip

    qbittorrent
    radarr
    prowlarr
    sonarr
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg

  (python3.withPackages (python-pkgs: with python-pkgs; [
      pandas
      requests
  ]))
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
