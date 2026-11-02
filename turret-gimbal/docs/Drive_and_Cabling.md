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

## Drivers: CL57T V4.1 settings and the Pico interface
Source: `../datasheets/01_driver_CL57T-V4.1_manual.pdf` (both kits confirmed V4.1).
Set both drivers identically unless noted.

| Switch | Setting | Why |
|:--|:--|:--|
| **S1** (rotary) | **4** → 5.6 A peak / 4 A RMS, factory gains | Ships at **0 = 2.8 A peak**, half the 4.2 A motor rating. 5–9 keep the current and stiffen the loop; start at 4. |
| **SW1–SW4** | `on off on on` → 1600 pulses/rev | ×5 gearbox = 8000 pulses per output rev (0.045°). Alternative: `off on on off` = 2000 (10,000/rev). |
| **SW5** | per axis | Direction; flip here instead of rewiring. |
| **SW6** | **OFF** = closed loop | ON (open loop) is only the encoder-wiring test. |
| **SW7** | **OFF** = PUL/DIR | |
| **SW8** | **OFF** = 1.5 ms filter | ON is a 10 ms smoothing filter: lag a tracker can't afford. Must match on both drivers. |
| **S3** | **5 V** | Ships at 24 V. Never apply 24 V signals with S3 at 5 V (destroys the input optos). |

**Timing the Pico must meet:** PUL high ≥ 1 µs and low ≥ 1 µs (500 kHz max); DIR stable
≥ 2 µs before the step edge; ENA released ≥ 200 ms before DIR/steps.

### Step/dir buffer (BOM #73)
The P1 inputs see "high" only at **3.5–5 V with 7–16 mA**, so Pico GPIO (3.3 V) cannot
drive them directly. Use the manual's open-collector (common-anode) wiring with one
**74LVC07A** hex open-drain buffer, powered from the Pico's 3V3:

```
turret +5V ──► PUL+ ─[CL57T opto]─ PUL− ──► 74LVC07A output (sinks to GND when on)
                                            74LVC07A input ◄── Pico GPIO  (10 kΩ to GND)
```

| Buffer channel | Signal |
|:--|:--|
| 1 / 2 / 3 | Pan PUL− / DIR− / ENA− |
| 4 / 5 / 6 | Tilt PUL− / DIR− / ENA− |

