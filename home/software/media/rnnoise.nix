{pkgs, ...}: let
  json = pkgs.formats.json {};

  pw_rnnoise_config = {
    "context.modules" = [
      {
        "name" = "libpipewire-module-echo-cancel";
        "args" = {
          "source.props" = {
            "node.name" = "effect_input.rnnoise";
            "node.description" = "Noise Canceling source";
          };
          "sink.props" = {
            "node.name" = "effect_output.rnnoise";
            "node.description" = "Noise Canceling sink";
          };
          "aec.method" = "webrtc";
          "aec.args" = {
            "webrtc.noise-suppression" = true;
            "webrtc.echo-cancellation" = true;
          };
        };
      }
    ];
  };
in {
  xdg.configFile."pipewire/pipewire.conf.d/99-input-denoising.conf" = {
    source = json.generate "99-input-denoising.conf" pw_rnnoise_config;
  };
}
