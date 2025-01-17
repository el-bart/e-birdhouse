include <detail/plate_config.scad>
include <m3d/all.scad>

span = 5;
h = 2*span;

module holes_pos()
{
  off = threaded_insert_from_edge + screw_d/2;
  x = base.x/2 - off;
  y = base.y/2- off;
  for(dx=[-x, +x])
    for(dy=[-y, +y])
      translate([dx, dy, 0])
        children();
}

module outline()
{
  translate([-base.x/2, -base.y/2, 0])
    side_rounded_cube(base + [0,0,h], r, $fn=fn(30));
}


module plate_holder()
{
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

  module corner()
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
      corner();
  }

  intersection()
  {
    difference()
    {
      union()
      {
        translate([-base.x/2, -base.y/2, 0])
          boarder();
        corners();
      }
      holes_pos()
        translate([0, 0, 4+h-eps])
        {
          assert(screw_d == 3);
          ti_cnck_m3_short(dl=h);
        }
    }
    outline();
  }
}


plate_holder();
