# Paintball Turret — Purchase Checklist

> Sections A–D: the turret system (payload on the gun · compute on the tripod · displays · power/wiring). Sections E–G: the bolt-together gimbal — BUY catalog · CUT (DXF, SendCutSend) · HAVE. Owned items are priced $0 so they stay out of the totals.

Two clickable boxes per item — **Ordered** and **Received** (works in GitHub, VS Code, Obsidian). Owned items are pre-ticked on both.

## A.  PAYLOAD — ON THE TURRET

- **#1 Paintball marker** — Bore-sighted reference for the ZED · owned
  
  - [x] Ordered
  
  - [x] Received
  
  - _Owned. Bore aligns to the pan axis; hopper top-rear._

- **#2 Push-pull solenoid (trigger)** — 12 V, 1 A, 20 N, 10 mm stroke · $13.99 · TOMMSILE 0837B-12V (Amazon)
  
  - [x] Ordered
  
  - [ ] Received
  
  - _Trigger actuator; 12 V switched. 20 N is end-of-stroke; confirm trigger force after marker scan._

- **#3 Arming switch (SPST toggle)** — SPST latching, 10 A DC @ 12 V, pre-wired; in the 12 V solenoid line · $7.99 · Taiss KNS-1 (2-pack, Amazon)
  
  - [x] Ordered
  
  - [ ] Received
  
  - _HARDWARE INTERLOCK: open = cannot fire. Safety-critical._

- **#4 Laser sight (boresight aid)** — Mounts on top of the barrel · $15 · generic
  
  - [x] Ordered
  
  - [x] Received
  
  - _Zero to impact point at a set range, like a rifle._

- **#5 ZED 2i stereo camera** — 4 mm, polarizer; USB 3.0 · Stereolabs ZED 2i 4mm
  
  - [x] Ordered
  
  - [ ] Received
  
  - _Owned (~$549). Boresighted below the barrel; routes to the Jetson._

- **#6 ZED USB3 locking cable (3 m)** — USB 3.0 Type-C locking · Stereolabs
  
  - [x] Ordered
  
  - [ ] Received
  
  - _Owned._

- **#7 10-DOF IMU (BNO055 + BMP280)** — I2C Gravity plug (no solder); run IMU mode (no mag) · $25.90 · DFRobot Gravity SEN0253 · [link](https://www.dfrobot.com/product-1793.html)
  
  - [x] Ordered
  
  - [ ] Received
  
  - _Leveling + stabilization; rigid to platform. Use IMU (no-mag) mode near steppers; lower Pi I2C baud for BNO055 clock-stretch._

- **#8 Benewake TF03 lidar (100 m)** — Single-point rangefinder; UART/CAN; IP67 · $220 · TF03-100
  
  - [x] Ordered
  
  - [ ] Received
  
  - _Boresighted to the muzzle; range along the line of fire._

- **#9 Armed/Safe LED indicator** — Red+green LEDs + resistors; hardware-tied · $3 · generic
  
  - [ ] Ordered
  
  - [ ] Received
  
  - _RED ARMED off the armed rail (hardware-true); GREEN SAFE. On the turret._

## B.  COMPUTE & CONTROL — ON THE TRIPOD

- **#10 NVIDIA Jetson AGX Orin 32 GB** — Vision/targeting module · AGX Orin 32GB
  
  - [x] Ordered
  
  - [x] Received
  
  - _Owned. Perception/targeting._

- **#11 Raspberry Pi 5 (8 GB)** — Supervisor · $80 · SC1112
  
  - [x] Ordered
  
  - [ ] Received
  
  - _Setpoints, IMU/lidar, arming, state._

- **#12 Pi 5 Active Cooler** — — · $5 · SC1148
  
  - [x] Ordered
  
  - [ ] Received
  
  - _Pi 5 throttles without it._

- **#13 Pi 27 W USB-C PD supply** — 5.1 V / 5 A · $12 · SC1158
  
  - [x] Ordered
  
  - [ ] Received
  
  - _Powers the Pi + HAT reliably._

- **#14 microSD 64 GB A2** — — · $10 · SanDisk SDSQXAV-064G
  
  - [x] Ordered
  
  - [ ] Received
  
  - _Pi OS / boot._

- **#15 Solenoid driver HAT (8-MOSFET)** — I2C; solid-state · $45 · Sequent Eight-MOSFETS
  
  - [x] Ordered
  
  - [ ] Received
  
  - _Trigger drive; the only HAT on the stack now._

