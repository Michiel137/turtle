include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <BOSL2/rounding.scad>

include <parameters.scad>

// diameter_ball = 10;
diameter_ball = 16;
radius_ball = diameter_ball / 2;

/// How much do the wheels sag. The chassis will sit this much lower.
sag_wheel = 0.6;
height = radius_wheel - thickness_chassis - height_axle - sag_wheel;

tolerance = 0.2;
wall = 1.8;

diameter_outer = diameter_ball + 2 * wall;
radius_outer = radius_ball + wall;

offset_mount = (diameter_ball + 2 * tolerance - 8) / 2;

intersection() {
    cut = 1 / 2;

    difference() {
        union() {
            bottom_half(z=height - radius_ball * cut)
            cyl(r=radius_outer, h=height + wall, rounding2=radius_outer, anchor=BOTTOM);

            back(offset_mount)
            offset_sweep(rect([30 + 8, 8], rounding=8 / 2), h=2.4, top=os_chamfer(chamfer));
        }

        back(offset_mount)
        xcopies(30)
        cyl(d=3.2, h=10);

        up(height - radius_ball)
        sphere(r=radius_ball + tolerance);

        up(height - radius_ball * 11 / 6)
        cuboid([radius_ball * 2 / 3, 100, 100], anchor=BOTTOM);

        h = (2 - cut) * radius_ball;
        r = sqrt((1 - (1 - cut)^2)) * (radius_ball + tolerance);
        up(height - diameter_ball)
        cyl(r1=0, r2=r + chamfer, h=h, extra2=1, anchor=BOTTOM);
    }

    cuboid([100, diameter_ball + 2 * tolerance, 100]);
}
