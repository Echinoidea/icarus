# rust with iced env flake template
{
  description = "icarus";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    rust-overlay,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      overlays = [(import rust-overlay)];
      pkgs = import nixpkgs {
        inherit system overlays;
        config = {
          permittedInsecurePackages = [];
          allowUnfree = true;
          allowUnfreePredicate = pkg: true;
        };
      };
      
      # Rust toolchain with rust-analyzer
      rustToolchain = pkgs.rust-bin.stable.latest.default.override {
        extensions = ["rust-src" "rust-analyzer"];
      };
      
      # Iced dependencies for different platforms
      icedDeps = with pkgs; [
        # Graphics libraries
        libGL
        libxkbcommon
        wayland
        
        # Font rendering
        fontconfig
        freetype
        
        # Additional dependencies
        vulkan-loader
        vulkan-headers
      ];
      
    in {
      devShells.default = pkgs.mkShell {
        name = "icarus";
        NIX_CONFIG = "experimental-features = nix-command flakes";
        
        shellHook = ''
          # Convenience commands
          alias run='cargo run'
          alias test='cargo test'
          alias build='cargo build'
          alias build-r='cargo build --release'
          alias exec='./target/release/icarus'
          
          # Set up library paths for iced
          export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath icedDeps}:$LD_LIBRARY_PATH"
          
          echo "Rust development environment with iced loaded!"
          echo "Available commands: run, test, build, build-r, exec"
        '';
        
        nativeBuildInputs = with pkgs; [
          rustToolchain
          cargo
          pkg-config
          
          # Formatters
          rustfmt
          
          # Debugger
          lldb
        ];
        
        buildInputs = with pkgs; [
          # Compiler tools
          gcc
          lld
          libcxx
          libgcc
          gnumake
        ] ++ icedDeps;
        
        # Environment variables for iced graphics
        RUST_SRC_PATH = "${rustToolchain}/lib/rustlib/src/rust/library";
      };
    });
}
