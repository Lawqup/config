# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    (import "${home-manager}/nixos")
  ];

  nixpkgs.config.allowUnfree = true;

  home-manager.users.lawrence =
    { lib, ... }:
    {
      # The home.stateVersion option does not have a default and must be set
      home.stateVersion = "18.09";

      home.file.".zshrc".source = /home/lawrence/config/zshrc;
      home.file.".config/alacritty/alacritty.toml".source = /home/lawrence/config/alacritty.toml;
      home.file.".xmobarrc".source = /home/lawrence/config/xmobarrc;
      home.file.".config/rofi/config.rasi".source = "/home/lawrence/config/rofi.rasi";

      home.activation = {
        tangleEmacsConfig = lib.hm.dag.entryAfter [ "installPackages" ] ''
          run emacs --batch --eval "(require 'org)" --eval '(org-babel-tangle-file "~/config/Emacs.org")'

          run touch ~/.emacs.d/custom.el
        '';
      };

      home.packages = with pkgs; [
        (catppuccin-kvantum.override {
          accent = "Blue";
          variant = "Macchiato";
        })
        libsForQt5.qtstyleplugin-kvantum
        libsForQt5.qt5ct
        papirus-folders
      ];

      gtk = {
        enable = true;
        theme = {
          name = "Catppuccin-Macchiato-Standard-Blue-Dark";
          package = pkgs.catppuccin-gtk.override {
            accents = [ "blue" ];
            size = "standard";
            variant = "macchiato";
          };
        };
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.catppuccin-papirus-folders.override {
            flavor = "macchiato";
            accent = "blue";
          };
        };
        cursorTheme = {
          name = "Catppuccin-Macchiato-Dark-Cursors";
          package = pkgs.catppuccin-cursors.macchiatoDark;
        };
        gtk3 = {
          extraConfig.gtk-application-prefer-dark-theme = true;
        };
      };

      home.pointerCursor = {
        gtk.enable = true;
        name = "Catppuccin-Macchiato-Dark-Cursors";
        package = pkgs.catppuccin-cursors.macchiatoDark;
        size = 16;
      };

      dconf.settings = {
        "org/gnome/desktop/interface" = {
          gtk-theme = "Catppuccin-Macchiato-Standard-Blue-Dark";
          color-scheme = "prefer-dark";
        };

        # For Gnome shell
        "org/gnome/shell/extensions/user-theme" = {
          name = "Catppuccin-Macchiato-Standard-Blue-Dark";
        };
      };

      # Wayland, X, etc. support for session vars
      systemd.user.sessionVariables = config.home-manager.users.lawrence.home.sessionVariables;
    };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "nixos"; # Define your hostname.

  networking.wireless = {
    enable = true;
    userControlled.enable = true;
    networks."QUP-13646-5G".pskRaw = "10527c4dbfc785564688c91507c452a61eff5407b297616238332802cb414e2a";
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    # keyMap = "us";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "ctrl:swapcaps";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lawrence = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    wget
    emacs
    alacritty
    firefox
    zsh
    oh-my-zsh
    xmobar
    killall
    rofi
    pipewire
    alsa-utils
    wirelesstools
    pwvucontrol
    fprintd
    usbutils
    nixfmt-rfc-style
    libsForQt5.dolphin
    dconf
    slock
    starship
    # gcc14
    # gnumake
    # cmake
    # libtool
  ];
  services.fprintd.enable = true;

  services.xserver = {

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = builtins.readFile /home/lawrence/config/xmonad.hs;
    };

    displayManager.sessionCommands = ''
      ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
         Xft.dpi: 192
         Xcursor.theme: Adwaita
         Xcursor.size: 64
      EOF
    '';

    # displayManager.sessionCommands = ''
    #   xset -dpms  # Disable Energy Star, as we are going to suspend anyway and it may hide "success" on that
    #   xset s blank # `noblank` may be useful for debugging 
    #   xset s 300 # seconds
    #   ${pkgs.lightlocker}/bin/light-locker --idle-hint &
    # '';
  };

  systemd.targets.hybrid-sleep.enable = true;
  services.logind.extraConfig = ''
    IdleAction=hybrid-sleep
    IdleActionSec=20s
  '';

  services.emacs.enable = true;

  programs.zsh = {
    enable = true;
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      jetbrains-mono
      font-awesome
      roboto
      hack-font
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Liberation Serif" ];
        sansSerif = [ "Ubuntu" ];
        monospace = [ "Jetbrains Mono" ];
      };
    };
  };

  services.xserver.dpi = 144;
  environment.variables = {
    GDK_SCALE = "1.5";
    GDK_DPI_SCALE = "0.7";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=1.5";
  };

  programs.steam.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}
