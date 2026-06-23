# Drive & cabling scheme

How the two axes are driven and how cables cross them. Decided before the FreeCAD
frame work so the bore, service loops, and what‑crosses‑what are locked in.

## Drive
- **Pan (yaw):** the **lazy‑susan slew bearing** carries the load/moment; a **NEMA 23
  closed‑loop + 5:1 planetary** drives pan from **under the base**, its output coming
  **up through the bearing's open center** and clamping the turntable via a Ø14 hub.
  No exposed ring gear — the bearing bears, the gearbox reduces.
- **Tilt (pitch):** **NEMA 23 closed‑loop + 5:1 planetary** drives one side via a
  **clamp hub**; the far side rides a **trunnion bearing** (McMaster 5968K71 + shoulder
  screw). Stiff, low backlash, no exposed gear.

## Cabling principle — through the bore, no slip ring
Cables cross the pan axis **through the lazy‑susan's open center** (bore ≈ **144 mm**,
hub ≈ Ø14 → a large annular gap) as a **service loop** — never wrapped around the
outside. The tilt axis uses a short **service loop** at the pivot.

**No slip ring is needed**, because the **pan sweep is limited to 90°/180°** (see
[Operations.md](Operations.md)). This is deliberate:
- A service loop easily covers ±90°.
- The **ZED USB 3.0 will not pass cleanly through a slip ring** (USB3 slip rings are
  costly/finicky) — a service loop keeps USB3 intact.

## What crosses each axis
Assumes the **Pico + CL57T drivers + IMU live on the static pan base** (below the
slew), where the umbilical lands.

- **Pan axis (base → turntable), through the bore:**
  tilt‑motor power + tilt encoder leads · ZED USB 3.0 · TF03 lidar · solenoid 12 V ·
  armed/safe LED. (The **IMU stays on the static base** — senses level without
  pan‑angle compensation, so it does *not* cross the pan axis.)
- **Tilt axis (turntable/yoke → payload), service loop:**
  ZED USB 3.0 · lidar · solenoid · LED.

## Service‑loop sizing (frame design)
- Size the bore loop for the **full pan travel** (the operator can set the sweep
  *center* anywhere within the allowed range, plus ±90° sweep) — confirm the total
  pan travel envelope when sizing.
- Keep a strain‑relieved service loop at the tilt pivot for the limited tilt range.
- Bundle + sleeve everything; anchor on both sides of each axis so the loop flexes,
  not the connectors.

## Why this beats the "wires draped outside" approach
External wrap (common on hobby turrets) drags, limits travel, and fatigues
connectors. Through‑bore + service loops keeps the bundle central, protected, and
predictable — and the limited sweep means we get all that without a slip ring.

> Cross‑refs: bore/bolt‑circle dims in [Bearing_Dimensions.md](Bearing_Dimensions.md);
> sweep limits in [Operations.md](Operations.md).
