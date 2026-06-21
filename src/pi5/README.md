# Raspberry Pi 5 — supervisor

The system brain between perception and motion. Takes setpoints from the Jetson,
fuses IMU/lidar, enforces **arming** and the safety state machine, and streams
step/dir intent down to the Pico.

## Responsibilities
- Receive aim setpoints from the Jetson (Ethernet).
- Read the BNO055 IMU (I2C, DFRobot Gravity SEN0253) and TF03 lidar (UART) for
  leveling + range. Run the IMU in **IMU mode (no magnetometer)** — stepper
  fields corrupt mag heading. **BNO055 + Pi I2C clock-stretch:** lower the bus
  baud (`dtparam=i2c_arm_baudrate=10000` in config.txt) or you'll get I/O errors.
- Own the **arming** logic and overall state machine (SAFE / ARMED / FAULT).
- Drive the SAFE/ARMED state. The on-turret **ARMED LED is hardware-tied to the
  armed rail** (true indication, not a GPIO); the Pi 5 may also drive the GREEN
  SAFE lamp and surfaces range/status on the 10.1" touch GUI.
- Command the Pico; monitor its heartbeat. (The debug OLED lives on the Pico.)

## Inputs / outputs
- **In:** Jetson setpoints (Ethernet); IMU, lidar, limit/homing switches.
- **Out:** commands to Pico (UART); armed/safe LED + 10.1" touch GUI; solenoid
  HAT (gated by the hardware arming interlock).

## Safety
Arming here is layered **on top of**, never in place of, the hardware interlock
in the 12 V solenoid line. Loss of the Jetson link → hold; Pico heartbeat is
watched and a drop triggers stop-and-hold.
