# Leaky Integrate-and-Fire (LIF) Neuron Study

## Overview
This repository documents my **self-taught exploration of the Leaky Integrate-and-Fire (LIF) neuron model**, implemented in both **analog (RC circuit)** and **digital (Verilog fixed-point)** domains.  
The goal of this project was to understand how biological neuron dynamics can be represented, simulated, and eventually realized on hardware for **neuromorphic research applications**.

I completed this study independently to prepare for future **neuromorphic and FPGA-based research**, focusing on how continuous-time differential equations can be translated into discrete-time digital implementations.

---

## Motivation
The LIF neuron is one of the simplest yet most powerful models used to describe the membrane potential behavior of biological neurons.  
This project bridges the gap between **theoretical modeling** and **hardware implementation**, showing how the same neuron can be simulated as:
1. An **analog RC circuit** that models the passive membrane dynamics, and  
2. A **digital decay model** that replicates the same behavior through different equations in Verilog.

This repository serves as both a **learning log** and a **technical demonstration** of my ability to self-learn advanced topics across analog and digital design.

---

## Project Structure

```
LIF_Neuron_Study/
│
├── /Analog_RC_Model/        # Verilog simulations of continuous-time RC neuron
│   ├── RC_LIF.v             # Single RC LIF neuron module
│   ├── RC_tb.v              # Simulation testbench
│   └── Simulation Results/
│
├── /Digital_Decay_Model/    # Verilog HDL implementation and testbenches
│   ├── LIFSIM.v
│   ├── LIFSIM_tb.v
│   ├── Simulation Results/
│
├── /Docs/                   # Notes, derivations, and learning materials
│   ├── lif_equations.pdf
│   └── references.txt
│
└── README.md
```

---

## Theoretical Background

The **Leaky Integrate-and-Fire (LIF)** neuron models the membrane potential \( V_{mem} \) as a capacitor \( C_m \) that leaks through a resistor \( R_m \):

\[
C_m \frac{dV_{mem}}{dt} = -\frac{V_{mem}}{R_m} + I_{app}
\]

When \( V_{mem} \) exceeds a threshold \( V_{th} \), the neuron “fires,” and the potential is reset.

### Discrete-Time Approximation  
In the digital implementation, this differential equation is approximated using the Euler method:

\[
V_{mem}[n+1] = V_{mem}[n] + ( -dv*V_{mem}[n] + du*I_{app}[n] )
\]

where \( du \) and \( dv \) are decay constants determined by the membrane parameters and time step.

---

## Implementations

### 1. RC Model (Digital Abstraction of Analog Dynamics)
The RC model represents the **analog foundation** of the LIF neuron — a first-order low-pass filter where the capacitor voltage corresponds to the membrane potential.  
However, the main challenge of this implementation was not building the circuit itself, but **digitally abstracting** the continuous RC behavior within a hardware description language.

Instead of simulating the RC neuron using MATLAB or SPICE, I implemented it in **Verilog**, which required:
- Expressing continuous-time exponential decay as a **discrete-time iterative process**.  
- Mapping physical parameters like resistance (R) and capacitance (C) into **scaled digital constants** that preserve the correct time constant behavior.  
- Using **fixed-point arithmetic** to maintain voltage resolution without floating-point operations.  
- Designing a **testbench** that mimics analog stimulus inputs (applied currents, reset thresholds) in a fully digital environment.

This approach forced a deep understanding of how **analog time constants translate into digital difference equations**, providing an essential bridge between circuit-level neuroscience models and FPGA realizations.

**Example Outcomes:**  
- Realistic exponential charging and discharging behavior captured digitally.  
- Clear spike/reset events triggered once \( V_{mem} > V_{th} \).  
- Parameter scaling validated against theoretical time constants.

### 2. Digital Decay Model (Verilog)
- Implemented on **FPGA** using **fixed-point arithmetic**.  
- Parameters such as `Vth`, `dv`, and `du` represent threshold and decay coefficients.  
- Input current (`I_app`) drives the neuron’s membrane potential accumulation.  
- A **refractory period** and **output spike register** simulate realistic firing dynamics.

---

## Simulation & Results
Both models demonstrate similar qualitative behavior:
- The **RC abstraction** produces continuous exponential-like dynamics in a digital format.  
- The **digital decay model** reproduces this behavior discretely using clock-driven updates and tunable parameters.

**Example results include:**
- Matching spike frequencies and thresholds for comparable constants.  
- Observable leak and membrane recovery behavior in waveform plots.  

---

## Tools & Technologies
- **Vivado + ModelSim** – for Verilog simulation and waveform analysis.   
- **Opal Kelly XEM7310 FPGA** (target hardware).  
- **Fixed-Point Arithmetic (16-bit)** – to emulate analog precision digitally.

---

## Future Extensions
- Implement multi-neuron networks for spiking neural computation.  
- Theoretical study of parameter effects on neuronal behavior using the discrete decay model.  
- Deploy full SNN modules on FPGA hardware.  
- Continue refining parameter scaling and precision across analog-digital boundaries.

---

## Project Status
**This project is still in progress.** Some files, results, and testbenches are currently being refined and will be added in future commits.  
Each update reflects new findings, optimizations, and insights as I continue developing this study.

This marks only the **first step in my neuromorphic research journey**, connecting biological neuron modeling with digital hardware realization.  
If you're interested in learning more about the motivation behind this work or would like to discuss my ongoing research direction, please feel free to **reach out to me**.

---

## Author
**Mal Mostafa**  
Department of Electrical & Computer Engineering  
University of Pittsburgh  

> This project was developed independently to strengthen my research foundation in **neuromorphic engineering**, **FPGA design**, and **computational neuroscience**, with the goal of joining the ENIGMA Lab as an Undergraduate Researcher.

---

## Citation & Acknowledgment
If you reference this work or adapt the code, please cite this repository as:

> M. Mostafa, *"Leaky Integrate-and-Fire (LIF) Neuron Study: Analog and Digital Implementations,"* 2025.  
> [GitHub Repository](https://github.com/malmos7/LIF-Neuron-Simulation)