- **#16 GPIO stacking header, 2×20 tall** — — · $3 · Adafruit 2223
  
  - [x] Ordered
  
  - [ ] Received
  
  - _Passes GPIO up past the HAT._

- **#17 Top-of-stack GPIO breakout / proto-HAT** — — · $8 · Adafruit 2310
  
  - [x] Ordered
  
  - [ ] Received
  
  - _Expose SPI (IMU), UART (lidar + Pico), spare GPIO._

- **#18 Brass standoff / spacer kit (M2.5)** — — · $8 · generic
  
  - [x] Ordered
  
  - [ ] Received
  
  - _Mount/space the HAT + Pi._

- **#19 Limit / homing switches** — microswitch; GPIO to Pico · $6 · generic
  
  - [x] Ordered
  
  - [ ] Received
  
  - _One per axis → power-up homing → absolute aiming._

- **#20 Pico RP2040** — Motion coprocessor (step/dir) · $5 · Raspberry Pi Pico
  
  - [x] Ordered
  
  - [x] Received
  
  - _Drives both CL57T_

- **#21 Pico debug OLED (SSD1306)** — 128×64; I2C · $9 · Adafruit 938
  
  - [x] Ordered
  
  - [ ] Received
  
  - _Pico debug: current routine/state, step/dir, homing, heartbeat, faults._

## C.  DISPLAYS & CALIBRATION

- **#22 1U rack display — Pi 5 (GeeekPi 6.91")** — 1424×280 touch, 1U rack mount · $60 · GeeekPi 6.91" 1U
  
  - [x] Ordered
  
  - [ ] Received
  
  - _Pi 5 status/console bar. Bought; price est._

- **#23 1U rack display — Jetson (GeeekPi 6.91")** — 1424×280 touch, 1U rack mount · $60 · GeeekPi 6.91" 1U
  
  - [x] Ordered
  
  - [ ] Received
  
  - _Jetson perception/status bar. Bought; price est._

- **#24 Checkerboard calibration target** — Rigid flat backing · owned
  
  - [x] Ordered
  
  - [x] Received
  
  - _Owned. Camera + boresight calibration._

- **#25 micro-HDMI → HDMI cable** — — · $7 · generic
  
  - [ ] Ordered
  
  - [ ] Received
  
  - _Pi 5 micro-HDMI → 6.91" display._

- **#26 DisplayPort → HDMI adapter** — — · $9 · generic
  
  - [ ] Ordered
  
  - [ ] Received
  
  - _AGX Orin DP → 6.91" display; verify._

## D.  POWER & WIRING

- **#27 12 V DC supply (≥3 A)** — Solenoid rail · $16 · Mean Well GST60A12
  
  - [ ] Ordered
  
  - [ ] Received
  
  - _Solenoid only (motors on 24–48 V). Or buck from 48 V for one supply._

- **#28 Inline fuse holders + fuses** — ATC · $8 · generic
  
  - [ ] Ordered
  
  - [ ] Received
  
  - _Fuse the 24–48 V and 12 V rails; tie ALL grounds together._

- **#29 Ethernet cable, Cat6 (short)** — — · $6 · generic
  
  - [ ] Ordered
  
  - [ ] Received
  
  - _Direct Pi↔Jetson; service loop on the motion run._

- **#30 Jumper wires (DuPont M-F, M-M)** — — · $7 · generic
  
  - [ ] Ordered
  
  - [ ] Received
  
  - _Signals: IMU, lidar, Pico, switches._

- **#31 Hookup wire, 18–20 AWG** — — · $10 · generic
  
  - [ ] Ordered
  
  - [ ] Received
  
  - _Motor, solenoid, power runs._

- **#32 Wire ferrules / crimp terminals** — — · $9 · generic
  
  - [ ] Ordered
  
  - [ ] Received
  
  - _Driver/terminal terminations._

## E.  BUY — CATALOG PARTS

- **#33 Motor + driver kit** — NEMA 23 closed-loop 3.0 N·m + CL57T V4.1 · $171.98 · 23HS45-4204D-E1000 / Amazon B0C6943QBM
  
  - [x] Ordered
  
  - [x] Received
  
  - _STEPPERONLINE Closed Loop Stepper Motor 1 Axis CNC KIT 2.0 Nm/283.28oz.in Nema 23 Motor & 0-8.0A 24-48VDC Closed Loop Stepper Driver CL57T V4.1_

- **#34 Planetary gearbox 5:1** — NEMA 23, Ø8 bore, 15 arcmin; out Ø14 / Ø40 reg / 4×Ø5.2@47.14 · $115.98 · Ratio 5:1 Nema 23 … φ8mm
  
  - [x] Ordered
  
  - [ ] Received
  
  - _Ratio 5:1 Planetary Gearbox for Nema 23 Stepper Motor 57-67mm Backlash 15 arcmin Input Shaft 21mm φ8mm Planetary Reducer for 57 Step Motor_

