# Implementation Notes & Provenance

## What came from the supplied screenshots

File/directory names, the high-level architecture, test class names and intended write sequences, the coverage coverpoints/crosses, the test selection with `$test$plusargs`, and the original `100.0%` merged coverage screenshot were visible in the conversation.

## What was reconstructed / newly implemented

`rtl/*.vp` (none of the original RTL contents was visible), portions of `tb/driver.sv`, `tb/monitor.sv`, the full protocol timing and reset handling, and the Makefile automation are **reference code**, not byte-identical copies from the server. Some screenshot segments of driver/monitor were unreadable. The APB register semantics used in this reconstruction are assumptions intended to demonstrate the verification structure, not an authoritative peripheral specification.

## Assumed reconstructed register map

| Address | Write action | Read action |
| --- | --- | --- |
| `0x00` CCR | `0x00` stop; `0x01` up; `0x03` down | Current 8-bit count |
| `0x01` CDR | Load initial 8-bit count | Last CDR write |

`intr` is a simple terminal-count indication, not functionally verified by these four scenarios.

## Why these notes matter

A portfolio must distinguish **demonstrated practice** from new or unverified additions. Before claiming this repo is the exact original submission, replace reconstructed source files with your original files and rerun your own regression.

## Numeric literal correction

The supplied screenshots show the warning **`[RDGN] - Redundant digits in numeric literal`**, including an apparent `8'h100`. In SystemVerilog, `8'h100` has a declared width of eight bits and is truncated to `8'h00`; it is **not** decimal 100. This reconstruction intentionally uses `8'd100` (hex `8'h64`) for the preload data and the matching coverage bin. Consequently, the original screenshot's 100% value does not prove that a decimal-100 preload was covered. The regression must be rerun against the corrected model.
