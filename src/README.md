# `src/` — on-device software (three processors)

The turret's compute is split across three boards (see `turret-gimbal/CLAUDE.md` →
*System architecture*). Each has its own subdirectory and its own runtime
dependencies; the repo-root `requirements.txt` is **tooling only** (DXF/BOM/PDF
generation), not runtime.

| Dir | Board | Role | Language / runtime | Deps |
|-----|-------|------|--------------------|------|
| [`jetson/`](jetson/) | NVIDIA Jetson AGX Orin 32 GB | Perception & targeting (ZED stereo, detection, aim solution) | Python 3 (JetPack) | `jetson/requirements.txt` |
| [`pi5/`](pi5/) | Raspberry Pi 5 (8 GB) | Supervisor — setpoints, IMU/lidar fusion, **arming**, state machine | Python 3 | `pi5/requirements.txt` |
| [`pico/`](pico/) | Raspberry Pi Pico (RP2040) | Real-time motion — step/dir to both CL57T drivers, limit/homing, **stop-and-hold** | MicroPython (no on-device pip) | `pico/requirements-dev.txt` (host tools) |

## Signal chain
`sensors → Jetson (perception) → Pi 5 (supervisor) → Pico (step/dir) → CL57T drivers → 2× NEMA 23`

## Safety invariants (must hold in any code here)
- **Hardware arming interlock** in series with the 12 V solenoid — the firing path is
  never software-only.
- **E-stop** drops both the motor rail and the solenoid rail.
- **Pico** does stop-and-hold on any fault or heartbeat loss from the Pi 5.
- Validate autonomous tracking with the **trigger disarmed** before the firing path is live.
