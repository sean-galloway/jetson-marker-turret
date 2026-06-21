# NEMA 23 Pan/Tilt Gimbal — Assembly Drawings

Schematic assembly drawings for the closed-loop pan/tilt gimbal. These are illustrative and **not to scale** — dimensioned working drawings follow once the scanned part geometry and final frame sizes are in hand. Use them for assembly order, part relationships, and interface intent.

Companion files: `Gimbal_Build_Plan_Illustrated.pdf` (design rationale and sizing) and `Turret_Full_Parts_List.xlsx` (parts and SKUs).

---

## DWG 1 — Exploded view, full assembly

![Exploded full assembly](drawings/d1_exploded_full.png)

**Parts key**

| # | Part | # | Part |
|---|---|---|---|
| 1 | Tripod (bowl mount) | 6 | Tilt yoke / riser |
| 2 | Tripod adapter + anti-rotation plate | 7 | Tilt shaft + bearing blocks (pair) |
| 3 | Pan slew / thrust bearing | 8 | Tilt motor + 5:1 gearbox |
| 4 | Pan turntable | 9 | Payload plate (3D-printed) |
| 5 | Pan motor + 5:1 gearbox | 10 | Payload: marker / ZED / lidar / Pi enclosure |

Assembly runs bottom → top. Items 5 and 8 (the motors + gearboxes) mount off-axis and couple in through the reduction.

---

## DWG 2 — Pan module

![Pan module](drawings/d2_pan_module.png)

The turntable rides on the slew/thrust bearing, which carries the payload and all moment loads. The motor + gearbox couples to the turntable through the reduction. **The motor shaft only transmits torque — it never carries the payload.** The adapter plate below the bearing is keyed to the tripod (DWG 5).

---

## DWG 3 — Tilt module

![Tilt module](drawings/d3_tilt_module.png)

The tilt shaft runs in two bearing blocks on the yoke; the motor + gearbox drives one end. The payload plate clamps to the shaft. **Balance the payload so its CG sits within ~10 cm of the tilt axis** — that single number sets the holding torque, the motor heat, and the recoil margin.

---

## DWG 4 — Payload plate (top view)

![Payload plate top view](drawings/d4_payload_plate.png)

The 3D-printed plate that bolts to the tilt shaft. Lay out the marker (with its solenoid/trigger bracket), the ZED 2i, and the TF03 lidar so the camera, lidar, and muzzle share **one bore axis**. Place the heavy items to bring the combined CG over the tilt axis. The Pi enclosure mounts here too (HAT stack + active cooler). This plate and the Pi enclosure are the printed pieces that come out of the original scan-and-fit work.

---

## DWG 5 — Tripod interface (pan base, bottom)

![Tripod interface](drawings/d5_tripod_interface.png)

The underside of the pan base: a bolt circle plus an anti-rotation key/pins seat onto the tripod's bowl. The bolt circle and key together resist pan reaction torque — **never mount on a single 3/8"-16 stud**, or the whole gimbal counter-rotates when the pan motor accelerates.

---

## DWG 6 — Assembly sequence

![Assembly sequence](drawings/d6_assembly_sequence.png)

1. Mount the slew bearing + adapter to the tripod.
2. Pan motor/gearbox + turntable; confirm free rotation on the bearing.
3. Tilt yoke onto the turntable.
4. Tilt shaft + bearing blocks + tilt motor.
5. Payload plate; balance the CG to within ~10 cm of the tilt axis.
6. Wire drivers / Pico / power; run home → level → bore-sight.

---

## DWG 7 — Cable routing & service loops

![Cable routing](drawings/d7_cable_routing.png)

Leave slack at **both** axes so motion never tugs a connector — a service loop at the pan axis for the Ethernet run down to the Jetson, and a loop at the tilt axis for the payload harness. Clamp harnesses to the structure, and keep signal runs (IMU, lidar, encoder feedback) physically separated from the motor and solenoid power runs to limit coupling.

---

*All drawings are schematic. Re-issue as dimensioned drawings once the frame is sized and the scans are in.*
