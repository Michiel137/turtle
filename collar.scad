use <components.scad>

include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <BOSL2/rounding.scad>

include <parameters.scad>

diameter_collar = 26;
radius_collar = diameter_collar / 2;
length_collar = 10;

module collar_stabilo() {
    difference() {
        union() {
            cyl(d=12, h=length_collar, chamfer1=-1.2 * 2, chamfer2=chamfer, anchor=BOTTOM);
            cyl(d=26, h=1.2, chamfer=chamfer, anchor=BOTTOM);
        }

        cuboid([2, 20, 20], anchor=BOTTOM+FRONT);

        pen_stabilo(length=length_collar, slop=-0.15);
    }
}

collar_stabilo();
