
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
## BLOCK DIAGRAM 8-bit Timer
<img width="1002" height="430" alt="image" src="https://github.com/user-attachments/assets/071050ff-680f-4b6c-b3a8-6fa208060c3f" />

## Environemnt testbench stucture
<img width="941" height="357" alt="image" src="https://github.com/user-attachments/assets/e1bf7e0f-e1d3-44b4-b6d8-3b6715d40a58" />
### Clocks and reset

| Signal / setting | Value | Purpose |
| --- | --- | --- |
| `pclk` | 50 MHz | APB register-access clock domain |
| `ker_clk` | 200 MHz | Timer kernel clock feeding the divider |
| `presetn` | Active-low | Reset input |
| `clk_div = 2'b00` | 200 MHz | Divide by 1 |
| `clk_div = 2'b01` | 100 MHz | Divide by 2 |
| `clk_div = 2'b10` | 50 MHz | Divide by 4 |
| `clk_div = 2'b11` | 25 MHz | Divide by 8 |

The clock divider, load control, and count direction are configured while the timer is disabled, as described by the design specification.

### Register map

| Address | Register | Key fields / purpose |
| --- | --- | --- |
| `0x00` | **TCR** — Timer Configuration Register | `clk_div[4:3]`, `load[2]`, `count_down[1]`, `timer_en[0]` |
| `0x01` | **TSR** — Timer Status Register | `underflow[1]`, `overflow[0]` — hardware-set, W1C |
| `0x02` | **TDR** — Timer Data Register | `data[7:0]` — preload value |
| `0x03` | **TIE** — Timer Interrupt Enable Register | `underflow_en[1]`, `overflow_en[0]` |
| `0x04–0xFF` | Reserved | Writes ignored; reads return zero |

**Important behavior:** `TSR.overflow` is raised on a `255 → 0` transition; `TSR.underflow` is raised on a `0 → 255` transition. Writing a `1` to the corresponding status bit clears it; writing `0` does not clear that bit.

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



