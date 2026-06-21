# Gimbal Plates — SendCutSend Order Spec

Six flat plates, all **6061-T6 aluminum, 6 mm (0.25")**. Upload the matching DXF for each, set material/thickness/qty below, and use SendCutSend's instant preview to check before paying. All holes are clearance holes — **no tapping, no precision bores** (assemble with nuts; the gearboxes locate on their bolt pattern).

![Plate set](plates_render.png)

## Order table

| File (DXF) | Part | Material | Thick | Qty | Finishing |
|---|---|---|---|---|---|
| `02_base_plate_pan.dxf` | Pan base plate | 6061-T6 | 6 mm | 1 | Deburr |
| `03_turntable_plate.dxf` | Turntable plate | 6061-T6 | 6 mm | 1 | Deburr |
| `04_yoke_side_gearbox.dxf` | Yoke side – gearbox | 6061-T6 | 6 mm | 1 | Deburr |
| `05_yoke_side_trunnion.dxf` | Yoke side – trunnion | 6061-T6 | 6 mm | 1 | Deburr |
| `01_interface_plate_PA4.dxf` | Interface plate (PA-4) | 6061-T6 | 6 mm | 1 | Deburr |
| `06_tripod_adapter.dxf` | Tripod adapter | 6061-T6 | 6 mm | 1 | Deburr |

Units in the files are **millimeters**. If SendCutSend reads them as inches, set the import unit to mm. Tapping/countersink add-ons are optional — the build uses clearance holes + nuts.

## Exact (locked) holes — these are correct as drawn

- **Gearbox flange** (base plate + gearbox yoke side): 4×Ø5.5 on the **47.14 mm** square pattern, with a **Ø42** center clearance for the register + Ø14 shaft. From your gearbox datasheet — final.
- **Interface plate (PA-4)**: Ø70 bolt circle, 4×Ø5.5; 2×Ø4 dowels at ±25 mm; Ø14.5 center. Final.

## ⚠ Verify / adjust before cutting — these use assumed dimensions

These holes depend on parts you haven't finalized. Confirm against the actual part (or send me the part and I'll lock them):

1. **Slew-bearing bolt circle** (plates 02 & 03) — drawn as **Ø100, 6×M5**. Change to your bearing's actual pattern + center bore.
2. **Trunnion bearing** (plate 05) — drawn as a **2-bolt pillow block, Ø30 bore, ±40 mm bolts**. Match your bearing.
3. **Tripod head pattern** (plate 06) — drawn as a **Ø10 center + 4×Ø5 at ±20 mm**. Change to your tripod head (a photo lets me set it exactly).
4. **Plate outline sizes & frame heights** — set to reasonable defaults (120 mm plates, 150 mm yoke sides). Fine to cut as-is; adjust if your layout differs.

So: the gearbox and payload interfaces are final; the **bearing and tripod holes are placeholders** to confirm. SendCutSend's preview + per-part quote means a draft upload costs nothing until you order.
