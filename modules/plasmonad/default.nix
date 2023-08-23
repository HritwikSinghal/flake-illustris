{ self, ... }:
{ config, lib, pkgs, ... }:
with lib;
{
	services.xserver = {
		enable = true;
		displayManager = {
			defaultSession = "plasma";
			sddm.enable = true;
		};
		desktopManager.plasma5.enable = true;
		windowManager = {
			xmonad = {
				enable = true;
				enableContribAndExtras = true;
				config = builtins.readFile ./config.hs;
			};
		};
	};

	systemd.user.services = {
		plasma-custom-wm = {
			wantedBy = [ "plasma-workspace.target" ];
			before = [ "plasma-workspace.target" ];
			script = "unset __NIXOS_SET_ENVIRONMENT_DONE && . /run/current-system/etc/profile && xmonad";
			serviceConfig.Slice = "session.slice";
		};
		plasma-kwin_x11.enable = false;
	};
}
