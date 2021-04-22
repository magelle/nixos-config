# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-20.09.tar.gz}/nixos")
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
  };

  # Enable the GNOME 3 Desktop Environment.
  services.xserver = {
    enable = true;
    layout = "fr";
    displayManager.gdm.enable = true;
    desktopManager = {
      gnome3.enable = true;
      xterm.enable = true;
    };
  };
  
  # Configure keymap in X11
  # services.xserver.layout = "fr";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = "/run/current-system/sw/bin/zsh";
  users.users.max = {
    isNormalUser = true;
    shell = "/run/current-system/sw/bin/zsh";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.*
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # CLI tools
    terminator
    wget jq 
    zsh oh-my-zsh fzf
    htop exa bat
    unzip
    
    # Nix tools
    dconf2nix
    
    # Desktop
    firefox mailspring
    libreoffice wpsoffice
     #    masterpdfeditor
    vlc xsane baobab gimp
    obs-studio typora transmission
    # Gnome
    gnome-themes-extra
    gnome3.dconf-editor
    gnome3.gnome-tweak-tool
    gnome3.gnome-shell-extensions
    gnome3.gnome-bluetooth
    
    gnomeExtensions.sound-output-device-chooser
    gnomeExtensions.system-monitor
    #gnomeExtensions.topicons-plus
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.appindicator
    
    # Dev Tools
    git
    yarn
    vscode
    slack
    skype
    elixir 
    jetbrains.webstorm
    jetbrains.idea-ultimate
    jetbrains.phpstorm
    jetbrains.rider
    
    # Dev languages
    openjdk maven
    
    # La foncière
    teams
    docker docker-compose helmfile kubectl kubectx
    postman
    
  ];
  
  environment.gnome3.excludePackages = with pkgs; [ 
    gnome3.epiphany
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      ohMyZsh = {
        enable = true;
        plugins = [ 
          "sudo" "git" "systemd" "common-aliases" "compleat" "zsh-interactive-cd"
          "git-flow" "yarn" "mvn" "npm" "docker" "docker-compose" "kubectl"
          "kube-ps1" "helm"
         ];
        theme = "agnoster";
      };
      shellAliases = {
        nixos-rebuild="sudo nixos-rebuild";
        systemctl="sudo systemctl";
        cat="bat";
        less="bat";
        dotnet="TERM=xterm dotnet";
        lfn="kubeon && cd /home/max/workspace/lafoncierenumerique";
        ls="exa";
        top="htop";
        nix-dconf="dconf dump / | dconf2nix";

        kubectl="kubeon && kubectl";
        kubectx="kubeon && kubectx";
        kubens="kubeon && kubens";

        # https://www.atlassian.com/git/tutorials/dotfiles
        config="git --git-dir=$HOME/.cfg/ --work-tree=$HOME";
      };
    };
    geary.enable = false; # replaced by mailspring
    gnome-terminal.enable = false; # replaced by terminator
  };

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
  system.stateVersion = "20.09"; # Did you read the comment?

  home-manager.useGlobalPkgs = true;
  home-manager.users.max = { pkgs, ... }: {
    dconf.settings = {
    
      "org/gnome/shell" = {
        "disabled-extensions" = [ "apps-menu@gnome-shell-extensions.gcampax.github.com" ];
        "enabled-extensions" = [ "system-monitor@paradoxxx.zero.gmail.com" "appindicatorsupport@rgcjonas.gmail.com" "clipboard-indicator@tudmotu.com" "sound-output-device-chooser@kgshank.net" ];
        "favorite-apps" = [ "terminator.desktop" "firefox.desktop" "mailspring.desktop" "teams.desktop" "org.gnome.Nautilus.desktop" "code.desktop" "idea-ultimate.desktop" "webstorm.desktop" ];
      };
      
      "org/gnome/shell/extensions/system-monitor" = {
        "compact-display" = false;
        "cpu-show-text" = false;
        "cpu-style" = "digit";
        "disk-style" = "digit";
        "disk-usage-style" = "bar";
        "icon-display" = false;
        "memory-show-text" = false;
        "memory-style" = "digit";
        "net-display" = false;
        "net-style" = "digit";
      };
      
      "org/gnome/gedit/preferences/editor" = {
        "scheme" = "oblivion";
        "wrap-last-split-mode" = "word";
      };
      
      "org/gnome/desktop/interface" = {
        "gtk-im-module" = "gtk-im-context-simple";
        "gtk-theme" = "Adwaita-dark";
      };
      
      "org/gnome/desktop/app-folders" = {
        "folder-children" = [ "94e92d2f-23e4-467b-84f6-0c974e7f4057" "c1b76ed6-b5db-4acf-80ce-8a4c25ddef5e" "9d72e3c0-a4cb-45fe-8584-17eb9ac6daa3" "5fa5ad4e-91c6-487d-b6a9-d2188b102222" "a30138cf-bb3b-4fa5-8906-a02d2cc039e7" "41721417-c8cf-4aea-86cb-1daae4a0d006" "55275419-b25d-44b0-b97c-9302cf52c675" "2c957890-e1d8-446a-9275-3743d401d2b1" ];
    };

      "org/gnome/desktop/app-folders/folders/2c957890-e1d8-446a-9275-3743d401d2b1" = {
        "apps" = [ "org.gnome.Extensions.desktop" "gnome-control-center.desktop" "org.gnome.tweaks.desktop" ];
        "name" = "Parametres";
        "translate" = false;
      };

      "org/gnome/desktop/app-folders/folders/41721417-c8cf-4aea-86cb-1daae4a0d006" = {
        "apps" = [ "org.gnome.DiskUtility.desktop" "org.gnome.Calculator.desktop" "org.gnome.Characters.desktop" "nixos-manual.desktop" "org.gnome.seahorse.Application.desktop" "org.gnome.font-viewer.desktop" "yelp.desktop" "org.gnome.baobab.desktop" "gnome-system-monitor.desktop" "htop.desktop" "org.gnome.clocks.desktop" "org.gnome.FileRoller.desktop" "org.gnome.Weather.desktop" ];
        "name" = "Accessoires";
      };

      "org/gnome/desktop/app-folders/folders/55275419-b25d-44b0-b97c-9302cf52c675" = {
        "apps" = [ "org.gnome.Logs.desktop" "cups.desktop" "ca.desrt.dconf-editor.desktop" ];
        "name" = "Systeme";
        "translate" = false;
      };

      "org/gnome/desktop/app-folders/folders/5fa5ad4e-91c6-487d-b6a9-d2188b102222" = {
        "apps" = [ "slack.desktop" "skypeforlinux.desktop" "mailspring.desktop" "firefox.desktop" "teams.desktop" ];
        "name" = "Internet";
      };

      "org/gnome/desktop/app-folders/folders/94e92d2f-23e4-467b-84f6-0c974e7f4057" = {
        "apps" = [ "startcenter.desktop" "writer.desktop" "base.desktop" "calc.desktop" "draw.desktop" "impress.desktop" "math.desktop" ];
        "name" = "Bureautique";
      };

      "org/gnome/desktop/app-folders/folders/9d72e3c0-a4cb-45fe-8584-17eb9ac6daa3" = {
        "apps" = [ "phpstorm.desktop" "rider.desktop" "code.desktop" "webstorm.desktop" "idea-ultimate.desktop" "postman.desktop" ];
        "name" = "Programmation";
      };

      "org/gnome/desktop/app-folders/folders/a30138cf-bb3b-4fa5-8906-a02d2cc039e7" = {
        "apps" = [ "org.gnome.Totem.desktop" "org.gnome.Music.desktop" "org.gnome.Photos.desktop" "com.obsproject.Studio.desktop" "gimp.desktop" "xsane.desktop" "simple-scan.desktop" "org.gnome.Evince.desktop" "org.gnome.eog.desktop" "vlc.desktop" "org.gnome.Cheese.desktop" ];
        "name" = "Son et vidéo";
      };

      "org/gnome/desktop/app-folders/folders/c1b76ed6-b5db-4acf-80ce-8a4c25ddef5e" = {
        "apps" = [ "wps-office-prometheus.desktop" "wps-office-pdf.desktop" "wps-office-wpp.desktop" "wps-office-et.desktop" "wps-office-wps.desktop" ];
        "name" = "Bureautique";
      };

    };
  };

}

