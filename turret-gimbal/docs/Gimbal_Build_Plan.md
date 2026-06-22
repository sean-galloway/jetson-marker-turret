# NEMA 23 Closed-Loop Pan/Tilt Gimbal — Build Plan

A two-axis, closed-loop motorized pan/tilt that replaces the Vidpro MH-430 motorized head. It carries the sensor/marker payload and aims it; the vision system (ZED 2i + lidar + IMU on the Jetson) is unchanged and separate.

---

## 1. Design targets

| Parameter | Target | Why |
|---|---|---|
| Payload | 10 lb (8 lb actual + margin) | Marker, ZED, Pi stack, lidar, plate, paintballs |
| Slew speed | ≥ 100°/s both axes | Track a running/close crossing target (the Vidpro's 21°/s couldn't) |
| Position feedback | Absolute, after homing | Command angles directly; visual servoing becomes a refinement |
| Tilt holding torque | ~10 N·m at the axis | 10 lb at ~10 cm moment arm (~4.5 N·m) × ~2 for recoil/accel |
| Backlash | Low (planetary or preloaded) | Aiming accuracy and bore-sight stability |

Everything downstream of "where do I point" stays the same. This document covers only the muscles.

---

## 2. System architecture

Three-tier control cascade, fastest loop closest to the motors:

```
Jetson Orin            Raspberry Pi 5              Pico (RP2040)        Drivers + motors
(vision/targeting) --> (supervisor)          -->  (motion coprocessor) --> (closed-loop)
  ZED depth+track       IMU, lidar, arming,        real-time step/dir,      NEMA 23 CL
  "aim here"            state, setpoints           profiling, homing        steppers
        Ethernet              UART/SPI                  step/dir/enable
```

- **Jetson** decides *where* to aim (pixel offset → angle), sends setpoints over Ethernet.
- **Pi** is the supervisor: reads the IMU and lidar, runs the arming logic and calibration routines, converts target requests into motion commands, and forwards them to the Pico.
- **Pico** does the hard real-time work: step/dir pulse generation, motion profiling (trapezoidal or S-curve), homing, and reading the limit switches. This is offloaded off the Pi because Linux is not real-time — software-timed steps from the Pi jitter and produce rough motion.

---

## 3. Mechanical design

### 3.1 Axis layout

- **Pan (azimuth):** vertical rotation. The motor + gearbox drives a turntable riding on a slewing/thrust bearing. The bearing carries the payload and moment loads — the motor shaft only transmits torque.
- **Tilt (elevation):** horizontal rotation carried on the pan turntable. The motor + gearbox drives a horizontal shaft running in bearing blocks; the payload plate mounts to that shaft (single-side trunnion or a two-side yoke).

### 3.2 Load path and materials

- Keep **metal in the load path**: frame, shafts, bearings, motor/gearbox mounts. Recoil impulse plus a 10 lb payload is too much for printed plastic at the bearings and shafts.
- **3D-printed parts** are fine for non-structural brackets, the sensor/marker platform plate (the one already designed), cable guides, and covers.
- **Never** hang the payload off a motor or gearbox output shaft directly. The bearing takes the load; the drive only applies torque.

### 3.3 Balance

- Mount the payload so its center of gravity sits **within ~10 cm of the tilt axis**. This is the single biggest lever on tilt holding torque (and therefore motor size, heat, and recoil margin).
- Aim for the combined CG near the pan axis centerline too, so pan mostly fights rotational inertia rather than an offset mass.

### 3.4 Reduction (~5:1 per axis)

| Option | Pros | Cons | Use |
|---|---|---|---|
| Planetary gearbox | Stiff, low backlash, compact | Holding draws current (heat) | **Default**, both axes |
| Worm drive | Self-locking: holds against gravity/recoil with zero current, no heat, holds through power loss | Lower speed/efficiency, can't backdrive | Strong choice for **tilt** |
| Timing belt | Cheapest, simple | Compliance/backlash | Acceptable for **pan** |

For aiming you want low backlash, so favor planetary or a preloaded worm over a loose belt. A worm on tilt is attractive for a sentry that holds an elevation for long periods.

### 3.5 Mounting to a heavy-duty tripod

Mounting the whole assembly to a heavy-duty tripod is the simplest base — no custom stand to fabricate; the pan base just gets a tripod adapter on its underside. Things to get right, because a tripod-mounted turret has demands a camera doesn't:

- **Load rating.** The gimbal hardware (two steppers + gearboxes + bearings + frame) is roughly 12–19 lb, plus the ~10 lb payload — budget ~25–30 lb total. Pick a tripod rated comfortably above that (40 lb+): a heavy video/cine or surveying-grade tripod, not a photo tripod.
- **Rigidity, not just load.** Aiming accuracy assumes a rigid base — leg flex becomes pointing error, can make the control loop oscillate, and drifts the bore-sight. Want big-diameter legs, few sections, locked solid.
- **Stability under dynamic loads.** Slewing ~25 lb fast and taking recoil both create reaction moments the tripod must resist without tipping or twisting. Go wide-stance and low, spike or lock the feet, and hang ballast from the center hook. Mount the heavy static gear (Jetson, the 24–48 V and 12 V supplies) low near the base for a low CG and short cable runs.
- **Bowl mount (recommended).** A 100 mm or 150 mm half-ball bowl lets you level the platform in seconds — loosen, tilt to the bubble or the IMU readout on the console, lock — which cleanly handles the roll axis the 2-axis gimbal can't correct.
- **Anti-rotation interface.** Don't mount on a single 3/8"-16 stud; pan reaction torque will counter-rotate the whole gimbal on the tripod. Clamp or key the pan base (a bowl seats it naturally, or add locating pins / a flat) so pan reaction can't twist the base.

---

## 4. Torque & speed sizing (verify against your final build)

**Tilt holding torque (worst case, payload horizontal):**

```
T_hold = W × d = (10 lb = 44.5 N) × 0.10 m ≈ 4.5 N·m
T_design = T_hold × ~2 (recoil + acceleration) ≈ 10 N·m at the tilt axis
```

**Motor through reduction:**

```
NEMA 23 (~3 N·m) × 5:1 ≈ 15 N·m at axis (before gearbox losses)  →  ~1.5× margin over T_design
```

**Speed:** a NEMA 23 turning ~600–1000 rpm through 5:1 gives ~120–200 rpm at the axis = 720–1200°/s theoretical. You'll run far below that for smooth control; the point is you have torque *and* speed to spare, so tune for ~100–200°/s with margin.

**Pan:** the payload sits on the pan axis, so pan fights rotational inertia + friction, not gravity. The same motor/gearbox covers it comfortably; size acceleration to your tracking needs.

---

## 5. Drive electronics & power

### 5.1 Motors and drivers

- 2 × NEMA 23 **closed-loop** stepper (integrated encoder). Closed-loop catches any step missed under recoil load, so position is never silently lost.
- 2 × closed-loop driver (CL57-class). Wire motor phases and the encoder cable per the driver; set the running current to the motor rating, microstepping to taste (start ~8–16×).

### 5.2 Power rails

| Rail | Feeds | Notes |
|---|---|---|
| 5 V (USB-C) | Pi 5 | Official 27 W supply |
| 24–48 V | Stepper drivers | Higher volts = higher top speed |
| 12 V | Solenoid only | Was shared with the motors; now solenoid-only |

- **Tie all grounds together** (Pi, Pico, driver logic, 24–48 V, 12 V). The Ethernet link to the Jetson is transformer-isolated and needs no shared ground.
- **Fuse each rail** near its supply. A stalled motor or a solenoid fault should blow a fuse, not a board.
- If you prefer a single supply, run 48 V and buck down to 12 V and 5 V.

### 5.3 Signal wiring

- Pico → each driver: `STEP`, `DIR`, `ENABLE` (3 lines/axis).
- Limit switches → Pico GPIO (with pull-ups; wire normally-closed so a broken wire reads as "at limit" = fail-safe).
- Pico ↔ Pi: UART (or SPI). Keep this link simple and well-defined — it carries setpoints down and position/status up.

---

## 6. Control & firmware

### 6.1 Pico (motion coprocessor) responsibilities

- Generate clean `STEP`/`DIR` with proper acceleration profiles (trapezoidal or S-curve).
- Run the **homing** routine on command.
- Read limit switches; enforce soft and hard travel limits.
- Accept a small command set from the Pi and report back:
  - `HOME`, `ENABLE/DISABLE`
  - `MOVE_TO angle rate` (absolute) / `JOG rate` (velocity)
  - `STATUS?` → current angle, moving/idle, fault/limit flags
