.PHONY:com sim debug cov clean

OUTPUT = divider
ALL_DEFINE = +define+DUMP_VPD

CM = -cm line+cond+fsm+branch+tgl
CM_NAME = -cm_name ${OUTPUT}
CM_DIR = -cm_dir ./${OUTPUT}.vdb


VPD_NAME = +vpdfile+${OUTPUT}.vpd

VCS = vcs -sverilog +v2k -timescale=1ns/1ns     \
	  -o ${OUTPUT}				\
	  -l compile.log			\
	  ${VPD_NAME}				\
	  ${ALL_DEFINE}				\
	  ${CM}					\
	  ${CM_NAME}				\
	  ${CM_DIR}				\
	  -debug_pp 				\
	  -Mupdate

SIM = ./${OUTPUT} ${VPD_NAME} 			\
	  ${CM}					\
	  ${CM_NAME}				\
	  ${CM_DIR}				\
      -l ${OUTPUT}.log

# compile
com:
	${VCS} -f verilog_file.f
# simulation
sim:
	${SIM}
# show the coverage
cov:
	dve -covdir *.vdb &
# open the dve
debug:
	dve -vpd ${OUTPUT}.vpd &
# clean the files
clean:
	rm -rf ./csrc *.daidir *.log simv* *.key *.vpd ./DVEfiles ${OUTPUT} *.vdb *.vcd