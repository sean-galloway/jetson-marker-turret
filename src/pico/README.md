# Raspberry Pi Pico (RP2040) — real-time motion

Hard-real-time step/dir generation for both CL57T closed-loop drivers, plus
limit/homing switch handling. Runs **MicroPython** (or the C SDK); kept dumb,
fast, and safe — it takes intent from the Pi 5 and never decides to fire.

**Lives on the turret**, co-located with the 2× CL57T drivers and the motors, so
the IMU / limit switches / LED are local short runs. The umbilical to the rack
carries only power + Pi 5 comms (UART/USB) + the ZED USB — not step/dir or phases.

## Responsibilities
- Generate step/dir for pan + tilt to the 2× CL57T drivers.
- Read limit/homing microswitches → power-up homing → absolute aiming.
- **Stop-and-hold** on any fault or loss of the Pi 5 heartbeat.
- Drive a small **debug OLED** (SSD1306, I2C) showing the current routine/state,
  step/dir activity, homing status, heartbeat, and fault codes.
- Read the **BNO055 IMU** (local I2C — Pico and IMU are both on the turret, short
  run, no extender). Run real-time **leveling/stabilization**.
- **Level routine:** drive **tilt → true horizon** from IMU pitch and reset the
  orientation reference (e.g., after a series of drills). Roll is *reported*, not
  actuated (a pan/tilt gimbal can't correct base roll — level the tripod for that).
- **RC mode (TX16S over CRSF, UART):** sticks → pan/tilt jog; **Center** button sets
  the zero / sweep center; **Level** button → tilt-to-horizon; switches select the
  **90°/180°** pan arc, **sweep** on/off, and **sweep-pause** (dwell 5 s at each 45°
  across the arc); pot = sweep speed; a switch = motion-enable (dead-man).
  **RX failsafe / signal loss → stop-and-hold.** MOTION ONLY; never firing.
  Full operator flow: `docs/Operations.md`.
- Relay orientation/state up to the Pi 5 for its state machine + GUI.

## Inputs / outputs
- **In:** commands + heartbeat from the Pi 5 (UART); limit/homing switches (GPIO);
  BNO055 IMU (I2C); ELRS RX (CRSF, UART).
- **Out:** step/dir to CL57T V4.1 drivers; debug OLED (I2C); orientation to Pi 5 (UART).

## Runtime
MicroPython firmware — no on-device pip. `requirements-dev.txt` holds host tools
(`mpremote`) for flashing. Flash the latest RP2040 build from micropython.org.

## Safety
The heartbeat watchdog is mandatory: if the Pi 5 stops talking, motion stops and
holds position. The Pico has no path to the trigger.
