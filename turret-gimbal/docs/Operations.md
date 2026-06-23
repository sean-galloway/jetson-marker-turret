# Operations — manual / RC mode (concept of operations)

How an operator sets up and runs the turret by hand with the **RadioMaster TX16S**.
This is **motion only** — the **arm switch is OFF** the entire time (the firing path
is dead). Matches the locked rule: *validate motion with the trigger disarmed.*

## Safety preamble
- **Arm switch OFF** (hardware interlock open → solenoid cannot fire).
- **E-stop** reachable at all times; it drops both rails regardless of the radio.
- **RC failsafe / signal loss → Pico stop-and-hold.**
- All sweep motion stays within the mechanical limits (homing/limit switches).

## Setup sequence
1. Power up; turret homes its axes (limit/homing switches → absolute reference).
2. **Level:** press the **Level** button → the Pico drives **tilt to true horizon**
   from the IMU and resets the orientation reference. (Roll can't be actuated by a
   pan/tilt gimbal — level the tripod if the base roll is off; the radio reports it.)
3. **Aim center:** with the sticks, jog pan/tilt so the **barrel points at the
   desired center of the field of view**.
4. **Center:** press the **Center** button → the current barrel heading (and tilt)
   becomes the **zero / sweep center**.

## Range of motion
- Selectable **90°** or **180°** pan arc (switch). Both are **centered on the barrel**
  heading captured at step 4 (so ±45° or ±90° about center).

## Sweep
- **Sweep switch** enables auto-sweep: the turret pans back and forth across the
  selected arc, centered on the set center.
- **Speed knob** sets sweep rate (creep → fast).
- **Sweep-pause switch:** when ON, the turret **dwells 5 s at each 45° increment**
  across the arc, **including the two arc ends** (where it dwells, then reverses).
  E.g. a 180° arc pauses at −90, −45, 0, +45, +90 relative to center; a 90° arc at
  −45, 0, +45 — a scanning-sentry dwell. (With pause OFF, it dwells 0 s and just
  reverses at the ends.)
- Turning the sweep switch off returns to manual stick control.

## Motion-enable (dead-man)
- Motion requires the **enable switch held** (dead-man). **Release → stop-and-hold**
  immediately — for manual jog *and* sweep. (Held for now; may revisit a latched
  mode for long unattended sweeps later.)

## Suggested TX16S control map (configure in EdgeTX; Pico just reads channels)
| Control | Function |
|---------|----------|
| Right stick X / Y | Manual pan / tilt jog (rate) |
| Pot S1 | Sweep speed |
| Switch SA | Motion-enable (dead-man) |
| Switch SB | Range of motion: 90° / 180° |
| Switch SC | Sweep on / off |
| Switch SD | Sweep-pause on / off |
| Momentary (SH) | Center (set zero / sweep center) |
| Momentary / trim button | Level |

The exact switch→channel assignment lives in the EdgeTX model; the Pico decodes
CRSF channels and maps them to these functions.
