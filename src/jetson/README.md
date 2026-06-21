# Jetson AGX Orin — perception & targeting

Owns the vision pipeline: ZED 2i stereo capture, target detection, and the aim
solution (pixel/3D target → pan/tilt setpoints), handed down to the Pi 5
supervisor. Does **not** drive motors or the trigger directly.

## Responsibilities
- ZED 2i capture + depth; camera/boresight calibration.
- Target detection & tracking.
- Aim solution in turret coordinates → setpoints to the Pi 5.
- Perception monitor output (7" HDMI).

## Inputs / outputs
- **In:** ZED 2i (USB 3.0).
- **Out:** setpoints to Pi 5 (Ethernet, direct Pi↔Jetson link).

## Setup
See `requirements.txt`. The ZED SDK (`pyzed`) and JetPack torch wheels are
installed on-device, not via PyPI.

> Boresight is sacred — the ZED-to-barrel mount is rigid; any flex is aim drift
> the camera cannot calibrate out.
