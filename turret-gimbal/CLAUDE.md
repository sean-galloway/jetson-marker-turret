# CLAUDE.md — Autonomous Paintball Sentry Turret (DIY pan/tilt gimbal)

Context for Claude Code. This project is an autonomous **paintball** (non-lethal hobby) sentry
turret built around a DIY **NEMA 23 closed-loop pan/tilt gimbal**. The mechanical gimbal is the
active design focus. Read this file first, then `docs/` for detail and the BOM markdown at the
repo root (`Turret_BOM.md` table + `Turret_BOM_checklist.md`) for the live parts list.

## Safety posture (non-negotiable — keep these invariants in any design work)
- **Hardware arming interlock**: a physical switch/relay in series with the 12 V solenoid line. The
  firing path must never be software-only.
- **E-stop** drops both the motor rail and the solenoid rail.
- **Pico** does stop-and-hold on any fault or heartbeat loss.
- Always **validate autonomous tracking with the trigger disarmed** before the firing path is live.
- Eye protection is baseline. Treat this as benign robotics/motion engineering.

## System architecture
- **On the turret (moving payload):** marker (barrel) + trigger solenoid + boresighted **ZED 2i**
  (mounted *below* the barrel) + laser sight (on top of the barrel) + **BNO055 IMU** + **TF03 lidar**
  + **armed/safe LED** (RED ARMED hardware-tied to the armed rail; GREEN SAFE), **plus the real-time
  motion node: Pico RP2040** (+ debug OLED) **and the 2× CL57T drivers**, co-located with the motors.
  IMU / limit switches / LED are **local** to the Pico (short I2C/GPIO — no umbilical extender needed).
- **On the tripod:** the gimbal + payload + the motion node, on a mechanical **quick-release**. One
  sleeved **umbilical** to the rack carries only **48 V motor power, 12 V solenoid power, Pi 5↔Pico
  comms (UART/USB), the ZED USB 3.0, and ground** — no motor phases or step/dir over distance.
