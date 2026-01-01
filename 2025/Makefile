.PHONY: vhdl-autogen fmt vsg test lint save load .FORCE

PACKETS_PKG_FILE := hdl/packet_types_pkg_hdr.vhd
PACKETDEFS_YAML := packetdefs.yaml
VSG_ARGS :=
VSG_ARGS += --configuration vsg.yaml
VSG_ARGS += --output_format syntastic
VSG_ARGS += --fix

PROJ_INIT_TCL := init_project.tcl
VIVADO_PROJ := vivado/aoc-2025.xpr

VIVADO := /opt/xilinx/2025.2/Vivado/bin/vivado
export LIBRARY_PATH := /usr/lib/x86_64-linux-gnu:$(LIBRARY_PATH)

vhdl-autogen: $(PACKETS_PKG_FILE)
$(PACKETS_PKG_FILE): $(PACKETDEFS_YAML) $(shell find crates/types -type f)
	cargo r -p types -- $(PACKETS_PKG_FILE)

fmt: vsg
vsg: .FORCE
	vsg $(VSG_ARGS)

test: .FORCE
	$(MAKE) run-tcl-script SCRIPT=scripts/run_testbenches.tcl

lint: .FORCE
	$(MAKE) run-tcl-script SCRIPT=scripts/lint.tcl

synth: .FORCE
	$(MAKE) run-tcl-script SCRIPT=scripts/synth.tcl

bitstream: .FORCE
	$(MAKE) run-tcl-script SCRIPT=scripts/bitstream.tcl

save: $(PROJ_INIT_TCL)
$(PROJ_INIT_TCL): $(VIVADO_PROJ)
	echo "TODO store init tcl script"

load: $(VIVADO_PROJ)
$(VIVADO_PROJ): $(PROJ_INIT_TCL)
	echo "TODO load init tcl script into new proj"

clean: clean-backup-log-jou clean-hw
	echo "TODO clean up vivado project files"

clean-hw:
	rm -rfv vivado/aoc-2025.hw/hw_1

clean-backup-log-jou: .FORCE
	rm -v vivado_*.backup.log vivado_*.backup.jou

run-tcl-script: clean-backup-log-jou
	echo "Running $(SCRIPT)"
	$(VIVADO) \
		-mode batch \
		-script $(SCRIPT) \
		$(VIVADO_PROJ) \
		2>&1 \
	| ./scripts/colouriser.sh

.FORCE:
