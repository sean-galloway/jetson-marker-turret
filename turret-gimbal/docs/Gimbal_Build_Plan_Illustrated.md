# NEMA 23 Closed-Loop Pan/Tilt Gimbal — Illustrated Build Plan

A two-axis, closed-loop motorized pan/tilt that replaces the Vidpro MH-430 motorized head. It carries the sensor/marker payload and aims it; the vision system (ZED 2i + lidar + IMU, processed on the Jetson) is a separate subsystem and is unchanged.

---

## 1. Design targets & why we're replacing the head

| Parameter | Target | Why |
|---|---|---|
| Payload | 10 lb (8 lb actual + margin) | Marker, ZED, Pi stack, lidar, plate, paintballs |
| Slew speed | ≥ 100°/s both axes | Track a running/close crossing target |
| Position feedback | Absolute, after homing | Command angles directly; visual servoing is a refinement |
| Tilt holding torque | ~10 N·m at the axis | 10 lb at ~10 cm arm (~4.5 N·m) × ~2 for recoil/accel |
| Backlash | Low (planetary / preloaded) | Aiming accuracy and bore-sight stability |

The Vidpro tops out at **21°/s**. A crossing target's slew demand is velocity ÷ range, so the head loses lock on anything fast or close:

![Crossing-target slew demand vs range](images/fig_tracking_envelope.png)

*The Vidpro keeps up with a walking target only beyond ~4 m and a runner beyond ~8 m. The NEMA 23 closed-loop drive (100–300°/s) clears the whole field with margin.*

---

## 2. System architecture

Three-tier control cascade — the fastest loop sits closest to the motors, and step generation is offloaded off the (non-real-time) Pi onto a microcontroller.

![Control cascade architecture](images/fig_architecture.png)

- **Jetson** decides *where* to aim (pixel offset → angle) and sends setpoints over Ethernet.
- **Pi** is the supervisor: IMU, lidar, arming logic, calibration routines, and translating targets into motion commands.
- **Pico** does the hard real-time work: step/dir generation, motion profiling, homing, limit switches. Don't bit-bang steps from Linux — the jitter shows up as rough motion.

---

## 3. Mechanical design

![Pan/tilt assembly side elevation](images/fig_assembly.png)

- **Pan (azimuth):** motor + gearbox turns a turntable on a slewing/thrust bearing that carries the payload and moment loads — the motor shaft only transmits torque.
- **Tilt (elevation):** motor + gearbox drives a horizontal shaft in bearing blocks; the payload plate mounts to it. Tilt is the torque-critical axis (it fights gravity).
- **Materials:** metal in the load path (frame, shafts, bearings). Printed parts are fine for the sensor/marker plate, brackets, and covers — never for the bearings or shafts.
- **Balance:** keep the payload CG within ~10 cm of the tilt axis. It's the biggest lever on motor size, heat, and recoil margin.

### 3.5 Mounting to a heavy-duty tripod

![Tripod mounting](images/fig_tripod_mount.png)

- **Load rating:** gimbal hardware (~12–19 lb) + payload (~10 lb) ≈ 25–30 lb. Pick a tripod rated 40 lb+ — heavy video/cine or surveying grade.
- **Rigidity:** leg flex becomes pointing error and drifts the bore-sight. Big-diameter legs, few sections, locked.
- **Stability:** fast slews and recoil create reaction moments. Wide stance, low CG, spiked/locked feet, ballast on the center hook.
- **Bowl mount:** a 100/150 mm half-ball levels the platform in seconds — handling the roll axis the 2-axis gimbal can't.
- **Anti-rotation:** never a lone 3/8"-16 stud — pan reaction torque will twist the whole gimbal. Clamp or key the base.

---

## 4. Torque & speed sizing (verify against your final build)

![Tilt torque sizing](images/fig_tilt_torque.png)

The chosen NEMA 23 motor (**3.0 N·m**, PN 23HS45-4204D-E1000) through **5:1** yields **15 N·m** at the axis — about 1.5× over the ~10 N·m design load. Speed is never the constraint: that motor through 5:1 gives hundreds of °/s, so you run well below max and keep torque in hand. Pan fights inertia, not gravity, so the same motor covers it.

---

## 5. Drive electronics & power

![Power rails and grounding](images/fig_power_wiring.png)

