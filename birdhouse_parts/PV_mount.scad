// you need to print 6 of these, but sequentially - otherwise it's too easy to knock things down
include <m3d/all.scad>

module PV_mount()
{
  sheet_thickness = 1.05;
  sheet_depth_inside = 12.1;
  sheet_depth_outside = 15.7;
  extra_width = 25;
  wall = 2;
  height = 20;
  screw_d = 4.5 + 0.5;

  module mount_2d()
  {
    d = 2*wall + sheet_thickness;
    difference()
    {
      union()
      {
        circle(d=d, $fn=fn(40));
        translate([-d/2, 0])
          square([d, sheet_depth_inside]);
      }
      translate([-sheet_thickness/2, 0])
        square([sheet_thickness, sheet_depth_inside]);
      circle(d=sheet_thickness, $fn=fn(40));
    }
    translate([sheet_thickness/2, 0])
      square([wall, sheet_depth_outside + extra_width]);
  }

  render()
    difference()
    {
      translate([0, -sheet_depth_outside, 0])
        linear_extrude(height)
        mount_2d();
      // screw hole
      translate([sheet_thickness/2 - eps, extra_width/2, height/2])
        rotate([0, 90, 0])
        cylinder(d=screw_d, h=wall+2*eps, $fn=fn(50));
    }
}


PV_mount();
