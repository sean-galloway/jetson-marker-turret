# Raspberry Pi Pico (RP2040) — real-time motion

Hard-real-time step/dir generation for both CL57T closed-loop drivers, plus
limit/homing switch handling. Runs **MicroPython** (or the C SDK); kept dumb,
fast, and safe — it takes intent from the Pi 5 and never decides to fire.

## Responsibilities
- Generate step/dir for pan + tilt to the 2× CL57T drivers.
- Read limit/homing microswitches → power-up homing → absolute aiming.
- **Stop-and-hold** on any fault or loss of the Pi 5 heartbeat.

## Inputs / outputs
- **In:** commands + heartbeat from the Pi 5 (UART); limit/homing switches (GPIO).
- **Out:** step/dir to CL57T V4.1 drivers.

## Runtime
MicroPython firmware — no on-device pip. `requirements-dev.txt` holds host tools
(`mpremote`) for flashing. Flash the latest RP2040 build from micropython.org.

## Safety
The heartbeat watchdog is mandatory: if the Pi 5 stops talking, motion stops and
holds position. The Pico has no path to the trigger.
