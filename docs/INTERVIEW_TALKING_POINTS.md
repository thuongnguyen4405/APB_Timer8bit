# Explaining the project in an interview

**30-second overview**

> I built a non-UVM, object-oriented SystemVerilog environment for an APB counter. A base test provides reusable read/write tasks; derived tests implement count-up/down with optional initial data. The environment uses packet mailboxes to connect the stimulus, driver, monitor and coverage-collecting scoreboard. I ran four scenarios separately in QuestaSim and merged functional coverage; my original server screenshot reported 100% of the defined bins.

**Why use a base test handle?**

`base = up` is SystemVerilog class polymorphism. `run_test()` invokes a `virtual run_scenario()` task so the concrete child scenario executes. This is not UVM.

**What does coverage mean?**

Transfer READ/WRITE, the two APB addresses, three directed write-data bins (1, 3, 100), read/write × address crosses, and meaningful count-up/down/preload crosses. Irrelevant combinations are excluded via `ignore_bins`.

**What are the current limits?**

Coverage is not pass/fail checking. The scoreboard in this reconstruction only gathers functional coverage, not a cycle-accurate model; APB protocol assertions and exhaustive corner cases remain future work. The screenshot is from the original remote build, not a rerun of this reconstructed reference.
