# Raspberry Pi 5 — supervisor

The system brain between perception and motion. Takes setpoints from the Jetson,
fuses IMU/lidar, enforces **arming** and the safety state machine, and streams
step/dir intent down to the Pico.

## Responsibilities
- Receive aim setpoints from the Jetson (Ethernet).
- Read the TF03 lidar (UART) for range. The **BNO055 IMU now lives on the Pico**
  (real-time leveling); the Pi 5 receives orientation **from the Pico** over their
  UART link rather than reading the IMU directly (this also avoids the Pi's BNO055
  I2C clock-stretch issue). Keep the IMU in **IMU mode (no magnetometer)** — stepper
  fields corrupt mag heading.
- Own the **arming** logic and overall state machine (SAFE / ARMED / FAULT).
- Drive the SAFE/ARMED state. The on-turret **ARMED LED is hardware-tied to the
  armed rail** (true indication, not a GPIO); the Pi 5 may also drive the GREEN
  SAFE lamp and surfaces range/status on its 1U rack display.
- Command the Pico; monitor its heartbeat. (The debug OLED lives on the Pico.)

## Inputs / outputs
- **In:** Jetson setpoints (Ethernet); TF03 lidar; orientation + limit/homing status relayed from the Pico (UART).
- **Out:** commands to Pico (UART); armed/safe LED + 1U rack display; solenoid
  HAT (gated by the hardware arming interlock).

## Safety
Arming here is layered **on top of**, never in place of, the hardware interlock
in the 12 V solenoid line. Loss of the Jetson link → hold; Pico heartbeat is
watched and a drop triggers stop-and-hold.
