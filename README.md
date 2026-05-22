# mul_f_div — Multi-Output Frequency Divider

## Overview

`mul_f_div` is a synchronous, mode-selectable frequency divider written in Verilog. It takes an input clock and produces divided clock outputs at **f/2, f/4, f/8, and f/16** of the input frequency. The active output is selected at runtime via a 2-bit `mode` signal.

---

## Module Description

### `mul_f_div` (Design Under Test)

| Port   | Direction | Width | Description                                      |
|--------|-----------|-------|--------------------------------------------------|
| `clk`  | Input     | 1     | System clock                                     |
| `rst`  | Input     | 1     | Synchronous active-high reset                    |
| `en`   | Input     | 1     | Counter enable                                   |
| `mode` | Input     | 2     | Selects which frequency-divided output is active |
| `f_2`  | Output    | 1     | Clock divided by 2 (toggled at `counter[0]`)     |
| `f_4`  | Output    | 1     | Clock divided by 4 (toggled at `counter[1]`)     |
| `f_8`  | Output    | 1     | Clock divided by 8 (toggled at `counter[2]`)     |
| `f_16` | Output    | 1     | Clock divided by 16 (toggled at `counter[3]`)    |

### Mode Select Truth Table

| `mode` | Active Output | Divided Frequency |
|--------|---------------|-------------------|
| `2'b00` | `f_2`        | f_clk / 2         |
| `2'b01` | `f_4`        | f_clk / 4         |
| `2'b10` | `f_8`        | f_clk / 8         |
| `2'b11` | `f_16`       | f_clk / 16        |

### Internal Architecture

- A **4-bit counter** increments on every rising clock edge while `en` is asserted and `rst` is de-asserted.
- Each bit of the counter (`counter[0]`–`counter[3]`) naturally represents a divided clock signal.
- A second `always` block samples the appropriate counter bit into the selected output register based on `mode`.

---

## Testbench Description

### `mul_f_div_tb`

The testbench (`mul_f_div_tb`) instantiates the DUT and applies the following stimulus sequence:

| Time (ns) | Action                            |
|-----------|-----------------------------------|
| 0         | All signals initialised to 0      |
| 0 – 20    | `rst = 1` (reset asserted)        |
| 20        | `rst = 0`, `en = 1`, `mode = 00`  |
| 20 – 120  | `f_2` output active               |
| 120 – 220 | `mode = 01` → `f_4` output active |
| 220 – 320 | `mode = 10` → `f_8` output active |
| 320+      | `mode = 11` → `f_16` output active|
| ~2370     | `en = 0` (counter halted)         |

**Clock:** 10 ns period (toggled every `#5`).

**Monitor:** `$monitor` prints all signal states on every change:
```
TIME=<t> rst=<b> clk=<b> en=<d> mode=<bb> f_2=<b> f_4=<b> f_8=<b> f_16=<b>
```

---

## File Structure

```
├── mul_f_div.v          # RTL design module
├── mul_f_div_tb.v       # Simulation testbench
└── README.md            # This file
```

---

## Simulation Instructions

### Using Vivado (Xilinx)

1. Create or open a project in Vivado.
2. Add `mul_f_div.v` as a **Design Source**.
3. Add `mul_f_div_tb.v` as a **Simulation Source**.
4. Set `mul_f_div_tb` as the top simulation module.
5. Run **Behavioral Simulation** (`Flow → Run Simulation → Run Behavioral Simulation`).
6. Observe output waveforms in the **Waveform Viewer**.

### Using ModelSim / QuestaSim

```bash
vlog mul_f_div.v mul_f_div_tb.v
vsim mul_f_div_tb
run -all
```

### Using Icarus Verilog (iverilog)

```bash
iverilog -o mul_f_div_sim mul_f_div.v mul_f_div_tb.v
vvp mul_f_div_sim
```

---

## Expected Waveform Behaviour

- **`f_2`**: Transitions every clock cycle → period = 2 × T_clk = 20 ns.
- **`f_4`**: Transitions every 2 cycles → period = 40 ns.
- **`f_8`**: Transitions every 4 cycles → period = 80 ns.
- **`f_16`**: Transitions every 8 cycles → period = 160 ns.

> **Note:** Only the output corresponding to the active `mode` is being updated at any given time. The other outputs retain their last driven value.

---

## Design Notes & Limitations

1. **Single output active at a time:** The `case` statement only drives the output matching `mode`. Unselected outputs hold their previous registered value — they do **not** automatically reset to `0` on a mode switch.
2. **Synchronous reset:** Reset is evaluated on the rising edge of `clk` only.
3. **Counter width:** The 4-bit counter rolls over after 16 clock cycles, which is sufficient for all four division ratios.
4. **No glitch filtering:** Outputs are directly registered counter bits, so no additional combinational glitch-generation is introduced.

---

## Parameters at a Glance

| Parameter         | Value       |
|-------------------|-------------|
| Timescale         | 1 ns / 1 ps |
| Counter Width     | 4 bits      |
| Clock Period (TB) | 10 ns       |
| Reset Type        | Synchronous, active-high |
| Target Device     | Generic (FPGA / ASIC)    |

---

## Author

- **Create Date:** 22.05.2026  
- **Module:** `mul_f_div` / `mul_f_div_tb`  
- **Revision:** 0.01 — Initial release
