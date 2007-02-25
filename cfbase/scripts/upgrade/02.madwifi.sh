#!/bin/sh

modules="/etc/modules"

if [ -f "$modules" ]; then
	if grep -q '^ath_pci' "$modules" ; then
		if ! grep -q '^ath_rate' "$modules" ; then
			echo ""
			echo "It seems that you are using madwifi (found ath_pci in $modules)."
			echo "Madwifi now requires a rate module to be loaded and specified to ath_pci"
			echo "to work correctly."
			echo "To use madwifi's sample rate control module, just add ath_rate_sample"
			echo "to $modules, and be sure to issue 'savedata'. After it you can retry"
			echo "the upgrading procedure."
			echo ""
			exit 1
		fi
	fi
fi
