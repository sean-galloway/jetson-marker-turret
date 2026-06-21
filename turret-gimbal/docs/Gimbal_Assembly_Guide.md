# NEMA 23 Pan/Tilt Gimbal — Assembly Guide

**For fabrication / professional assembly.** This guide covers the mechanical pan/tilt gimbal only (not the vision or trigger electronics). It is a **design-intent package**: standard interface dimensions are given exactly; build-specific frame dimensions appear as labeled callouts (**A–J**) in the [Dimension Schedule](#9-dimension-schedule) and must be finalized against the supplied parts/scans before machining. Drawings are schematic and not to scale unless a dimension is shown.

**Scope boundary:** the gimbal ends at the **tilt-output interface plate** (PA-4) — a generic, payload-agnostic mount. Everything above it (marker, cameras, lidar, Pi, trigger) is a separate 3D-printed **payload module** (see `Payload_Top_Module.pdf`). Because the gimbal is payload-agnostic, it needs **no part scans** — it is built entirely from the load spec (≤10 lb, CG ≤100 mm from the tilt axis, within the bounding envelope).

Revision: C — drivetrain confirmed (motor + gearbox part numbers locked). Companion files: `Gimbal_Build_Plan_Illustrated.pdf`, `Turret_Full_Parts_List.xlsx`.

---

## 1. Bill of materials — mechanical

| Item | Spec | Qty | Notes |
|---|---|---|---|
| Motor + driver | NEMA 23 closed-loop **3.0 N·m** + CL57T V4.1 driver — STEPPERONLINE kit, PN **23HS45-4204D-E1000** (Amazon B0C6943QBM) | 2 | Pan + tilt; Ø8 shaft, 1000-line encoder |
| Planetary gearbox | 5:1, **Ø8 input bore**, 15 arcmin; output Ø14 h7 shaft (key 5, M5×12) / Ø40 h7 register / 4×Ø5.2 @ 47.14 | 2 | Matches motor Ø8 shaft |
| Pan bearing | Slewing/thrust bearing, bore per **C** | 1 | Carries payload + moment load |
| Tilt shaft | Steel, Ø **E** (e.g. 12 mm), length per **D** | 1 | Hardened/ground preferred |
| Tilt bearings | Flanged or pillow-block, bore to suit **E** | 2 | Slip fit on shaft |
| Shaft collars | Clamp type, Ø **E** | 2–4 | Axial location |
| Reduction coupling | Rigid/bellows coupling, or GT3 belt + 5:1 pulleys | per axis | If belt: idler for tension |
| Frame stock | Aluminum — 40×40 T-slot extrusion or 6 mm plate/channel | per **A,B,W** | Metal in the load path |
| Pan turntable plate | Aluminum, machined | 1 | Mounts to pan bearing |
| Tilt yoke | Aluminum plate/bracket | 1–2 | Carries tilt bearings |
| Tilt-output interface plate | Aluminum, machined — Ø70 bolt circle (4×M5) + Ø30 h7 pilot + 2×Ø4 dowels | 1 | Generic payload mount (PA-4); payload-agnostic |
| Tripod adapter | Plate + anti-rotation key/pins | 1 | Per PA-5 |
| Fasteners | M5 SHCS (motors), M6 (frame/tripod), M3–M4 (components) | assorted | Class 8.8 min |
| Dowel pins | Ø3–4 mm, alignment | as req. | Locate critical joints |
| Consumables | Medium threadlocker, anti-seize, shim stock | — | — |

**Drive electronics (for reference / functional test — not part of the mechanical build):** the **CL57T drivers ship with the motor kits**; you still need 1 × Pico RP2040 motion coprocessor and 1 × 24–48 V supply. See the main turret BOM.

---

## 2. Tools & consumables

Metric hex/Allen set · torque wrench (1–10 N·m range) · vernier/digital calipers · dial indicator + magnetic base · combination square · digital angle gauge or precision level · dead-blow mallet · bearing press or arbor (if any press fit) · tap & die set (if tapping frame) · drill + deburring tools · belt tension gauge (if belt reduction) · medium threadlocker · anti-seize.

---

## 3. Fastener & torque schedule

Class 8.8 steel into aluminum, dry/threadlocked — **confirm against your joint and any printed parts (reduce for plastic):**

| Thread | Torque | Typical use |
|---|---|---|
| M3 | 1.0–1.3 N·m | Components, lidar |
| M4 | 2.5–3.0 N·m | Brackets, plate |
| M5 | 5.0–6.0 N·m | Motor/gearbox mounts |
| M6 | 8.5–10 N·m | Frame, tripod interface |

Use washers under SHCS heads on aluminum; medium threadlocker on all dynamic/vibrating joints; do **not** thread metal fasteners directly into printed plastic — use heat-set inserts.

---

## 4. Overview — exploded assembly

![Exploded view](proimg/d1_exploded_full.png)

Assembly order runs bottom → top. Items 5 and 8 (motor + gearbox) mount off-axis and couple in through the reduction.

---

## 5. Reference interfaces (standard dimensions)

![NEMA 23 interface](proimg/pa1_nema23_interface.png)

![Tripod interface](proimg/pa5_tripod_interface.png)

The NEMA 23 pattern (56.4 mm frame, 47.14 mm bolt pattern, Ø38.1 mm pilot, 4 × M5) is standard for both motor and gearbox input — **confirm against the datasheets of the exact units purchased.** The tripod interface uses a bolt circle plus an anti-rotation key.

---

## 5a. Confirmed drivetrain (motor + gearbox)

Both axes use the same matched pair: a **NEMA 23 closed-loop 3.0 N·m motor (PN 23HS45-4204D-E1000) + CL57T driver** kit driving a **5:1 planetary gearbox with an Ø8 input bore** (15 arcmin backlash). The Ø8 motor shaft matches the Ø8 gearbox bore, and the Ø38.1 pilot + 47.14 pattern mate directly. Torque at each axis ≈ 3.0 × 5 = **15 N·m**.

![Pan drive connection](proimg/c1_pan.png)

![Tilt drive connection](proimg/c2_tilt.png)

The gearbox **output** is identical on both axes — Ø14 h7 shaft (5 mm key, M5×12 end-tap), Ø40 h7 register, 4×Ø5.2 flange holes on 47.14 — so the face machined into the pan base plate and the tilt yoke wall is the same:

![Gearbox-output mounting face](proimg/pa6_mount_interface.png)

---

## 6. Assembly procedure

### Step 1 — Tripod adapter & pan bearing
![Tripod interface](proimg/pa5_tripod_interface.png)

Fit the anti-rotation key/pins and mount the adapter to the pan bearing's lower race. Bolt circle per **J**, M6 @ 8.5–10 N·m, threadlocked. **QC:** adapter face square to the bearing axis (combination square); the bearing rotates freely with no axial play.

### Step 2 — Pan motor, gearbox & turntable
![Pan module section](proimg/pa2_pan_section.png)

Bolt the 5:1 gearbox to the pan motor (PA-1 pattern, M5 @ 5–6 N·m). Mount the assembly to the frame and couple the output to the turntable through the reduction — **the bearing carries the load, never the motor shaft.** Mount the turntable to the bearing upper race. **QC:** turntable runout ≤ 0.05 mm TIR (dial indicator); free rotation, even torque through 360°.

### Step 3 — Tilt yoke
Mount the yoke to the pan turntable, width **W**, square to the pan axis. M5/M6 per schedule, dowel-pinned if possible. **QC:** yoke faces parallel; tilt-bearing bores will sit co-axial (check in Step 4).

### Step 4 — Tilt shaft, bearings & motor
![Tilt module front](proimg/pa3_tilt_section.png)

Install the two tilt bearings in the yoke (span **D**), slide the shaft (Ø **E**) through, and set axial position with collars. Mount the tilt motor + gearbox to one yoke wall and couple to the shaft. **QC:** shaft runout ≤ 0.05 mm TIR; tilt axis perpendicular to pan axis ≤ 0.5°; no bind through full tilt travel.

### Step 5 — Tilt-output interface plate
![Interface plate](proimg/pa4_interface_plate.png)

Clamp the **generic interface plate** to the tilt shaft (holes **H**). This is the gimbal's payload mount and is **payload-agnostic** — a Ø70 bolt circle (4×M5), a Ø30 h7 centering pilot, and 2×Ø4 dowel pins. The printed payload module bolts to this exact pattern; the dowels make it repeatable so the payload can be removed and reinstalled without losing bore-sight. **QC:** plate face square to the tilt axis (≤0.5°); pilot concentric to the shaft; dowels located. The payload itself is built and balanced per `Payload_Top_Module.pdf`.

### Step 6 — Alignment, backlash & balance
![Assembly sequence](proimg/d6_assembly_sequence.png)

Final alignment and acceptance — see §7.

---

## 7. Acceptance / QC checks

| Check | Method | Target |
|---|---|---|
| Pan axis ⟂ base | Square / angle gauge | ≤ 0.5° |
| Tilt axis ⟂ pan axis | Square / angle gauge | ≤ 0.5° |
| Shaft / turntable runout | Dial indicator (TIR) | ≤ 0.05 mm |
| Output backlash (each axis) | Indicator at output, reverse load | ≤ 0.1° (planetary) |
| Travel | Manual sweep, full range | No bind; smooth, even torque |
| Balance | Power off (worm) or holding current | CG ≤ 10 cm from tilt axis; holds any elevation |

---

## 8. Notes for the fabricator

- Treat all frame members and bearing/shaft fits as the structural priority — recoil + ~10 lb payload load the joints dynamically. Use dowel pins on critical alignments, not bolts alone.
- Bearing fits: shaft to inner race typically a slip fit (g6/h6); housing to outer race a light interference (H7). Confirm against the chosen bearings.
- If using belt reduction, add a tensioner/idler and set tension per the belt spec; if planetary, mount concentric to the axis and check output backlash.
- Keep the design serviceable: the interface plate, motors, and tripod adapter should be removable without disassembling the whole stack. The payload module separates at the PA-4 interface.

---

## 9. Dimension schedule

To be finalized from the part scans and final frame sizing. Standard interface dimensions (NEMA 23 pattern, fastener sizes) are fixed in the drawings above.

| Ref | Dimension | Value (to confirm) |
|---|---|---|
| A | Pan plate width | TBD from frame |
| B | Pan stack height | TBD from frame |
| C | Pan bearing bore | TBD from bearing (shaft/coupling through = Ø14) |
| D | Tilt bearing span | TBD from payload width |
| E | Tilt drive shaft | **Ø14** (gearbox output); far-side trunnion TBD |
| W | Tilt yoke width | TBD from payload |
| H | Interface-plate hub bore | **Ø14** (on gearbox output shaft) |

**Interface spec — defined (not TBD):** plate Ø90 · bolt circle Ø70 with 4×M5 · centering pilot Ø30 h7 · 2×Ø4 dowel pins at ±25 mm. The payload module mates to this exact pattern. (Payload plate length/width move to the payload-module spec, where they are scan-driven.)

**Gearbox-output mounting — defined (PA-6), same on both axes:** Ø40 H7 pilot bore · 4×M5 tapped @ 47.14 · Ø16 shaft/coupling clearance bore. Each drive unit (motor + gearbox) ≈ **205 mm** long (motor 56.4□ × 138 + gearbox 57□ × 67).
| J | Tripod bolt circle | TBD from tripod |

---

*Revision A, pre-scan. Re-issue with the schedule populated and component hole patterns dimensioned once the marker, payload, and frame are measured/scanned.*
