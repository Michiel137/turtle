use <components.scad>

include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <BOSL2/rounding.scad>

include <parameters.scad>

diameter_collar = 28;
radius_collar = diameter_collar / 2;
length_collar = 10;

module collar_stabilo() {
    difference() {
        union() {
            cyl(d=12, h=length_collar, chamfer1=-1.2 * 2, chamfer2=chamfer, anchor=BOTTOM);
            path = round_corners(rect(diameter_collar), r=[2, 2, radius_collar, radius_collar]);
            offset_sweep(path, h=1.2, ends=os_chamfer(chamfer));
        }

        cuboid([2, 20, 50], anchor=FRONT);

        pen_stabilo(length=length_collar, slop=-0.15);
    }
}

collar_stabilo();
