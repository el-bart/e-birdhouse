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

  module corner(hole=true)
  {
    s = 2*(span+r);
    difference()
    {
      linear_extrude(h)
        polygon([
          [0, 0],
          [s, 0],
          [0, s]
        ]);
      if(hole)
        translate(s*1/3*[1,1,0] + [0, 0, 4+h-eps])
          ti_cnck_m3_short(dl=h);
    }
  }

  module corners_pos()
  {
    x = base.x/2;
    y = base.y/2;
    translate([-x, -y, 0])
      rotate([0, 0, -0])
        children();
    translate([-x, y, 0])
      rotate([0, 0, -90])
        children();
    translate([x, y, 0])
      rotate([0, 0, -180])
        children();
    translate([x, -y, 0])
      rotate([0, 0, -270])
        children();
  }

  module corners(holes)
  {
    corners_pos()
      corner(hole=holes);
  }

  module outline()
  {
    translate([-base.x/2, -base.y/2, 0])
      side_rounded_cube(base + [0,0,h], r, $fn=fn(30));
  }

  intersection()
  {
    union()
    {
      difference()
      {
        translate([-base.x/2, -base.y/2, 0])
          boarder();
        corners(holes=false);
      }
      corners(holes=true);
    }
    outline();
  }
}


plate_holder();
