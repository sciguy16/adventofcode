.PHONY: vhdl-autogen fmt vsg .FORCE

PACKETS_PKG_FILE := hdl/packet_types_pkg_hdr.vhd
PACKETDEFS_YAML := packetdefs.yaml
VSG_ARGS := --style jcl --configuration vsg.yaml --fix

vhdl-autogen: $(PACKETS_PKG_FILE)
$(PACKETS_PKG_FILE): $(PACKETDEFS_YAML) $(shell find crates/types -type f)
	cargo r -p types -- $(PACKETS_PKG_FILE)

fmt: vsg
vsg: .FORCE
	vsg $(VSG_ARGS)

.FORCE:
