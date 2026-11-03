
# 8-bit APB Timer — SystemVerilog Design Verification

**Class-based, non-UVM verification of an APB-controlled 8-bit up/down timer.**

![Language](https://img.shields.io/badge/Language-SystemVerilog-1f6feb)
![Interface](https://img.shields.io/badge/Interface-AMBA%20APB-374151)
![Verification](https://img.shields.io/badge/Verification-Class--based%20%2F%20Non--UVM-087f5b)
![Test plan](https://img.shields.io/badge/Scenarios-24-6f42c1)

## Overview

This project verifies the register interface and functional behavior of an **8-bit timer peripheral controlled over an AMBA APB slave interface**. The verification environment is written in **SystemVerilog** and organized into reusable transaction, stimulus, driver, monitor, scoreboard, environment, and test classes.

The work emphasizes a **specification-driven verification plan**, self-checking APB register accesses, directed corner-case tests, constrained-random stimulus, and repeatable regression runs. It is a **custom SystemVerilog testbench, not a UVM implementation**.
Non-UVM SystemVerilog | 24 cases | one compile, many `+TESTNAME` runs.

**Source**: ICTC Project 1 slides + `NguyenVanThuongVplan.xlsx`.
**Status**: source-level review complete; RTL `.vp` is NOT in this ZIP. No claim of Questa PASS.

## Read in this order

1. `tb/packet.sv`: one APB request/response (`packet`).
2. `tb/stimulus.sv`: packet queue -> `s2d_mb`.
3. `tb/driver.sv`: APB SETUP -> ACCESS -> idle, trigger `pkt.done`.
4. `tb/monitor.sv`: observe completed APB transfer -> `m2s_mb`.
5. `tb/scoreboard.sv`: simple register shadow model, compare readback.
6. `tb/environment.sv`: connect all components and provide APB tasks.
7. `testcase/base_test.sv`: common `build`, reset and finish check.
8. `testcase/*_test.sv`: explicit scenarios matching 24 VPlan rows.
9. `tb/testbench.sv`: **only place to read `+TESTNAME`**, select derived class.

## Running on ICTC server

```bash
# unzip, then run from unpacked project root:
bash install_into_ictc_project.sh ~/project_dva/project1
cd ~/project_dva/project1/sim
source project_env.bash  # if required by school shell
make -f Makefile.dv build
make -f Makefile.dv run TESTNAME=register_reset_test SEED=1
make -f Makefile.dv run TESTNAME=register_rw_test SEED=1
perl regress.pl --quick
perl regress.pl --seeds 3
```
example: make run TESTNAME=register_rw_test SEED=1
<img width="883" height="820" alt="image" src="https://github.com/user-attachments/assets/11a8eea6-799f-4f25-99c4-be6766e5478c" />
other example test for register: 
make run TESTNAME=register_reset_test SEED=1
<img width="632" height="830" alt="image" src="https://github.com/user-attachments/assets/f3d44f86-5a15-49df-95e0-9fc73fa30baa" />


Compiler order from `sim/tb.f`: `dut_interface -> timer_pkg -> test_pkg -> testbench`.
Read `docs/WHAT_CHANGED.md` before copying over hand-edited server files.
<img width="1582" height="782" alt="image" src="https://github.com/user-attachments/assets/01608127-8ea5-4c87-a0a0-fed356e125e7" />
figure 1. OVERALL COVERAGE 
<img width="695" height="426" alt="image" src="https://github.com/user-attachments/assets/fd320e08-0a2b-43e4-a4a3-2205d44ccc8d" />
figure 2. cg_test 



