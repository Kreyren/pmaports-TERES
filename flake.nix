{
	description = "pmports on flakes with development environment";

	inputs = {
		# Release inputs
		nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11"; # Stable
		nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

		# Principle inputs
		nixos-flake.url = "github:srid/nixos-flake";
		flake-parts.url = "github:hercules-ci/flake-parts";
		mission-control.url = "github:Platonic-Systems/mission-control";
		flake-root.url = "github:srid/flake-root";
	};

	outputs = inputs @ { self, ... }:
		inputs.flake-parts.lib.mkFlake { inherit inputs; } {
			imports = [
				inputs.flake-root.flakeModule
				inputs.mission-control.flakeModule
			];

			systems = [ "x86_64-linux" "aarch64-linux" "riscv64-linux" ];

			perSystem = { system, config, ... }: {
				mission-control.scripts = {
					# Editors
					vscodium = {
						description = "VSCodium (Fully Integrated)";
						category = "Integrated Editors";
						exec = "${inputs.nixpkgs-unstable.legacyPackages.${system}.vscodium}/bin/codium ./default.code-workspace";
					};
					vim = {
						description = "vIM (Minimal Integration, fixme)";
						category = "Integrated Editors";
						exec = "${inputs.nixpkgs.legacyPackages.${system}.vim}/bin/vim .";
					};
					neovim = {
						description = "Neovim (Minimal Integration, fixme)";
						category = "Integrated Editors";
						exec = "${inputs.nixpkgs.legacyPackages.${system}.neovim}/bin/nvim .";
					};
					emacs = {
						description = "Emacs (Minimal Integration, fixme)";
						category = "Integrated Editors";
						exec = "${inputs.nixpkgs.legacyPackages.${system}.emacs}/bin/emacs .";
					};
					# Code Formating
					nixpkgs-fmt = {
						description = "Format Nix Files With The Standard Nixpkgs Formater";
						category = "Code Formating";
						exec = "${inputs.nixpkgs.legacyPackages.${system}.nixpkgs-fmt}/bin/nixpkgs-fmt .";
					};
					alejandra = {
						description = "Format Nix Files With The Uncompromising Nix Code Formatter (Not Recommended)";
						category = "Code Formating";
						exec = "${inputs.nixpkgs.legacyPackages.${system}.alejandra}/bin/alejandra .";
					};
				};
				devShells.default = inputs.nixpkgs.legacyPackages.${system}.mkShell {
					name = "pmports-devshell";
					nativeBuildInputs = [
						inputs.nixpkgs.legacyPackages.${system}.nil # Needed for linting
						inputs.nixpkgs.legacyPackages.${system}.nixpkgs-fmt # Nixpkgs formatter
						inputs.nixpkgs.legacyPackages.${system}.git # Working with the codebase
						inputs.nixpkgs.legacyPackages.${system}.shellcheck # Linting shell scripts
						inputs.nixpkgs.legacyPackages.${system}.pmbootstrap # Managing the codebase
					];
					inputsFrom = [ config.mission-control.devShell ];
				};

				formatter = inputs.nixpkgs.nixpkgs-fmt;
			};
		};
}
