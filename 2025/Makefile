.PHONY: vhdl-autogen fmt vsg test save load .FORCE

PACKETS_PKG_FILE := hdl/packet_types_pkg_hdr.vhd
PACKETDEFS_YAML := packetdefs.yaml
VSG_ARGS :=
VSG_ARGS += --configuration vsg.yaml
VSG_ARGS += --output_format syntastic
VSG_ARGS += --fix

PROJ_INIT_TCL := init_project.tcl
VIVADO_PROJ := vivado/aoc-2025.xpr

vhdl-autogen: $(PACKETS_PKG_FILE)
$(PACKETS_PKG_FILE): $(PACKETDEFS_YAML) $(shell find crates/types -type f)
	cargo r -p types -- $(PACKETS_PKG_FILE)

fmt: vsg
vsg: .FORCE
	vsg $(VSG_ARGS)

test: .FORCE
	echo "TODO run testbenches"

save: $(PROJ_INIT_TCL)
$(PROJ_INIT_TCL): $(VIVADO_PROJ)
	echo "TODO store init tcl script"

load: $(VIVADO_PROJ)
$(VIVADO_PROJ): $(PROJ_INIT_TCL)
	echo "TODO load init tcl script into new proj"

clean:
	echo "TODO clean up vivado project files"

clean-hw:
	rm -rfv vivado/aoc-2025.hw/hw_1

.FORCE:
