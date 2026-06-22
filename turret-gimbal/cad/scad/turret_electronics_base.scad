// =====================================================================
// Turret electronics base — holds the Pico + 2x CL57T drivers + BNO055 IMU
// Mounts to the pan base plate (non-rotating part of the turret unit, so the
// IMU senses base tilt for leveling). 3D-printable (PETG/ASA; drivers run warm).
//
// Drivers DROP INTO footprint pockets (side walls, OPEN ENDS so the screw
// terminals stay accessible) — no exact CL57T hole pattern needed. Pico on
// standoffs, IMU on a small raised pad. Vent slots under the drivers.
//
// >>> CONFIRM the [MEASURE] params against your actual hardware/plate <<<
// Render/export: open in OpenSCAD, F6, export STL.
// =====================================================================

// ---- CL57T V4.1 driver (x2) ----------------------------------------
drv_l        = 118;    // [MEASURE] length (terminal end to terminal end)
drv_w        = 75.5;   // [MEASURE] width
drv_h        = 33;     // [MEASURE] height (sets wall height)
drv_gap      = 14;     // airflow gap between the two drivers
drv_wall     = 5;      // locating wall height (just retains the base)
drv_clear    = 1.0;    // pocket clearance per side

// ---- Pico ----------------------------------------------------------
pico_dx      = 47;     // Pico mount-hole spacing X (board 51x21)
pico_dy      = 11.4;   // Pico mount-hole spacing Y
pico_so_h    = 4;
pico_screw_d = 2.2;    // M2 clearance

// ---- BNO055 IMU (DFRobot Gravity board) ----------------------------
imu_pad      = [40, 30];   // [MEASURE] board footprint
imu_so_h     = 4;
imu_screw_d  = 3.2;        // [MEASURE] Gravity board uses ~M3 mount holes
imu_hole_dx  = 30;         // [MEASURE] mount-hole spacing (one or two holes)

// ---- Tray + mount to the pan base plate ----------------------------
floor_th     = 4;
margin       = 8;          // border around the driver block
plate_screw_d = 5.4;       // M5 clearance to bolt onto the base plate
mount_inset  = 6;          // corner mount-hole inset

eps = 0.01; $fn = 36;

// derived tray size
block_w = 2*drv_w + drv_gap;       // two drivers side by side
block_l = drv_l;
tray_w  = block_w + 2*margin + 60; // extra strip for Pico + IMU
tray_l  = block_l + 2*margin;

module standoff(h, od, id) {
    difference() {
        cylinder(h=h, d=od);
        translate([0,0,-eps]) cylinder(h=h+2*eps, d=id);
    }
}

module driver_pocket(x0) {
    // side walls only; ends open for the screw terminals
    pw = drv_w + 2*drv_clear;
    pl = drv_l + 2*drv_clear;
    translate([x0, margin, floor_th-eps]) {
        translate([0,0,0])        cube([2, pl, drv_wall]);            // wall 1
        translate([pw-2,0,0])     cube([2, pl, drv_wall]);            // wall 2
        // a couple of cross ribs for retention (leave ends open)
        translate([0, pl*0.33, 0]) cube([pw, 2, drv_wall]);
        translate([0, pl*0.66, 0]) cube([pw, 2, drv_wall]);
    }
}

module vents(x0) {
    pw = drv_w + 2*drv_clear; pl = drv_l + 2*drv_clear;
    for (sx = [x0+6 : 12 : x0+pw-8])
        translate([sx, margin+8, -eps]) cube([6, pl-16, floor_th+2*eps]);
}

module base() {
    difference() {
        cube([tray_w, tray_l, floor_th]);                 // floor
        vents(margin);                                    // driver 1 vents
        vents(margin + drv_w + drv_gap);                  // driver 2 vents
        // four corner mount holes to the pan base plate
        for (mx = [mount_inset, tray_w-mount_inset])
            for (my = [mount_inset, tray_l-mount_inset])
                translate([mx, my, -eps])
                    cylinder(h=floor_th+2*eps, d=plate_screw_d);
    }
    // two driver pockets
    driver_pocket(margin);
    driver_pocket(margin + drv_w + drv_gap);
    // Pico standoffs (electronics strip, right of the drivers)
    px = block_w + 2*margin + 6; py = margin + 6;
    for (dx=[0,pico_dx]) for (dy=[0,pico_dy])
        translate([px+dx, py+dy, floor_th-eps]) standoff(pico_so_h, 4, pico_screw_d);
    // IMU pad + standoffs (rigid, defined orientation)
    ix = block_w + 2*margin + 6; iy = margin + 40;
    translate([ix, iy, floor_th-eps]) cube([imu_pad[0], imu_pad[1], 1]); // datum pad
    for (dx=[0,imu_hole_dx])
        translate([ix+ (imu_pad[0]-imu_hole_dx)/2 + dx, iy+imu_pad[1]/2, floor_th-eps])
            standoff(imu_so_h, 6, imu_screw_d);
}

base();
