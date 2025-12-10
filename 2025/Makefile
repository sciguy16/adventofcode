.PHONY: vhdl-autogen

PACKETS_PKG_FILE := hdl/packet_types_pkg_hdr.vhd
PACKETDEFS_YAML := packetdefs.yaml

vhdl-autogen: $(PACKETS_PKG_FILE)
$(PACKETS_PKG_FILE): $(PACKETDEFS_YAML) $(shell find crates/types -type f)
	cargo r -p types -- $(PACKETS_PKG_FILE)
