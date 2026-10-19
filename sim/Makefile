TESTNAME ?= count_up_test
TB_NAME  ?= testbench
SEED     ?= 1
COV      ?= ON
TESTS    := count_up_test count_down_test count_up_with_data_test count_down_with_data_test
UCDBS    := $(addsuffix .ucdb,$(TESTS))

ifeq ($(COV),ON)
CMP_COV_OPT  := -coveropt 3 +cover=bcesft
SIM1_COV_OPT := -coverage -coveranalysis
SIM2_COV_OPT := coverage save -codeAll -cvg -onexit $(TESTNAME).ucdb;
endif

.PHONY: all build run regress cov_merge cov_report cov_gui clean help
all: build run

build:
	vlib work
	vmap work work
	vlog $(CMP_COV_OPT) -sv -f compile.f | tee compile.log

run:
	vsim -c -sv_seed $(SEED) $(SIM1_COV_OPT) -l $(TESTNAME).log \
	  -voptargs=+acc -assertdebug work.$(TB_NAME) \
	  -do "$(SIM2_COV_OPT) run -all; quit -f" +$(TESTNAME)

# Four separate simulations; keep individual UCDBs and logs.
regress: build
	@set -e; for test in $(TESTS); do \
	  $(MAKE) run TESTNAME=$$test SEED=$(SEED) COV=ON; \
	done
	$(MAKE) cov_merge
	$(MAKE) cov_report

cov_merge:
	@for db in $(UCDBS); do test -f "$$db" || { echo "Missing $$db; run 'make regress'"; exit 1; }; done
	@rm -f IP_MERGE.ucdb
	vcover merge IP_MERGE.ucdb $(UCDBS)

cov_report:
	vcover report -details IP_MERGE.ucdb > coverage_report.txt
	@echo 'Wrote coverage_report.txt'

cov_gui:
	vsim -i -viewcov IP_MERGE.ucdb &

clean:
	rm -rf work vsim.dbg
	rm -f *.ini *.log *.wlf *.ucdb transcript coverage_report.txt

help:
	@echo 'make build | make run TESTNAME=count_up_test | make regress'
	@echo 'make cov_merge | make cov_report | make cov_gui | make clean'