- **#35 Turntable bearing (lazy susan)** — Heavy-duty steel/alu, OPEN center, 6–8 in · $20 · Search "turntable bearing" / "lazy susan bearing" · McMaster: Ball Bearing Turntables · `193019173251` · [link](https://vxb.com/checkouts/cn/hWNDQZKNqS7FLBgAANhKclaa/en-us/thank-you?_r=AQABSTga-mN3Yrg_UjagK1rtzQSFz0x6rcQo9Jd1a6PLjnA&skip_shop_pay=true)
  
  - [x] Ordered
  
  - [x] Received
  
  - _8INCH-SWIVEL-LAZY-SUSAN — **measured part: see [Bearing_Dimensions](turret-gimbal/docs/Bearing_Dimensions.md)**_

- **#36 Mounted ball bearing (tilt)** — Flange-mount or pillow block; bore = pin Ø (e.g. 1/2") · $15 · McMaster: "mounted ball bearing" · `5968K71` · [link](https://www.mcmaster.com/products/mounted-ball-bearings/mounted-ball-bearings-with-two-bolt-flange~~/mounted-bearing-type~two-bolt-flange-mount/)
  
  - [ ] Ordered
  
  - [ ] Received
  
  - _Match pattern to plate 05_

- **#37 Mounting hub** — Clamps gearbox Ø14 shaft → bolts to plate; bore 14 mm · $36 · McMaster: "mounting hub" · Ruland · `FHT-MCL-14-SS` · [link](https://www.ruland.com/fht-mcl-14-ss.html#)
  
  - [ ] Ordered
  
  - [ ] Received
  
  - _Or rigid shaft coupling; no keyway_

- **#38 Shoulder screw (tilt pin)** — Shoulder Ø = #36 bearing bore (e.g. 1/2") · $8 · McMaster: "shoulder screw" · `90298A716` · [link](https://www.mcmaster.com/products/shoulder-screws/shoulder-diameter~1-2/shoulder-length~1-1-2/)
  
  - [ ] Ordered
  
  - [ ] Received
  
  - _Far end of tilt axis; pairs with #36_

- **#39 L-brackets / gussets** — Join yoke side-plates to turntable + stiffen · $32 · 8020 / McMaster · [link](https://www.mcmaster.com/products/l-brackets/brackets-1~/)
  
  - [ ] Ordered
  
  - [ ] Received
  
  - _Bolt-together corners_

- **#40 Standoffs** — M5, raise base plate over tripod adapter · $12 · McMaster
  
  - [ ] Ordered
  
  - [ ] Received
  
  - _Length = motor/gbx clearance_

- **#41 Power supply 24–48 V** — 48 V, 5–10 A · $40 · select
  
  - [ ] Ordered
  
  - [ ] Received
  
  - _DROK 48V Power Supply, AC to DC Converter 0-48V 10A 480W Variable Power Supply, AC to DC Adapter Low Voltage Transformer_

- **#42 Fasteners + NUTS** — M5/M6/M3 SHCS, nuts, washers (clearance-hole build) · $35 · McMaster / assorted · `92275A110` · [link](https://www.mcmaster.com/products/socket-head-cap-screw-assortments/system-of-measurement~metric/)
  
  - [ ] Ordered
  
  - [ ] Received
  
  - _Nuts replace tapping_

- **#43 Dowel pins** — Ø4 mm (PA-4 interface) · $8 · McMaster · `91595A161` · [link](https://www.mcmaster.com/products/dowel-pins/dowel-pins-1~~/system-of-measurement~metric/diameter~4-0000-mm/diameter~4-000-mm/diameter~4-mm/)
  
  - [ ] Ordered
  
  - [ ] Received
  
  - _Reamed-fit_

- **#44 Consumables** — Threadlocker (medium) + anti-seize · $12 · — · `7458A65` · [link](https://www.mcmaster.com/products/loctite-kits/manufacturer-model-number~243/)
  
  - [ ] Ordered
  
  - [ ] Received
  
  - _Loctite 243 kits_

## F.  CUT — DXF FLAT PLATES (6061-T6; files supplied; one SendCutSend order)

- **#45 Pan base plate** — 6 mm; file 02_base_plate_pan.dxf · $28 · DXF
  
  - [ ] Ordered
  
  - [ ] Received
  
  - _Gearbox + slew bearing + standoffs_

