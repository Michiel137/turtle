include <BOSL2/std.scad>

include <parameters.scad>

width_rim = 4;
width_disc = 2.5;
width_hub = 9;
diameter_hub = 11;
radius_hub = diameter_hub / 2;
radius_rim = radius_wheel - 3 / 2 * radius_tire;

rounding_wheel = 1;

module wheel() {
    difference() {
        up(width_disc)
        union() {
            difference() {
                down(width_disc - width_rim / 2)
                difference() {
                    cyl(r=radius_rim, h=width_rim, chamfer=chamfer);
                    // tire recess
                    torus(or=radius_wheel, r_min=radius_tire);
                }

                // disc
                radius_disc = radius_rim - 3 * chamfer;
                cyl(r=radius_disc, h=width_rim - width_disc, rounding1=rounding_wheel, chamfer2=-chamfer, extra2=$overlap, anchor=BOTTOM);

                // disc holes
                diameter_hole = radius_disc - radius_hub - 4 * rounding_wheel;
                radius_hole = diameter_hole / 2;
                zrot_copies(n=5)
                back((radius_disc + radius_hub) / 2)
                cyl(r=radius_wheel / 4, h=width_disc, rounding=-rounding_wheel, extra=$overlap, anchor=TOP);
            }

            // hub
            cyl(r=radius_hub, h=width_hub - width_disc, rounding1=-rounding_wheel, rounding2=rounding_wheel, extra1=$overlap, anchor=BOTTOM);
        }

        // shaft
        path = intersection([circle(d=5), rect([3, 10])])[0];
        offset_sweep(path, h=width_hub, ends=os_chamfer(-chamfer, extra=$overlap), anchor=BOTTOM);
        // shaft M3 set screw (only one has to be used)
        up(width_hub - 3)
        cyl(d=2.8, h=diameter_hub, chamfer=-chamfer, orient=RIGHT);
    }
}

module tire() {
    up(width_rim / 2)
    torus(or=radius_wheel, r_min=radius_tire);
}

wheel();
color("grey")
tire();
