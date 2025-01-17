include <detail/config.scad>
include <m3d/all.scad>

module plate_holder()
{
  spacing = 0.5;
  base_xy = bh_int_size - spacing*[1,1];
  base = [base_xy.x, base_xy.y, 1];
  span = 5;
  r = 3;
  h = 2*span;

  module boarder()
  {
    base_int = base - span*[2,2,0];
    difference()
    {
      cube(base);
      translate([span, span, -eps])
        cube(base_int + [0,0,2*eps]);
    }
  }

  module corners()
  {
    s = 2*(span+r);
    module corner()
    {
      linear_extrude(h)
        polygon([
          [0, 0],
          [s, 0],
          [0, s]
        ]);
    }

    x = base.x/2;
    y = base.y/2;
    translate([-x, -y, 0])
      rotate([0, 0, -0])
        corner();
    translate([-x, y, 0])
      rotate([0, 0, -90])
        corner();
    translate([x, y, 0])
      rotate([0, 0, -180])
        corner();
    translate([x, -y, 0])
      rotate([0, 0, -270])
        corner();
  }

  intersection()
  {
    union()
    {
      translate([-base.x/2, -base.y/2, 0])
        boarder();
      corners();
    }
    translate([-base.x/2, -base.y/2, 0])
      side_rounded_cube(base + [0,0,h], r, $fn=fn(30));
  }
}


plate_holder();
