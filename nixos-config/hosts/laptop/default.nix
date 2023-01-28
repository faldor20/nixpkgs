 {config, pkgs, ... }:
let
  unstable = import <nixos-unstable> {
    config.allowUnfree = true;
  };
  setupName="Laptop";
  ownPath=./. + "/default.nix";
in
{
  imports=
  [
    ../../common/common.nix
    ./hardware-configuration.nix
  ];

  #fileSystems."/mnt/shares/desktop"={
  #  device = "192.168.1.2:/share/main";
  #  fsType="nfs";
  #  options =["rw,user,exec,mode=7777,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s"];
  #};

  networking.hostName = "eli-nixos-yoga"; # Define your hostname.

  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };
  programs.nm-applet.enable = true;

  networking.interfaces.enp0s31f6.useDHCP = false;


  #--This enables caps2esc--
  # Map CapsLock to Esc on single press and Ctrl on when used with multiple keys.
    services.interception-tools = {
      enable = true;
     plugins = [ pkgs.interception-tools-plugins.caps2esc ];
     udevmonConfig =''
         - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc  | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
           DEVICE:
             EVENTS:
               EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
      '';
    };

   console = {
      useXkbConfig=true;
     };


  environment.systemPackages = with pkgs; [


  

    #======laptop======
    #
    tlp
    powertop
gnomeExtensions.gsconnect

    #
    #---endlaptop
  ];
  #=========================================laptop=========
  # services.clight={
  #  enable=true;
  #};
  


  boot.initrd.kernelModules = [ "i915" "thinkpad_acpi" ];
  #initrd.availableKernelModules=["thinkpad_acpi"];
#enables framebuffer compression which slightly speeds up intel Igpu
boot.kernelParams=["i915.enable_fbc=1"];
  hardware.cpu.intel.updateMicrocode=true;
  hardware.enableRedistributableFirmware=true;
  hardware.opengl.enable=true;
  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    intel-media-driver
  ];


  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

#stop throttling so damn much:

