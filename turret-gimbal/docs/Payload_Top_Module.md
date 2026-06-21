# Printed Payload Module — Specification

The 3D-printed "top" that carries the marker, cameras, lidar, Pi, and trigger, and bolts to the gimbal's **tilt-output interface plate (PA-4)**. The gimbal is payload-agnostic and built separately; this module is the only scan-driven part of the system.

Companion files: `Gimbal_Assembly_Guide.pdf` (the gimbal it mounts to), `Turret_Full_Parts_List.xlsx`.

---

## 1. Mounting interface (mates to PA-4)

The module's underside carries the mating pattern of the gimbal interface — **fixed, not adjustable:**

- Bolt circle **Ø70 mm**, 4 × M5 clearance
- Centering pilot **Ø30 mm** (recess over the gimbal's h7 spigot)
- **2 × Ø4 mm dowel holes** at ±25 mm

The dowels locate the module repeatably, so it can be removed and reinstalled without losing bore-sight calibration. Use **heat-set inserts** or metal fasteners through the printed part into the interface — never thread a metal bolt directly into plastic.

![Interface plate (gimbal side)](proimg/pa4_interface_plate.png)

---

## 2. Envelope — the contract with the gimbal

The module must stay inside the envelope the gimbal was sized for. If it grows past this, the gimbal must be resized.

| Constraint | Limit |
|---|---|
| Total mass (everything on the module) | ≤ 10 lb |
| Combined CG distance from tilt axis | ≤ 100 mm |
| Bounding box (tilt clearance) | within frame envelope (confirm vs. final gimbal frame) |

---

## 3. Component layout

![Payload module layout](proimg/pt1_payload_module.png)

- **Marker** on its cradle, with the **solenoid/trigger bracket** referencing the actual trigger (from scan).
- **ZED 2i** and **TF03 lidar** co-aligned with the muzzle on **one bore axis**.
- **Pi enclosure** (HAT stack + active cooler) positioned to help bring the combined CG over the tilt axis.
- Heavy items placed to land the **CG within 100 mm of the tilt axis**.

---

## 4. Component mounting (sources)

| Component | Interface | Source |
|---|---|---|
| Marker cradle + trigger bracket | clamp + solenoid mount | **Marker scan** (trigger, mounting surface, muzzle) |
| ZED 2i | 1/4-20 + flat | datasheet + caliper check |
| TF03 lidar | M3 pattern | datasheet + caliper check |
| BNO055 IMU (DFRobot Gravity SEN0253) | standoffs (board mtg holes) | breakout dims |
| Pi 5 + HAT + cooler | M2.5 standoffs + port cutouts | measured envelope |

---

## 5. Bore-sight

Mount the ZED, lidar, and marker muzzle to a common bore axis so the perception range and the projectile path agree. The hand-eye (checkerboard) calibration refines the residual; the dowel-located interface preserves it across module removal.

---

## 6. Print & material notes

- **Material:** CF-nylon or ASA for stiffness and outdoor durability; PETG acceptable for lighter loads. The module is semi-structural — it resists marker recoil — so design with ribs and generous walls/infill, not a thin plate.
- **Metal threads:** heat-set inserts for the 1/4-20 (ZED), M3 (lidar), M2.5 (Pi/IMU), and the M5 interface bolts.
- **Marker recoil:** if recoil is significant, back the marker cradle with a metal sub-bracket rather than relying on plastic alone.
- **Cable management:** service loop at the tilt axis; route signal away from motor/solenoid power.

---

## 7. Inputs needed to finalize

1. **Marker scan** — trigger + guard, mounting surface, muzzle/bore line, full envelope (include hopper/air **if** they ride on the module).
2. ZED, lidar, Pi-stack, IMU dimensions (caliper/datasheet).
3. Confirmation of the bounding-box limit once the gimbal frame is sized.

With those, this becomes a printable **STL/STEP** — closing the loop to the original goal.
