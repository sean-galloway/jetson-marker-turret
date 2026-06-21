# Raspberry Pi 5 — supervisor

The system brain between perception and motion. Takes setpoints from the Jetson,
fuses IMU/lidar, enforces **arming** and the safety state machine, and streams
step/dir intent down to the Pico.

## Responsibilities
- Receive aim setpoints from the Jetson (Ethernet).
- Read BNO085 IMU (SPI/I2C) and TF03 lidar (UART) for leveling + range.
- Own the **arming** logic and overall state machine (SAFE / ARMED / FAULT).
- Drive the on-gun OLED (ARMED/SAFE + range).
- Command the Pico; monitor its heartbeat.

## Inputs / outputs
- **In:** Jetson setpoints (Ethernet); IMU, lidar, limit/homing switches.
- **Out:** commands to Pico (UART); OLED status; solenoid HAT (gated by the
  hardware arming interlock).

## Safety
Arming here is layered **on top of**, never in place of, the hardware interlock
in the 12 V solenoid line. Loss of the Jetson link → hold; Pico heartbeat is
watched and a drop triggers stop-and-hold.
