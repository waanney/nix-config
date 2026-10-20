{...}: {
  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = false;
  };

  # During a switch, VirtualBox removes and recreates vboxnet0.  Ensure the
  # generated address unit does not race the service that creates the device.
  systemd.services."network-addresses-vboxnet0" = {
    requires = ["vboxnet0.service"];
    after = ["vboxnet0.service"];
  };
}
