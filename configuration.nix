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
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz";
in
{
  imports = [
    # Include the results of the hardware scan.
    <nixos-hardware/framework/13-inch/7040-amd>
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
      home.file.".config/starship.toml".source = "/home/lawrence/config/starship.toml";
      home.file.".config/nvim" = {
        source = "/home/lawrence/config/nvim";
        recursive = true;
      };

      home.file.".tmux.conf".source = "/home/lawrence/config/tmux.conf";
      home.file.".config/wezterm/wezterm.lua".source = "/home/lawrence/config/wezterm.lua";

      home.activation = {
        # tangleEmacsConfig = lib.hm.dag.entryAfter [ "installPackages" ] ''
        #   run emacs --batch --eval "(require 'org)" --eval '(org-babel-tangle-file "~/config/Emacs.org")'
        #
        #   run touch ~/.emacs.d/custom.el
        # '';

        setupKB = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          run /home/lawrence/config/scripts/remap_kb.sh
        '';
      };

      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
      };

      programs.starship.enable = true;

      services.dunst = {
        enable = true;
        configFile = "/home/lawrence/config/dunstrc";
      };
    };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.networkmanager.enable = true;
  networking.hostName = "nixos"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    # keyMap = "us";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";

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

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;

  hardware.brillo.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  services.libinput.touchpad = {
    tapping = true;
    tappingButtonMap = "lrm";
  };

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

  users.defaultUserShell = pkgs.zsh;

  services.physlock.enable = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    git
    wget
    firefox
    xmobar
    killall
    rofi
    pipewire
    alsa-utils
    wirelesstools
    pwvucontrol
    fprintd
    libfprint
    usbutils
    nixfmt-rfc-style
    libsForQt5.dolphin
    dconf
    arandr
    autorandr
    acpi
    inetutils
    eza
    libnotify
    dunst
    fd
    jdk8
    discord
    godot_4
    wezterm
    tmux
    gcc14
    cmake
    gnumake
    direnv
    cargo
    rust-analyzer
    htop
    # libtool
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="amdgpu_bl1", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
  '';

  services.fprintd.enable = true;

  programs.gamemode.enable = true;

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [
        "eza"
        "fzf"
        "zsh-autosuggestions"
      ];
    };
  };

  services.xserver = {
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = builtins.readFile /home/lawrence/config/xmonad.hs;
    };
    dpi = 144;
    displayManager.sessionCommands = ''
      ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
         Xft.dpi: 192
         Xcursor.theme: Adwaita
         Xcursor.size: 20
      EOF
    '';

    # displayManager.sessionCommands = ''
    #   xset -dpms  # Disable Energy Star, as we are going to suspend anyway and it may hide "success" on that
    #   xset s blank # `noblank` may be useful for debugging 
    #   xset s 300 # seconds
    #   ${pkgs.lightlocker}/bin/light-locker --idle-hint &
    # '';
  };
  environment.variables = {
    GDK_SCALE = "1.5";
    GDK_DPI_SCALE = "0.7";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=1.5";
  };

  systemd.targets.hybrid-sleep.enable = true;
  services.logind.extraConfig = ''
    IdleAction=hybrid-sleep
    IdleActionSec=20s
  '';

  # services.emacs = {
  #   enable = true;
  #   package = pkgs.emacs;
  # };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
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

  programs.steam.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  services.fwupd.enable = true;

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
