# Paintball Turret — Bolt-Together BOM

> Sections A–D: the turret system (payload on the gun · compute on the tripod · displays · power/wiring). Sections E–G: the bolt-together gimbal — BUY catalog · CUT (DXF, SendCutSend) · HAVE. Owned items are priced $0 so they stay out of the totals.

**Tick the box in the far-left column once an item is purchased** (change `[ ]` to `[x]`). Items already owned are pre-ticked.

## A.  PAYLOAD — ON THE TURRET

| Bought | # | Item | Spec | Qty | Unit $ | Line $ | P/N / Source | Notes | Link |
|:------:|:--|:-----|:-----|:---:|:------:|:------:|:-------------|:------|:----:|
| [x] | 1 | Paintball marker | Bore-sighted reference for the ZED | 1 | $0 | $0 | owned | Owned. Bore aligns to the pan axis; hopper top-rear. |  |
| [ ] | 2 | Push-pull solenoid (trigger) | 12 V, 1 A, 20 N, 10 mm stroke | 1 | $13.99 | $13.99 | TOMMSILE 0837B-12V (Amazon) | Trigger actuator; 12 V switched. 20 N is end-of-stroke; confirm trigger force after marker scan. |  |
| [ ] | 3 | Arming switch (SPST toggle) | SPST latching, 10 A DC @ 12 V, pre-wired; in the 12 V solenoid line | 1 | $7.99 | $7.99 | Taiss KNS-1 (2-pack, Amazon) | HARDWARE INTERLOCK: open = cannot fire. Safety-critical. |  |
| [ ] | 4 | Laser sight (boresight aid) | Mounts on top of the barrel | 1 | $15 | $15 | generic | Zero to impact point at a set range, like a rifle. |  |
| [x] | 5 | ZED 2i stereo camera | 4 mm, polarizer; USB 3.0 | 1 | $0 | $0 | Stereolabs ZED 2i 4mm | Owned (~$549). Boresighted below the barrel; routes to the Jetson. |  |
| [x] | 6 | ZED USB3 locking cable (3 m) | USB 3.0 Type-C locking | 1 | $0 | $0 | Stereolabs | Owned. |  |
| [ ] | 7 | 10-DOF IMU (BNO055 + BMP280) | I2C Gravity plug (no solder); run IMU mode (no mag) | 1 | $25.90 | $25.90 | DFRobot Gravity SEN0253 | Leveling + stabilization; rigid to platform. Use IMU (no-mag) mode near steppers. Local I2C to the on-turret Pico (short run; no extender). | [link](https://www.dfrobot.com/product-1793.html) |
| [ ] | 8 | Benewake TF03 lidar (100 m) | Single-point rangefinder; UART/CAN; IP67 | 1 | $220 | $220 | TF03-100 | Boresighted to the muzzle; range along the line of fire. |  |
| [ ] | 9 | Armed/Safe LED indicator | Red+green LEDs + resistors; hardware-tied | 1 | $3 | $3 | generic | RED ARMED off the armed rail (hardware-true); GREEN SAFE. On the turret. |  |

## B.  COMPUTE & CONTROL — ON THE TRIPOD

| Bought | # | Item | Spec | Qty | Unit $ | Line $ | P/N / Source | Notes | Link |
|:------:|:--|:-----|:-----|:---:|:------:|:------:|:-------------|:------|:----:|
| [x] | 10 | NVIDIA Jetson AGX Orin 32 GB | Vision/targeting module | 1 | $0 | $0 | AGX Orin 32GB | Owned. Perception/targeting. |  |
| [ ] | 11 | Raspberry Pi 5 (8 GB) | Supervisor | 1 | $80 | $80 | SC1112 | Setpoints, IMU/lidar, arming, state. |  |
| [ ] | 12 | Pi 5 Active Cooler | — | 1 | $5 | $5 | SC1148 | Pi 5 throttles without it. |  |
| [ ] | 13 | Pi 27 W USB-C PD supply | 5.1 V / 5 A | 1 | $12 | $12 | SC1158 | Powers the Pi + HAT reliably. |  |
| [ ] | 14 | microSD 64 GB A2 | — | 1 | $10 | $10 | SanDisk SDSQXAV-064G | Pi OS / boot. |  |
| [ ] | 15 | Solenoid driver HAT (8-MOSFET) | I2C; solid-state | 1 | $45 | $45 | Sequent Eight-MOSFETS | Trigger drive; the only HAT on the stack now. |  |
| [ ] | 16 | GPIO stacking header, 2×20 tall | — | 1 | $3 | $3 | Adafruit 2223 | Passes GPIO up past the HAT. |  |
| [ ] | 17 | Top-of-stack GPIO breakout / proto-HAT | — | 1 | $8 | $8 | Adafruit 2310 | Expose SPI (IMU), UART (lidar + Pico), spare GPIO. |  |
| [ ] | 18 | Brass standoff / spacer kit (M2.5) | — | 1 | $8 | $8 | generic | Mount/space the HAT + Pi. |  |
| [ ] | 19 | Limit / homing switches | microswitch; GPIO to Pico | 2 | $3 | $6 | generic | One per axis → power-up homing → absolute aiming. |  |
| [ ] | 20 | Pico RP2040 | Motion coprocessor (step/dir) | 1 | $5 | $5 | Raspberry Pi Pico | Drives both CL57T. ON THE TURRET with the drivers; reads IMU/limits/LED locally. |  |
| [ ] | 21 | Pico debug OLED (SSD1306) | 128×64; I2C | 1 | $9 | $9 | Adafruit 938 | Pico debug: current routine/state, step/dir, homing, heartbeat, faults. |  |

## C.  DISPLAYS & CALIBRATION

| Bought | # | Item | Spec | Qty | Unit $ | Line $ | P/N / Source | Notes | Link |
|:------:|:--|:-----|:-----|:---:|:------:|:------:|:-------------|:------|:----:|
| [x] | 22 | 1U rack display — Pi 5 (GeeekPi 6.91") | 1424×280 touch, 1U rack mount | 1 | $89.99 | $89.99 | GeeekPi 6.91" 1U | Pi 5 status/console bar. Bought; price est. |  |
| [x] | 23 | 1U rack display — Jetson (GeeekPi 6.91") | 1424×280 touch, 1U rack mount | 1 | $89.99 | $89.99 | GeeekPi 6.91" 1U | Jetson perception/status bar. Bought; price est. |  |
| [x] | 24 | Checkerboard calibration target | Rigid flat backing | 1 | $0 | $0 | owned | Owned. Camera + boresight calibration. |  |
| [ ] | 25 | micro-HDMI → HDMI cable | — | 1 | $7 | $7 | generic | Pi 5 micro-HDMI → 6.91" display. |  |
| [ ] | 26 | DisplayPort → HDMI adapter | — | 1 | $9 | $9 | generic | AGX Orin DP → 6.91" display; verify. |  |

## D.  POWER & WIRING

| Bought | # | Item | Spec | Qty | Unit $ | Line $ | P/N / Source | Notes | Link |
|:------:|:--|:-----|:-----|:---:|:------:|:------:|:-------------|:------|:----:|
| [ ] | 27 | 12 V DC supply (≥3 A) | Solenoid rail | 1 | $16 | $16 | Mean Well GST60A12 | Solenoid only (motors on 24–48 V). Or buck from 48 V for one supply. |  |
| [ ] | 28 | Inline fuse holders + fuses | ATC | 1 | $8 | $8 | generic | Fuse the 24–48 V and 12 V rails; tie ALL grounds together. |  |
| [ ] | 29 | Ethernet cable, Cat6 (short) | — | 1 | $6 | $6 | generic | Direct Pi↔Jetson; service loop on the motion run. |  |
| [ ] | 30 | Jumper wires (DuPont M-F, M-M) | — | 1 | $7 | $7 | generic | Signals: IMU, lidar, Pico, switches. |  |
| [ ] | 31 | Hookup wire, 18–20 AWG | — | 1 | $10 | $10 | generic | Motor, solenoid, power runs. |  |
| [ ] | 32 | Wire ferrules / crimp terminals | — | 1 | $9 | $9 | generic | Driver/terminal terminations. |  |

## E.  BUY — CATALOG PARTS

| Bought | # | Item | Spec | Qty | Unit $ | Line $ | P/N / Source | Notes | Link |
|:------:|:--|:-----|:-----|:---:|:------:|:------:|:-------------|:------|:----:|
| [ ] | 33 | Motor + driver kit | NEMA 23 closed-loop 3.0 N·m + CL57T V4.1 | 2 | $85.99 | $171.98 | 23HS45-4204D-E1000 / Amazon B0C6943QBM | STEPPERONLINE Closed Loop Stepper Motor 1 Axis CNC KIT 2.0 Nm/283.28oz.in Nema 23 Motor & 0-8.0A 24-48VDC Closed Loop Stepper Driver CL57T V4.1 |  |
| [ ] | 34 | Planetary gearbox 5:1 | NEMA 23, Ø8 bore, 15 arcmin; out Ø14 / Ø40 reg / 4×Ø5.2@47.14 | 2 | $57.99 | $115.98 | Ratio 5:1 Nema 23 … φ8mm | Ratio 5:1 Planetary Gearbox for Nema 23 Stepper Motor 57-67mm Backlash 15 arcmin Input Shaft 21mm φ8mm Planetary Reducer for 57 Step Motor |  |
| [ ] | 35 | Turntable bearing (lazy susan) | Heavy-duty steel/alu, OPEN center, 6–8 in | 1 | $20 | $20 | Search "turntable bearing" / "lazy susan bearing" · McMaster: Ball Bearing Turntables · `193019173251` | 8INCH-SWIVEL-LAZY-SUSAN — **measured part: see [Bearing_Dimensions](turret-gimbal/docs/Bearing_Dimensions.md)** | [link](https://vxb.com/checkouts/cn/hWNDQZKNqS7FLBgAANhKclaa/en-us/thank-you?_r=AQABSTga-mN3Yrg_UjagK1rtzQSFz0x6rcQo9Jd1a6PLjnA&skip_shop_pay=true) |
| [ ] | 36 | Mounted ball bearing (tilt) | Flange-mount or pillow block; bore = pin Ø (e.g. 1/2") | 1 | $15 | $15 | McMaster: "mounted ball bearing" · `5968K71` | Match pattern to plate 05 | [link](https://www.mcmaster.com/products/mounted-ball-bearings/mounted-ball-bearings-with-two-bolt-flange~~/mounted-bearing-type~two-bolt-flange-mount/) |
| [ ] | 37 | Mounting hub | Clamps gearbox Ø14 shaft → bolts to plate; bore 14 mm | 2 | $18 | $36 | McMaster: "mounting hub" · Ruland · `FHT-MCL-14-SS` | Or rigid shaft coupling; no keyway | [link](https://www.ruland.com/fht-mcl-14-ss.html#) |
| [ ] | 38 | Shoulder screw (tilt pin) | Shoulder Ø = #36 bearing bore (e.g. 1/2") | 1 | $8 | $8 | McMaster: "shoulder screw" · `90298A716` | Far end of tilt axis; pairs with #36 | [link](https://www.mcmaster.com/products/shoulder-screws/shoulder-diameter~1-2/shoulder-length~1-1-2/) |
| [ ] | 39 | L-brackets / gussets | Join yoke side-plates to turntable + stiffen | 8 | $4 | $32 | 8020 / McMaster | Bolt-together corners | [link](https://www.mcmaster.com/products/l-brackets/brackets-1~/) |
| [ ] | 40 | Standoffs | M5, raise base plate over tripod adapter | 4 | $3 | $12 | McMaster | Length = motor/gbx clearance |  |
| [ ] | 41 | Power supply 24–48 V | 48 V, 5–10 A | 1 | $40 | $40 | select | DROK 48V Power Supply, AC to DC Converter 0-48V 10A 480W Variable Power Supply, AC to DC Adapter Low Voltage Transformer |  |
| [ ] | 42 | Fasteners + NUTS | M5/M6/M3 SHCS, nuts, washers (clearance-hole build) | 1 | $35 | $35 | McMaster / assorted · `92275A110` | Nuts replace tapping | [link](https://www.mcmaster.com/products/socket-head-cap-screw-assortments/system-of-measurement~metric/) |
| [ ] | 43 | Dowel pins | Ø4 mm (PA-4 interface) | 1 | $8 | $8 | McMaster · `91595A161` | Reamed-fit | [link](https://www.mcmaster.com/products/dowel-pins/dowel-pins-1~~/system-of-measurement~metric/diameter~4-0000-mm/diameter~4-000-mm/diameter~4-mm/) |
| [ ] | 44 | Consumables | Threadlocker (medium) + anti-seize | 1 | $12 | $12 | — · `7458A65` | Loctite 243 kits | [link](https://www.mcmaster.com/products/loctite-kits/manufacturer-model-number~243/) |

## F.  CUT — DXF FLAT PLATES (6061-T6; files supplied; one SendCutSend order)

| Bought | # | Item | Spec | Qty | Unit $ | Line $ | P/N / Source | Notes | Link |
|:------:|:--|:-----|:-----|:---:|:------:|:------:|:-------------|:------|:----:|
| [ ] | 45 | Pan base plate | 6 mm; file 02_base_plate_pan.dxf | 1 | $28 | $28 | DXF | Gearbox + slew bearing + standoffs |  |
| [ ] | 46 | Turntable plate | 6 mm; file 03_turntable_plate.dxf | 1 | $28 | $28 | DXF | Slew bearing + yoke feet |  |
| [ ] | 47 | Yoke side — gearbox | 6 mm; file 04_yoke_side_gearbox.dxf | 1 | $25 | $25 | DXF | Gearbox flange |  |
| [ ] | 48 | Yoke side — trunnion | 6 mm; file 05_yoke_side_trunnion.dxf | 1 | $25 | $25 | DXF | Pillow-block bearing |  |
| [ ] | 49 | Interface plate (PA-4) | 6 mm; file 01_interface_plate_PA4.dxf | 1 | $28 | $28 | DXF | Payload mount (Ø70 BC/dowels/Ø14) |  |
| [ ] | 50 | Tripod adapter | 6 mm; file 06_tripod_adapter.dxf | 1 | $25 | $25 | DXF | Mates your tripod head |  |

## G.  HAVE

| Bought | # | Item | Spec | Qty | Unit $ | Line $ | P/N / Source | Notes | Link |
|:------:|:--|:-----|:-----|:---:|:------:|:------:|:-------------|:------|:----:|
| [x] | 51 | Tripod | 35 lb (you own) | 1 | $0 | $0 | — | Watch flex under fast slews; confirm bowl |  |

## H.  GROUND STATION — 10" RACK

| Bought | # | Item | Spec | Qty | Unit $ | Line $ | P/N / Source | Notes | Link |
|:------:|:--|:-----|:-----|:---:|:------:|:------:|:-------------|:------|:----:|
| [x] | 52 | 10" rack — DeskPi RackMate T2 | 12U, 10" wide, 10.23" (~260 mm) deep | 1 | $100 | $100 | GeeekPi / DeskPi RackMate T2 | Houses compute, PSUs, drivers, displays. Bought; price est. |  |
| [x] | 53 | 10" rackmount PDU | 8 outlets, surge, 15 A switch, 1U | 1 | $69.99 | $69.99 | ElecVoztile 10" PDU | All AC onboard; one cord to wall. Bought; price est. |  |
| [ ] | 54 | E-stop (panel-mount) | Latching, 2-pole (or drives contactors) | 1 | $20 | $20 | generic | Drops BOTH the 48 V motor + 12 V solenoid rails. Safety-critical. |  |
| [x] | 55 | Gigabit Ethernet switch | TP-Link TL-SG108E, 8-port, managed | 1 | $19.99 | $19.99 | TP-Link TL-SG108E | Pi + Jetson + uplink (SSH/updates). Bought; price est. |  |
| [ ] | 56 | DIN rail + terminal/ground bus | Terminal blocks + ground bar | 1 | $20 | $20 | generic | Distribute/fuse 48 V & 12 V (with #28); tie all grounds. |  |
| [ ] | 57 | Umbilical connectors + bulkhead | Multi-pin circular + USB | 1 | $40 | $40 | generic (aviation GX/M-series) | Rack↔turret disconnect: 48 V + 12 V power, Pi↔Pico comms, ZED USB, ground (no motor phases/step-dir). Price est. |  |
| [ ] | 58 | Umbilical cable sleeve / wrap | Braided / spiral wrap | 1 | $15 | $15 | generic | The single sleeved bundle, tripod↔rack. |  |
| [ ] | 59 | Blank + vent rack panels | 10" panels | 1 | $15 | $15 | generic / 3D print | Fill gaps; airflow. |  |
| [x] | 60 | Cable manager (0.5U D-ring bar) | Tecmojo 2-pack, metal, 3 D-rings, 10" | 1 | $9.90 | $9.90 | Tecmojo 0.5U (2-pack) | 2 bars/pack; rack cable management. |  |
| [ ] | 61 | Jetson/Pi 5/Pico rack shelf | 3D print; standoffs + vents | 1 | $0 | $0 | MAKE (3D print) | To be designed. |  |
| [x] | 62 | 12-port Cat6 patch panel | 1U; keystone + cable bar | 1 | $24.99 | $24.99 | GeeekPi 12-port | Network breakout; part of the umbilical interface. Bought; price est. |  |
| [x] | 63 | Switch rack mount (PETG) | 1U mount for TL-SG108 | 1 | $34.99 | $34.99 | generic PETG | Racks the TL-SG108E. Bought; price est. |  |

## I.  CONTROL / TEST (operator console)

| Bought | # | Item | Spec | Qty | Unit $ | Line $ | P/N / Source | Notes | Link |
|:------:|:--|:-----|:-----|:---:|:------:|:------:|:-------------|:------|:----:|
| [ ] | 64 | RadioMaster TX16S Mk II (ELRS) | EdgeTX, 16CH, Hall gimbals, 4.3" touch | 1 | $239.99 | $239.99 | RadioMaster TX16S MkII ELRS | Manual jog + Lua telemetry console. MOTION ONLY (not firing). |  |
| [ ] | 65 | ELRS receiver (CRSF) | 2.4 GHz, CRSF serial out | 1 | $15 | $15 | RadioMaster RP3 (or similar) | RX → CRSF → Pico UART. Set failsafe → Pico stop-hold. Price est. |  |
| [ ] | 66 | 18650 cells (×2) | Li-ion, for the TX16S (USB-C charge) | 1 | $12 | $12 | generic 18650 ×2 | Radio battery (not included). Price est. |  |

## Totals

| | Amount |
|:--|:--|
| Grand total (to-buy) | $2,030.67 |
| Electronics & payload (A–D) | $728.86 |
| Gimbal — catalog (E) | $505.96 |
| Gimbal — DXF plates (F) | $159 |
| Ground station — rack (H) | $369.86 |
| Control / test (I) | $266.99 |
