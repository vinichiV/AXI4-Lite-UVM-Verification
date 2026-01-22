# UVM Verification for AXI4 Lite

This repository implements a complete *UVM-based verification environment* for the AXI4-Lite protocol, focused on verifying a master-slave communication interface.
The design is derived from **Xilinx DS765 LogiCORE IP AXI4-Lite IPIF (axi_lite_ipif) v1.01.a Data Sheet** (https://docs.amd.com/v/u/en-US/axi_lite_ipif_ds765), which is used as a reference specification for protocol timing and signaling.

### Scope
- AXI4-Lite single-master, single-slave interface
- Single read and write operations with independent channels
- Valid/ready handshake timing and response checking

### UVM architecture
<img width="1393" height="832" alt="image" src="https://github.com/user-attachments/assets/de3a50c7-cc89-441f-b47f-10ca411015da" />

---

## 🚀 How to Run the Simulation

### Prerequisite
- **QuestaSim** installed (with UVM support)

### Steps

```bash
git clone https://github.com/vinichiV/AXI4-Lite-UVM-Verification.git

cd AXI4-Lite-UVM-Verification

vsim -do run.do
```
<img width="1198" height="798" alt="Screenshot 2026-01-22 161831" src="https://github.com/user-attachments/assets/a63d023b-a5f3-4d4e-b6cc-ec770f313e74" />

### Transaction waveforms

<img width="1575" height="823" alt="Screenshot 2026-01-22 161150" src="https://github.com/user-attachments/assets/caa58c90-8c19-4e46-9265-74146d3a80bd" />
