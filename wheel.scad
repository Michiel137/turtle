include <BOSL2/std.scad>

$fa = $preview ? 12 : 3;
$fs = $preview ? 2 : 0.2;
$overlap = 0.01;

// diameter_wheel = 53;  // OSTR V3
diameter_wheel = 47.5;  // OSTR V2
radius_wheel = diameter_wheel / 2;
width_rim = 4;
width_disc = 2.5;
diameter_tire = 3;
radius_tire = diameter_tire / 2;
diameter_hub = 11;
radius_hub = diameter_hub / 2;
width_hub = 9;

chamfer = 0.4;
rounding = 1;

module wheel() {
    difference() {
        up(width_disc)
        union() {
            difference() {
                down(width_disc - width_rim / 2)
                difference() {
                    cyl(r=radius_wheel - 3 / 4, h=width_rim, chamfer=chamfer);
                    torus(r_maj=radius_wheel, r_min=radius_tire);
                }

                radius_spokes = radius_wheel - radius_tire - 1;
                cyl(r=radius_spokes, h=width_rim - width_disc, rounding1=rounding, chamfer2=-chamfer, extra2=$overlap, anchor=BOTTOM);

                diameter_hole = radius_spokes - radius_hub - 4 * rounding;
                radius_hole = diameter_hole / 2;
                zrot_copies(n=5)
                back((radius_spokes + radius_hub) / 2)
                cyl(r=radius_wheel / 4, h=width_disc, rounding=-rounding, extra=$overlap, anchor=TOP);
            }

            cyl(r=radius_hub, h=width_hub - width_disc, rounding1=-rounding, rounding2=rounding, extra1=$overlap, anchor=BOTTOM);
        }

        // shaft
        path = intersection([circle(d=5), rect([3, 10])])[0];
        offset_sweep(path, h=width_hub, ends=os_chamfer(-chamfer, extra=$overlap), anchor=BOTTOM);
        // shaft M3 set screws
        up(width_hub - 3)
        // cyl(d=2.8, h=diameter_hub, chamfer=-0.30, orient=RIGHT);
        cyl(d=2.8, h=diameter_hub, chamfer=-chamfer, orient=RIGHT);
    }
}

module tire() {
    up(width_rim / 2)
    intersection() {
        torus(r_maj=radius_wheel, r_min=radius_tire);
        cyl(r=100, h=radius_tire * 3 / 2);
    }
}

wheel();
color("grey")
tire();