- **Confirmed drivetrain (×2, pan + tilt):** NEMA 23 closed-loop **3.0 N·m** motor + **CL57T** driver — STEPPERONLINE kit, PN **23HS45-4204D-E1000** (Amazon B0C6943QBM); paired with a **5:1 planetary gearbox, Ø8 input bore**, 15 arcmin backlash.
- The CL57T drivers ship with the motor kits; the Pico generates step/dir and the 24–48 V supply feeds the drivers.
- Rails: **5 V** (Pi), **12 V** (solenoid only now), **24–48 V** (motors; higher = faster).
- **Tie all grounds together**; the Ethernet link to the Jetson is isolated and needs no shared ground. **Fuse each rail** near its supply.

The motor (Ø8 shaft) and gearbox (Ø8 bore) mate directly on both axes — pilot Ø38.1 and the 47.14 pattern line up:

![Pan drive connection](images/c1_pan.png)

![Tilt drive connection](images/c2_tilt.png)

The gearbox output is identical on both axes (Ø14 h7 shaft, Ø40 h7 register, 4×Ø5.2 @ 47.14), so the face machined into the pan base plate and the tilt yoke wall is the same:

![Gearbox-output mounting face](images/pa6_mount_interface.png)

---

## 6. Control & firmware

- **Pico:** step/dir + acceleration profiles, homing routine, limit switches, a small command set (`HOME`, `ENABLE`, `MOVE_TO angle rate`, `JOG rate`, `STATUS?`), stop-and-hold on fault or loss of Pi heartbeat.
- **Pi:** arming state machine, IMU/lidar, calibration, and translating Jetson/console requests into Pico commands.
- **Protocol-first:** define the Pi↔Jetson frames now and have the Pi 5 console emit them, so the human-as-Jetson phase and the real Jetson are interchangeable.

---

## 7. Connection map

![Connection map](images/fig_connection_map.png)

Each device sits on its native bus: I2C (solenoid HAT, OLED), SPI (IMU), UART (lidar, Pico), Ethernet (Jetson), USB 3.0 (ZED → Jetson). Nothing timing-critical shares a bus with high-rate traffic.

---

## 8. Homing & calibration sequence

![Calibration sequence](images/fig_calibration_flow.png)

Run in order and store the results: home each axis to its switch (giving absolute aim), level using the IMU gravity vector (roll at the tripod legs), capture the camera→gun bore-sight from the checkerboard (rigid flat backing, known square size), and persist both from the console.

---

## 9. Assembly sequence

1. **Pan base:** mount the slewing/thrust bearing to the tripod adapter; mount the pan motor + gearbox; couple to the turntable. Confirm it spins freely on the bearing.
2. **Tilt structure:** build the yoke on the pan turntable; install the tilt shaft in bearing blocks; mount the tilt motor + gearbox.
3. **Payload plate:** bolt the printed platform to the tilt shaft; position the payload so its CG is within ~10 cm of the tilt axis; balance.
4. **Limit switches:** one per axis at a repeatable reference; mechanical hard stops just beyond.
5. **Wiring:** motors→drivers (phases + encoder), drivers→24–48 V, Pico→drivers, switches→Pico, Pico↔Pi. Common ground, fuse the rails, service loop on the Ethernet run.

---

## 10. Bring-up checklist (incremental — never skip ahead)

1. No payload, low current, **trigger physically disarmed.**
2. Jog one axis slowly; confirm direction, encoder counts, closed-loop hold against a hand push.
3. Verify homing: repeatable zero, soft limits, hard stops beyond.
4. Repeat the second axis.
5. Add payload; re-check tilt holding; raise current/accel gradually.
6. Tune the motion profile toward target speed; watch for resonance and overshoot.
7. Run home → level → bore-sight; store.
8. Bring the Jetson in: validate tracking and decisions **on the Jetson's 1U monitor with the trigger disarmed** before the firing path is ever live.

---

## 11. Safety interlock (carry-over, non-negotiable)

- The **arming switch/relay sits in series with the 12 V solenoid feed** — open = cannot fire, in hardware.
- A master **e-stop** drops both the 24–48 V motor rail and the 12 V solenoid rail.
- The Pico stops-and-holds on fault or loss of the Pi heartbeat.
- Validate autonomy disarmed before tracking and the firing path are ever energized together.

---

*Companion file: `Turret_Full_Parts_List.xlsx` (Parts List, Connection Map, Integration Notes). Sizing figures are starting points — re-run the torque math against your final measured payload and moment arm. Figures are schematic, not to scale.*