- **Control rack (10" ground station — BOM Section H):** **Jetson AGX Orin** (perception/targeting)
  + **Raspberry Pi 5** (supervisor) + PSUs + **10" PDU** (all AC onboard, one cord to the wall)
  + Ethernet switch + **E-stop** (drops both motor + solenoid rails) + front-panel arming switch
  + the two 1U displays. (Motion electronics — Pico + CL57T drivers — live on the turret.)
- **Operator console (BOM Section I):** **RadioMaster TX16S (ELRS)** → ELRS RX (**CRSF**) → Pico for
  manual jog / test. MOTION ONLY — never the firing path. RX failsafe → Pico stop-hold. A console
  button triggers the Pico **level** routine (tilt → horizon via IMU + reset reference; roll is
  corrected by leveling the tripod, not actuated). Full manual flow (arm-off → level → aim → center →
  90°/180° sweep with optional 5 s dwell every 45°): see **docs/Operations.md**.
- **Signal chain (autonomous):** sensors → Jetson → Pi 5 →(umbilical)→ **Pico (on the turret)** →
  CL57T → 2× NEMA 23 closed-loop steppers. IMU / limit switches / RC console feed the Pico **locally**
  (real-time leveling/jog); the Pico relays orientation + state up to the Pi 5 for the state machine + GUI.
- A sensor cable bundle crosses the pan and tilt axes → needs a **service loop or slip ring**
  (decide in frame design; sets how far pan can travel).

## Design philosophy (locked)
- **Bolt-together, zero machining.** Two simplifications make this possible:
  1. Drop precision pilot bores → plain clearance holes; locate the gearbox by its 4-bolt flange
     (the ZED camera calibration corrects the small residual centering error).
  2. Clearance holes + nuts instead of tapped holes (no tapping).
- **Flat plates from DXF** (6061-T6, 6 mm) cut by **SendCutSend**, plus **bolt-on catalog parts**
  (housed bearings, clamp/face-mount hubs, lazy-susan bearing, brackets).
- **Modular:** the gimbal ends at a generic **PA-4 interface plate**; everything above is a separate
  **3D-printed payload module** (still to be designed from a marker scan).

## Key geometry decisions
- **Pan = yaw (bottom), tilt = pitch (top)** — standard turret convention.
- **Coaxial pan:** gearbox sits under the base plate, output shaft up through the lazy-susan **open
  center**, clamp hub drives the turntable.
- **Offset pan for a centered bore:** put the pan axis *under the bore*. The round base plate and the
  lazy susan stay concentric (clean look); the *marker* sits offset, bore over center, hopper
  cantilevered over the rear. Tilt axis crosses the pan axis at the bore height.
- **Round aluminum base plates**, rounded overall aesthetic.
- **Cosmetic clamshell shell** (ASA, thin-wall) over the payload — fully decoupled from the boresight
  parts; mounts to structure, never to the ZED or barrel. Designed last.
- **Boresight is sacred:** the ZED-to-barrel mount must be rigid; any flex = aim drift the camera
  can't calibrate out. ZED + IMU clip in with wire channels, but the ZED clip must seat on hard datum
  faces (+ a captive screw lock).

## Confirmed parts (see Turret_BOM.md — 50-item integrated BOM, sections A–G)
| # | Part | P/N | Notes |
|---|------|-----|-------|
| 1 | Motor + driver kit ×2 | 23HS45-4204D-E1000 (Amazon B0C6943QBM) | NEMA 23 closed-loop 3.0 N·m + CL57T V4.1 |
| 2 | Planetary gearbox 5:1 ×2 | (StepperOnline, Ø8 bore, 15 arcmin) | out Ø14 / Ø40 reg / 4×Ø5.2 @47.14 |
| 3 | Turntable bearing | 8" aluminum lazy susan, 265 lb, open center (VXB) | **needs hole-pattern measurement** → plates 02/03 |
| 4 | Tilt bearing | McMaster 5968K71 | 1/2" bore, 2-bolt flange, set-screw, sealed (SKF). **need flange spacing** → plate 05 |
| 5 | Mounting hub ×2 | Ruland FHT-MCL-14-SS | 14 mm face-mount, M4 threaded, **Ø22 / 2-hole pattern known** → plates 01/03 |
| 6 | Shoulder screw (tilt pin) | McMaster 90298A716 | 18-8 SS, 1/2"×1.5", 3/8"-16; pairs with #4 |
| 9 | Motion coprocessor | Raspberry Pi Pico (RP2040) | drives both CL57T |
| 10 | Motor PSU | DROK 48 V / 10 A / 480 W | **set 110 V switch (ships 220 V)**, run ~44–46 V, add bulk cap, enclose mains |
| 11 | Fastener assortment | McMaster 92275A110 | M3–M8 black-oxide SHCS (swap exposed bolts → stainless) |
| 12 | Dowel pins | McMaster 91595A161 | Ø4 × 16 mm (PA-4 interface locating) |
| 13 | Consumables | McMaster 7458A65 | Loctite 243 + anti-seize |

## Open / pending (what unblocks what)
- **Marker scan (the big one):** unlocks frame sizing, round-plate dimensions, the offset-pan layout,
  and the printed payload module. Need bore height, fore/aft bore position, hopper position, and the
  length × height-with-hopper × width envelope.
- **Frame sizing** (waits on marker scan) → then specify L-brackets (#7), standoffs (#8), and exact
  fastener lengths (#11).
- **Lazy-susan hole pattern** (measure on arrival, or match-drill) → plates 02/03.
- **Bearing 5968K71 flange spacing** (off McMaster drawing, or match-drill) → plate 05.
- **Tripod head pattern** (photo) → plate 06. User's tripod is rated 35 lb (marginal; watch flex).

## DXF plate set (cad/dxf/) — status
6061-T6, 6 mm, units in mm, geometry on layer `CUT`.
- `01_interface_plate_PA4.dxf` — payload interface. Hole pattern LOCKED.
- `02_base_plate_pan.dxf` — slew-bearing pattern is PLACEHOLDER (resize to ~210 mm for 8" bearing; round outline).
- `03_turntable_plate.dxf` — slew-bearing pattern PLACEHOLDER (round outline).
- `04_yoke_side_gearbox.dxf` — gearbox face LOCKED (47.14 / Ø42 / Ø16).
- `05_yoke_side_trunnion.dxf` — bearing pattern PLACEHOLDER (pending 5968K71 flange dims).
- `06_tripod_adapter.dxf` — tripod pattern PLACEHOLDER (pending tripod photo).
Gearbox-mount holes and the PA-4 interface are correct; slew-bearing, trunnion, and tripod holes are
assumed until the real measurements land. Plates 02/03 should become **circular** (~210 mm).

## Tooling (how artifacts were generated — reuse for edits)
- **DXF:** Python `ezdxf` (`doc.units = 6` for mm; LWPOLYLINE outlines + CIRCLE holes; layer `CUT`).
- **PDFs:** markdown → `weasyprint` (use `base_url="."` so relative image paths resolve;
  image links must include the folder prefix, e.g. `assets/images/...`).
- **BOM:** hand-maintained as Markdown (`Turret_BOM.md` table + `Turret_BOM_checklist.md`).
  The old xlsx workbook and its `bom2md.py` generator were removed — edit the markdown directly.
- **Diagrams:** `matplotlib` (Agg backend).
Install: `pip install ezdxf weasyprint markdown --break-system-packages`.

## Repo layout
```
bom/legacy/  superseded parts-list spreadsheets only; the live 50-item BOM is Turret_BOM.md (repo root)
cad/dxf/     6 plate DXFs
docs/        build plan, assembly guide, drawings, payload spec, SendCutSend spec (md + pdf)
docs/assets/ images referenced by the md/pdf docs
datasheets/  INDEX.md + confirmed-part datasheets (named BOM#_part_part-number)
```

## Likely next tasks for Claude Code
1. When the marker scan arrives: size the frame, redraw plates 02/03 as circular ~210 mm, place the
   offset pan axis under the bore, and regenerate the DXF set.
2. Design the 3D-printed payload module (marker + solenoid + ZED-below-barrel + laser + IMU + lidar,
   snap/clip mounts, wire channels) and the cosmetic clamshell shell.
3. As measurements arrive (lazy-susan holes, bearing flange, tripod), drop real holes into the plates.
4. Keep the BOM markdown current: `Turret_BOM.md` (table, Bought checkbox) and
   `Turret_BOM_checklist.md` (Ordered/Received boxes). These are hand-maintained now — edit the
   markdown directly; the xlsx and its generator have been removed.
