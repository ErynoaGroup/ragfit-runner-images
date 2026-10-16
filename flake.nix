{
  description = "RagFit | Runner Images – Reproducible Cosign-signed Nix OCI Job & Agent Container Images";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      linuxSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAll = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
      forLinux = f: nixpkgs.lib.genAttrs linuxSystems (system: f system nixpkgs.legacyPackages.${system});
    in
    {
      packages = forLinux (system: pkgs:
        let
          base = pkgs.dockerTools.buildLayeredImage {
            name = "ghcr.io/erynoagroup/ragfit-runner-base";
            tag = "0.1.0";
            contents = [
              pkgs.bashInteractive
              pkgs.coreutils
              pkgs.gitMinimal
              pkgs.cacert
              pkgs.curl
              pkgs.jq
            ];
            config = {
              User = "1000:1000";
              WorkingDir = "/work";
              Cmd = [ "${pkgs.bashInteractive}/bin/bash" ];
              Env = [
                "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
                "NIX_SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
              ];
              Labels = {
                "org.opencontainers.image.title" = "RagFit | Runner Images (base)";
                "org.opencontainers.image.description" = "Reproducible Nix OCI base job image for RagFit | Runner";
                "org.opencontainers.image.licenses" = "Apache-2.0";
              };
            };
          };
          agent-worker = pkgs.dockerTools.buildLayeredImage {
            name = "ghcr.io/erynoagroup/ragfit-runner-agent-worker";
            tag = "0.1.0";
            contents = [
              pkgs.bashInteractive
              pkgs.coreutils
              pkgs.gitMinimal
              pkgs.cacert
              pkgs.curl
              pkgs.jq
              pkgs.ripgrep
            ];
            config = {
              User = "1000:1000";
              WorkingDir = "/work";
              Cmd = [ "${pkgs.bashInteractive}/bin/bash" ];
              Env = [
                "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
                "NIX_SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
                "RAGFIT_SANDBOX_ROLE=agent-worker"
              ];
              Labels = {
                "org.opencontainers.image.title" = "RagFit | Runner Images (agent-worker)";
                "org.opencontainers.image.description" = "Lightweight Nix OCI sandbox image for ragfit-agent and atlasd execution";
                "org.opencontainers.image.licenses" = "Apache-2.0";
              };
            };
          };
        in
        {
          inherit base agent-worker;
          container = self.packages.${system}.base;
          image = self.packages.${system}.base;
          default = self.packages.${system}.base;
        }
      );

      devShells = forAll (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [ just git shellcheck gitleaks hadolint cosign jq ];
        };
      });

      formatter = forAll (pkgs: pkgs.nixfmt);
    };
}