- **#46 Turntable plate** — 6 mm; file 03_turntable_plate.dxf · $28 · DXF
  
  - [ ] Ordered
  
  - [ ] Received
  
  - _Slew bearing + yoke feet_

- **#47 Yoke side — gearbox** — 6 mm; file 04_yoke_side_gearbox.dxf · $25 · DXF
  
  - [ ] Ordered
  
  - [ ] Received
  
  - _Gearbox flange_

- **#48 Yoke side — trunnion** — 6 mm; file 05_yoke_side_trunnion.dxf · $25 · DXF
  
  - [ ] Ordered
  
  - [ ] Received
  
  - _Pillow-block bearing_

- **#49 Interface plate (PA-4)** — 6 mm; file 01_interface_plate_PA4.dxf · $28 · DXF
  
  - [ ] Ordered
  
  - [ ] Received
  
  - _Payload mount (Ø70 BC/dowels/Ø14)_

- **#50 Tripod adapter** — 6 mm; file 06_tripod_adapter.dxf · $25 · DXF
  
  - [ ] Ordered
  
  - [ ] Received
  
  - _Mates your tripod head_

## G.  HAVE

- **#51 Tripod** — 35 lb (you own) · —
  
  - [x] Ordered
  
  - [x] Received
  
  - _Watch flex under fast slews; confirm bowl_

## H.  GROUND STATION — 10" RACK

- **#52 10" rack — DeskPi RackMate T2** — 12U, 10" wide, 10.23" (~260 mm) deep · $100 · GeeekPi / DeskPi RackMate T2
  
  - [x] Ordered
  
  - [ ] Received
  
  - _Houses compute, PSUs, drivers, displays. Bought; price est._

- **#53 10" rackmount PDU** — 8 outlets, surge, 15 A switch, 1U · $30 · ElecVoztile 10" PDU
  
  - [x] Ordered
  
  - [ ] Received
  
  - _All AC onboard; one cord to wall. Bought; price est._

- **#54 E-stop (panel-mount)** — Latching, 2-pole (or drives contactors) · $20 · generic
  
  - [ ] Ordered
  
  - [ ] Received
  
  - _Drops BOTH the 48 V motor + 12 V solenoid rails. Safety-critical._

- **#55 Gigabit Ethernet switch** — TP-Link TL-SG108E, 8-port, managed · $25 · TP-Link TL-SG108E
  
  - [x] Ordered
  
  - [ ] Received
  
  - _Pi + Jetson + uplink (SSH/updates). Bought; price est._

- **#56 DIN rail + terminal/ground bus** — Terminal blocks + ground bar · $20 · generic
  
  - [ ] Ordered
  
  - [ ] Received
  
  - _Distribute/fuse 48 V & 12 V (with #28); tie all grounds._

- **#57 Umbilical connectors + bulkhead** — Multi-pin circular + USB · $40 · generic (aviation GX/M-series)
  
  - [ ] Ordered
  
  - [ ] Received
  
  - _Rack↔turret disconnect at the panel. Price est._

- **#58 Umbilical cable sleeve / wrap** — Braided / spiral wrap · $15 · generic
  
  - [ ] Ordered
  
  - [ ] Received
  
  - _The single sleeved bundle, tripod↔rack._

- **#59 Blank + vent rack panels** — 10" panels · $15 · generic / 3D print
  
  - [ ] Ordered
  
  - [ ] Received
  
  - _Fill gaps; airflow._

- **#60 Cable management** — Velcro, clips, ducting · $10 · generic
  
  - [ ] Ordered
  
  - [ ] Received
  
  - _Tidy the onboard cabling._

- **#61 Jetson/Pi 5/Pico rack shelf** — 3D print; standoffs + vents · MAKE (3D print)
  
  - [ ] Ordered
  
  - [ ] Received
  
  - _To be designed._

- **#62 12-port Cat6 patch panel** — 1U; keystone + cable bar · $15 · GeeekPi 12-port
  
  - [x] Ordered
  
  - [ ] Received
  
  - _Network breakout; part of the umbilical interface. Bought; price est._

- **#63 Switch rack mount (PETG)** — 1U mount for TL-SG108 · $12 · generic PETG
  
  - [x] Ordered
  
  - [ ] Received
  
  - _Racks the TL-SG108E. Bought; price est._

## Totals

- **Grand total (to-buy):** $1,635.84
- **Electronics & payload (A–D):** $668.88
- **Gimbal — catalog (E):** $505.96
- **Gimbal — DXF plates (F):** $159
- **Ground station — rack (H):** $302
