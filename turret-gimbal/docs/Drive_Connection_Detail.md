# Drive Connection Detail — Pan, Tilt & Join

How the NEMA 23 motor + 5:1 planetary gearbox connect on each axis, drawn to the dimensions from your datasheets (mm).

> **⚠ Compatibility flag:** the motor's output shaft is **Ø8 mm**, but this gearbox's input bore is **Ø6.35 mm (1/4")**. The pilot (Ø38.1) and bolt pattern (47.14) match — only the shaft/bore does not. You need a motor with a 6.35 mm shaft, or this gearbox bored for 8 mm, before anything else mates.

---

## Pan axis

![Pan connection](conn/c1_pan.png)

Motor bolts to the gearbox input (Ø38.1 register, 47.14 pattern). The gearbox **output flange** (4×Ø5.2 through @ 47.14, Ø40 h7 register) bolts to the **fixed base plate**; the **Ø14 output shaft** (key 5, end-tap M5×12) passes through and drives the **rotating turntable**. The slew bearing carries the payload and tipping loads — the shaft only transmits torque.

---

## Tilt axis

![Tilt connection](conn/c2_tilt.png)

Same motor+gearbox. The output flange bolts to the **fixed yoke wall** (Ø40 H7 pilot bore + 4×M5 tapped @ 47.14). The Ø14 shaft drives the **tilt interface plate**, which carries the PA-4 payload pattern (Ø70 BC, Ø30 pilot, 2 dowels) on its outboard face. A bearing in the far yoke wall supports the opposite end.

---

## How they join

![Pan + tilt join](conn/c3_join.png)

The pan unit sits at the base (motor + gearbox below the fixed base plate); the turntable pans on the slew bearing. The tilt yoke rides on the turntable, the tilt unit drives the interface plate about the horizontal axis, and the printed payload module bolts to PA-4. Each axis follows the same rule: motor → gearbox → flange to structure, shaft drives the moving part.

---

*Dimensions from the supplied motor and gearbox datasheets. Schematic sections — confirm the gearbox output flange pattern and pilot against the physical part before machining the base plate / yoke.*