services.throttled.enable=true;
services.thinkfan={
  enable=false;
  levels=[
      [0  0   53]
      [1  47  55]
      [2  49  57]
      [3  50  58]
      [6  52  59]
      [7  55  68]
      ["level auto" 60 32767]
  ];
};
 services.tlp = {
      enable = true;
      # extraConfig = ''
      settings = {
        # Detailked info can be found https://linrunner.de/tlp/settings/index.html

        # Disables builtin radio devices on boot:
        #   bluetooth
        #   wifi – Wireless LAN (Wi-Fi)
        #   wwan – Wireless Wide Area Network (3G/UMTS, 4G/LTE, 5G)
        # DEVICES_TO_DISABLE_ON_STARTUP="bluetooth wifi"

        # When a LAN, Wi-Fi or WWAN connection has been established, the stated radio devices are disabled:
        #   bluetooth
        #   wifi – Wireless LAN
        #   wwan – Wireless Wide Area Network (3G/UMTS, 4G/LTE, 5G)
        # DEVICES_TO_DISABLE_ON_LAN_CONNECT="wifi wwan"
        # DEVICES_TO_DISABLE_ON_WIFI_CONNECT="wwan"
        # DEVICES_TO_DISABLE_ON_WWAN_CONNECT="wifi"

        # When a LAN, Wi-Fi, WWAN connection has been disconnected, the stated radio devices are enabled.
        # DEVICES_TO_ENABLE_ON_LAN_DISCONNECT="wifi wwan"
        # DEVICES_TO_ENABLE_ON_WIFI_DISCONNECT=""
        # DEVICES_TO_ENABLE_ON_WWAN_DISCONNECT=""

        # Set battery charge thresholds for main battery (BAT0) and auxiliary/Ultrabay battery (BAT1). Values are given as a percentage of the full capacity. A value of 0 is translated to the hardware defaults 96/100%.
        START_CHARGE_THRESH_BAT0=70;
        STOP_CHARGE_THRESH_BAT0=80;

        # Control battery feature drivers:
        NATACPI_ENABLE=1;
        TPACPI_ENABLE=1;
        TPSMAPI_ENABLE=1;

        # Defines the disk devices the following parameters are effective for. Multiple devices are separated with blanks.
        DISK_DEVICES="nvme0n1";

        # Set the “Advanced Power Management Level”. Possible values range between 1 and 255.
        #  1 – max power saving / minimum performance – Important: this setting may lead to increased disk drive wear and tear because of excessive read-write head unloading (recognizable from the clicking noises)
        #  128 – compromise between power saving and wear (TLP standard setting on battery)
        #  192 – prevents excessive head unloading of some HDDs
        #  254 – minimum power saving / max performance (TLP standard setting on AC)
        #  255 – disable APM (not supported by some disk models)
        #  keep – special value to skip this setting for the particular disk (synonym: _)
        DISK_APM_LEVEL_ON_AC="254 254";
        DISK_APM_LEVEL_ON_BAT="128 128";

        # Set the min/max/turbo frequency for the Intel GPU. Possible values depend on your hardware. See the output of tlp-stat -g for available frequencies.
        # INTEL_GPU_MIN_FREQ_ON_AC=0
        # INTEL_GPU_MIN_FREQ_ON_BAT=0
        # INTEL_GPU_MAX_FREQ_ON_AC=0
        # INTEL_GPU_MAX_FREQ_ON_BAT=0
        # INTEL_GPU_BOOST_FREQ_ON_AC=0
        # INTEL_GPU_BOOST_FREQ_ON_BAT=0

        # Selects the CPU scaling governor for automatic frequency scaling.
        # For Intel Core i 2nd gen. (“Sandy Bridge”) or newer Intel CPUs. Supported governors are:
        #  powersave – recommended (kernel default)
        #  performance
        # CPU_SCALING_GOVERNOR_ON_AC=powersave;
        # CPU_SCALING_GOVERNOR_ON_BAT=powersave;

        # Set Intel CPU energy/performance policy HWP.EPP. Possible values are
        #  performance
        #  balance_performance
        #  default
        #  balance_power
        #  power
        # for tlp-stat Version 1.3 and higher 'tlp-stat -p'
         CPU_ENERGY_PERF_POLICY_ON_AC="balance_performance";
         CPU_ENERGY_PERF_POLICY_ON_BAT="balance_power";

        # Set Intel CPU energy/performance policy HWP.EPP. Possible values are
        #   performance
        #   balance_performance
        #   default
        #   balance_power
        #   power
        # Version 1.2.2 and lower For version 1.3 and higher this parameter is replaced by CPU_ENERGY_PERF_POLICY_ON_AC/BAT
        # CPU_HWP_ON_AC=balance_performance;
        # CPU_HWP_ON_BAT=power;

        # Define the min/max P-state for Intel Core i processors. Values are stated as a percentage (0..100%) of the total available processor performance.
#        CPU_MIN_PERF_ON_AC=0;
 #       CPU_MAX_PERF_ON_AC=100;
  #      CPU_MIN_PERF_ON_BAT=0;
   #     CPU_MAX_PERF_ON_BAT=60;

        # Disable CPU “turbo boost” (Intel) or “turbo core” (AMD) feature (0 = disable / 1 = allow).
        CPU_BOOST_ON_AC=1;
       CPU_BOOST_ON_BAT=1;


        # Set Intel CPU energy/performance policy EPB. Possible values are (in order of increasing power saving):
        #   performance
        #   balance-performance
        #   default (deprecated: normal)
        #   balance-power
        #   power (deprecated: powersave)
        # Version 1.2.2 and lower For version 1.3 and higher this parameter is replaced by CPU_ENERGY_PERF_POLICY_ON_AC/BAT
        # ENERGY_PERF_POLICY_ON_AC=balance-performance;
        # ENERGY_PERF_POLICY_ON_BAT=power;

        # Timeout (in seconds) for the audio power saving mode (supports Intel HDA, AC97). A value of 0 disables power save.
        SOUND_POWER_SAVE_ON_AC=0;
        SOUND_POWER_SAVE_ON_BAT=1;

        # Controls runtime power management for PCIe devices.
        # RUNTIME_PM_ON_AC=on;
        # RUNTIME_PM_ON_BAT=auto;

        # Exclude PCIe devices assigned to listed drivers from runtime power management. Use tlp-stat -e to lookup the drivers (in parentheses at the end of each output line).
        # RUNTIME_PM_DRIVER_BLACKLIST="mei_me nouveau nvidia pcieport radeon"

        # Sets PCIe ASPM power saving mode. Possible values:
        #    default – recommended
        #    performance
        #    powersave
        #    powersupersave
        # PCIE_ASPM_ON_AC=default;
        # PCIE_ASPM_ON_BAT=default;
      #'';
      };
    };
 

  systemd.timers.suspend-on-low-battery = {
    wantedBy = [ "multi-user.target" ];
    timerConfig = {
      OnUnitActiveSec = "1020";
      OnBootSec= "1020";
    };
  };
  systemd.services.suspend-on-low-battery =
    let
      battery-level-sufficient = pkgs.writeShellScriptBin
        "battery-level-sufficient" ''
        test "$(cat /sys/class/power_supply/BAT0/status)" != Discharging \
          || test "$(cat /sys/class/power_supply/BAT0/capacity)" -ge 10
      '';
    in
      {
        serviceConfig = { Type = "oneshot"; };
        onFailure = [ "hibernate.target" ];
        script = "${battery-level-sufficient}/bin/battery-level-sufficient";
      };

}
