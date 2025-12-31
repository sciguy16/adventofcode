set testbenches [get_filesets -filter {FILESET_TYPE == "SimulationSrcs"}];

# current_fileset -simset [ get_filesets day0 ]

# launch_simulation -simset [get_filesets day0 ]


foreach fileset $testbenches {
	puts "STARTING TESTBENCH $fileset";
	launch_simulation -simset $fileset
	puts "FINISHED TESTBENCH $fileset";
}
