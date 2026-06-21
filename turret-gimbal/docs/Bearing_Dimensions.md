# Lazy-Susan Pan Bearing — Measured Dimensions

Aluminum two-ring ball-bearing turntable used for the **pan (yaw) axis**.
Two concentric rings ride on a row of balls in the center seam; one ring bolts
to the fixed base, the other to the rotating pan platform.

## Construction notes
- Each mounting hole is a **through-hole, countersunk on one face, plain on the other**.
  - **Outer ring:** countersunk on the **top** face → M4 flat-head screws drop in
    flush and thread **down into the fixed base plate**.
  - **Inner ring:** countersunk on the **bottom** face → M4 flat-head screws go in
    flush and thread **up into the rotating pan platform**.
- Flush heads sit in the countersinks so nothing rubs during rotation.
- The white "daisy" **nylon glide caps** plug the holes you are *not* screwing into,
  acting as wear pads / spacers. Pull a cap, drive a flat-head screw.

## Measured (calipers, mm)
| Feature | Value | How measured |
|---|---|---|
| Metal ring thickness (face-to-face, bare metal) | **8.93** | jaws on plain rim |
| Thickness incl. one glide proud | 13.12 | glide protrudes ~4.2 mm / face |
| Thickness incl. both glides | 17.18 | ~4.1 mm proud each face |
| Mounting hole diameter (plain side) | **4.54** | → M4 flat-head screws |
| Outer ring: far-edge to far-edge, opposite holes (F) | 193.2 | caliper tips in opposite holes |
| Inner ring: far-edge to far-edge, opposite holes (F) | 161.58 | caliper tips in opposite holes |
| Overall outer diameter (OD) | **201.54** | big jaws across outer edge |
| Center bore inner diameter (ID) | **144.36** | inside jaws across center hole |

## Derived
| Feature | Value | Formula |
|---|---|---|
| **Outer ring bolt circle (BCD)** | **188.66 mm** | F − d = 193.2 − 4.54 |
| **Inner ring bolt circle (BCD)** | **157.04 mm** | F − d = 161.58 − 4.54 |
| Radial gap between bolt circles | 15.81 mm | (BCD_o − BCD_i) / 2 |
| Ring radial width | 28.59 mm | (OD − ID) / 2 |
| Outer bolt circle inset from outer edge | 6.44 mm | (OD − BCD_o) / 2 |
| Inner bolt circle inset from bore edge | 6.34 mm | (BCD_i − ID) / 2 |
| Ball-race (seam) diameter, approx | ~172.9 mm | midway between bolt circles |

**Consistency check:** both bolt circles sit ~6.4 mm from their own edge — symmetric,
measurements are self-consistent.

## Screw spec
- **M4 flat-head (countersunk) machine screws.** Hole 4.54 mm = M4 clearance;
  countersink ~8 mm mouth from photos = standard M4 flat head. Heads sit flush.

## Hole pattern
- **4 holes per ring, spaced 90° apart** (8 holes total).
- Inner and outer holes are **paired at each of the 4 stations** (one inner + one
  outer hole at top, bottom, left, right), straddling the ball-race seam.

## STILL TO CONFIRM
- [ ] Clocking: confirm the 4 stations are exactly 90° and whether inner/outer
      pairs share the same angular spoke (assumed yes from photos).
- [ ] Screw length into base & platform plates (depends on plate thickness — TBD)