- On any fault or loss of the Pi heartbeat: stop and hold (or disable).

### 6.2 Pi (supervisor) responsibilities

- Maintain the arming state machine (the firing interlock is hardware; the Pi tracks and gates the logical state).
- Read the IMU (leveling/stabilization) and lidar (range).
- Translate Jetson target requests, or console/manual input, into `MOVE_TO`/`JOG` commands to the Pico.
- Run the calibration routines (Section 7) and store the results.

### 6.3 Protocol-first bring-up

Define the **Pi↔Jetson command frames now**, and have the Pi 5 console emit those exact frames during the "human-as-Jetson" phase. Then the real Jetson is a drop-in — same messages, nothing to rewire. The Pi↔Pico link should likewise be defined once and reused for both manual and autonomous control.

---

## 7. Homing & calibration sequence

Run in this order; store the results so they persist across power cycles:

1. **Home** — drive each axis slowly to its limit switch, back off to a repeatable index, set that as zero (apply a known offset to a mechanical reference if desired). After this, encoder + zero = true absolute pointing.
2. **Level** — with the rig stationary, read pitch/roll from the IMU's gravity vector (drift-free when still). Tilt can be driven to a gravity-referenced reference; **roll is leveled mechanically at the tripod legs** (the 2-axis head has no roll DOF). Record the leveled, gravity-aligned frame.
3. **Bore-sight** — using the checkerboard (on a **rigid flat** backing; record the exact square size), capture the camera→gun (hand-eye) transform so the gun points where the camera says. This is upstream of all aim accuracy.
4. **Store** both the level reference and the bore-sight transform from the console.

---

## 8. Assembly sequence

1. **Pan base:** mount the slewing/thrust bearing to the tripod adapter. Mount the pan motor + gearbox; couple the gearbox output to the turntable through the reduction (not the bearing). Confirm the turntable spins freely on the bearing with the motor back-driven by hand (or de-energized).
2. **Tilt structure:** build the yoke/trunnion on the pan turntable. Install the tilt shaft in its bearing blocks. Mount the tilt motor + gearbox to one side; couple to the shaft.
3. **Payload plate:** bolt the printed sensor/marker platform to the tilt shaft. Position the payload to put its CG within ~10 cm of the tilt axis; add/relocate mass until balanced.
4. **Limit switches:** mount one per axis at a repeatable reference; set mechanical hard stops just beyond the soft limits.
5. **Wiring:** motors→drivers (phases + encoder), drivers→24–48 V, Pico→drivers (step/dir/enable), switches→Pico, Pico↔Pi. Common ground. Fuse the rails. Add a service loop on the Ethernet run to the Jetson.

---

## 9. Bring-up checklist (incremental — never skip ahead)

1. **No payload, low current, trigger physically disarmed.**
2. Enable one axis; jog slowly. Confirm direction sign, encoder counts, and that closed-loop holds against a hand push without losing position.
3. Verify homing: repeatable zero, soft limits stop motion, hard stops are beyond them.
4. Repeat for the second axis.
5. Add the payload. Re-check holding (especially tilt) and re-balance if needed. Raise current/accel gradually.
6. Tune the motion profile up toward target speed; watch for resonance, missed-step faults, and overshoot.
7. Run home → level → bore-sight; store.
8. Bring the Jetson in: validate tracking and decisions **on the Jetson's 1U monitor with the trigger still disarmed** for a good while before the firing path is ever live.

---

## 10. Safety interlock (carry-over, non-negotiable)

- The **arming switch/relay sits in series with the 12 V solenoid feed** — when open, the trigger physically cannot fire, in hardware, regardless of software state.
- Keep a master **e-stop** that drops the 24–48 V motor rail *and* the 12 V solenoid rail.
- The Pico stops-and-holds on fault or loss of the Pi heartbeat; the Pi gates the logical arming state.
- Validate autonomy disarmed (Section 9, step 8) before the tracking system and the firing path are ever energized together.

---

*Parts, SKUs, and power specifics are in the companion `Turret_Full_Parts_List.xlsx` (Parts List, Connection Map, Integration Notes). Sizing figures here are starting points — re-run the torque math against your final measured payload and moment arm.*