- PUL+, DIR+, ENA+ of both drivers → turret **+5 V** (#72).
- 10 kΩ pull-down on each buffer input; 0.1 µF across the buffer's VCC/GND.
- **ENA is release-on-assert:** unconnected/off = motor enabled and holding. With the
  pull-downs, a Pico in reset or crashed leaves both axes **holding** — the safe state.

### Fault and brake outputs
- **ALM** (open collector, ≤ 30 V / 100 mA): sinking connection, COM → GND, ALM pulled
  up to the Pico's 3V3 → Pico fault input → stop-and-hold + report. Polarity is
  configurable; confirm on the bench.
- **Faults latch with the shaft free** (over-current, over-voltage, following error).
  The only reset is power-cycling the driver, so the Pi 5 needs a way to cycle the 48 V
  rail. With the payload CG near the tilt axis, a freed shaft has little to back-drive.
- **BRK** (≤ 24 V / 100 mA): only through a relay with a flyback diode, if a brake is added.
- Red LED blink count = fault: 1 over-current, 2 over-voltage, 4 can't lock the shaft
  (motor cable), 7 following error (SW6 ON as an encoder-wiring test).

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

> **Solenoid is switched in the rack.** The 8-MOSFET HAT (on the Pi 5, rack) does
> the low-side switching — the **Pico never touches the firing path**. So the
> umbilical carries the **switched solenoid pair (2 conductors: armed +12 V feed +
> switched return)**, not a single line; account for both in the connector pinout.
> Solenoid current loops rack → turret → rack (fine at ~1 A).

## Rack ↔ turret control link (RS-485)
The Pi 5 (rack) commands the Pico (turret) over the umbilical. A bare 3.3 V UART is
the wrong signal for that run: it is single-ended, several metres long, and bundled
beside the 48 V stepper feed, whose current edges couple straight into it. The
symptom would be corrupt frames and missed heartbeats — i.e. **spurious
stop-and-holds**. So the link is **RS-485** (differential), via a transceiver at each
end (BOM #70):

```
Pi 5 UART ── RS-485 xcvr ══ A/B twisted pair (umbilical) ══ RS-485 xcvr ── Pico UART
  (rack)       (#70)              GX20 pins 9/10              (#70)       (turret)
```

- **Half-duplex, one twisted pair.** It drops into the two GX20 pins the UART
  TX/RX had, so the connector stays 12-pin. Use transceivers with **automatic
  direction control** (MAX13487-class) so neither side has to drive DE/RE.
- **The Pi 5 is the only master.** Every Pi 5 frame (command or heartbeat) gets
  exactly one Pico reply (ack + orientation/state). The Pico never transmits
  unprompted, so the bus never contends.
- **Termination:** 120 Ω at **both ends only** (the modules carry it on board).
  The shared GND pin is the transceivers' common-mode reference — keep it.
- **Rate:** 230400 baud. Well inside auto-direction limits (~500 kbps); a 32-byte
  frame takes ~1.4 ms, so a 20 ms heartbeat uses <10 % of the link.
- **Framing:** COBS-framed packets, each with a sequence number and a CRC-16. Bad
  CRC → drop the frame (the next heartbeat covers it).
- **Heartbeat:** the Pi 5 sends one every 20 ms; **the Pico stops-and-holds after 5
  missed (100 ms)**. The heartbeat must originate on the **Pi 5** — no relay in
  between may generate it, or a dead Pi 5 behind a live relay would keep the
  turret moving.

### GX20-12 umbilical pin map
| Pin | Signal | Notes |
|:--:|:--|:--|
| 1–3 | 48 V+ | 3 × 5 A pins = 15 A |
| 4–6 | 48 V− | 3 × 5 A pins |
| 7 | Solenoid +12 V (armed feed) | from the arming interlock |
| 8 | Solenoid switched return | to the rack HAT channel |
| 9 | RS-485 A | twisted with pin 10 |
| 10 | RS-485 B | twisted with pin 9 |
| 11 | GND (signal) | RS-485 reference + common ground |
| 12 | Armed LED | hardware-tied to the armed rail |

Run the A/B pair as a **twisted pair** the full length of the umbilical (a spare
pair from Cat5e is fine), kept apart from the 48 V conductors inside the sleeve.

### Turret 5 V logic rail
Nothing on the umbilical carries 5 V, so the turret makes its own: a **48 V → 5 V,
3 A buck** (BOM #72) on the electronics base feeds the Pico (VSYS), ELRS RX, IMU,
OLED and the Zero.

> **Open decision — where the buck taps 48 V.** The 48 V on pins 1–6 is *after* the
> E-stop cutoff solenoid (#64), so as drawn, **E-stop also kills the Pico**: it
> cannot report the E-stop, and it must re-home afterwards. Keeping the logic alive
> needs an unswitched, fused 48 V feed, which means a 13th conductor (larger GX
> shell) or giving up one of the three 48 V− pins (15 A → 10 A return). Decide
> before the connector is wired.

## Maintenance node: Pi Zero 2 W (optional)
A Pi Zero 2 W (BOM #71, hostname `turret-zero`) can sit on the electronics base
beside the Pico, plugged into the **Pico's USB port**. It is a wireless service port,
**never part of control**:

- Flash and update the Pico's MicroPython with `mpremote` over Wi-Fi — no trip to
  the rack, no cable to the turret.
- Tail the Pico's debug log / record telemetry; `ssh turret-zero`.
- **Not in the command or heartbeat path.** Motion commands are accepted **only**
  from the RS-485 link. If the Zero or its Wi-Fi dies, nothing about motion changes.
- **Flash with the motor rail off** (E-stop latched): a USB REPL can do anything the
  firmware can.

Setup notes:
- The Zero's USB data port must be in **host** mode on the turret
  (`dtoverlay=dwc2,dr_mode=host` in `config.txt`, and remove the `modules-load=…g_ether…`
  options from `cmdline.txt`). The bench card currently boots it as a USB-Ethernet
  *gadget*; on the turret, Wi-Fi is the only way in.
- Power the Zero from the 5 V buck (PWR IN). The Zero then also drives the Pico's
  VBUS, while the buck drives the Pico's VSYS: feed VSYS **through a Schottky diode**
  (per the Pico datasheet's power section) so the two 5 V sources don't fight.
- 2.4 GHz only. Fine for maintenance; never rely on it for anything live.

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
