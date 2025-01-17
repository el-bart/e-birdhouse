include <m3d/all.scad>

roof_extra_side = 17/2;
roof_vertical_h = 26;
tap_in_screw_d = 2.9;
screw_d = 3;
spacing = 3;
r = 1.5;

v = spacing*2 + screw_d;

module bottom_hold()
{
  size = [v, v, roof_extra_side];
  difference()
  {
    union()
    {
      side_rounded_cube(size, r, $fn=fn(30));
      translate([0, -v, 0])
        side_rounded_cube([size.x, size.y + 2*v, 2], r, $fn=fn(30));
    }
    for(dy=[-v, +v])
      translate([size.x/2, v/2 + dy, -eps])
        cylinder(d=tap_in_screw_d, h=size.z+2*eps, $fn=fn(30));
    translate([size.x/2, v/2, size.z + eps])
      ti_cnck_m3_standard(dl=size.z);
  }
}


module roof_top_mount(mocks)
{
  v = spacing*2 + screw_d;
  size = [roof_vertical_h + v + spacing, v, 2];
  difference()
  {
    side_rounded_cube(size, r, $fn=fn(20));
    translate([0, size.y/2, -eps])
    {
      for(dx=[0:2-1])
        translate([2*spacing + dx*(tap_in_screw_d + 2*spacing), 0, 0])
          cylinder(d=tap_in_screw_d, h=size.z+2*eps, $fn=fn(30));
      translate([size.x - spacing - screw_d/2, 0, 0])
        cylinder(d=screw_d, h=size.z+2*eps, $fn=fn(30));
    }
  }

  %if(mocks)
  {
    translate([0, -size.y, -size.z/2])
      cube([roof_vertical_h, 3*size.y, size.z/2]);
    translate([size.x - v, 0, -roof_extra_side])
      bottom_hold();
  }
  
}


translate([-v - 2, 0, 0])
  bottom_hold();

roof_top_mount(mocks=$preview);
