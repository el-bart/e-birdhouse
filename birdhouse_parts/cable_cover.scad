use <PV_mount.scad>
include <m3d/all.scad>
include <detail/PV_mock.scad>

wall = 2;
back_wall_h = 30;
front_wall_len = 60;
front_wall_h = 55;

module back_wall(dh)
{
  core_span = 120;
  winglet_angle = 50;
  winglet_len = 40;

  module corner()
  {
    cylinder(d=wall, h=back_wall_h + dh, $fn=fn(20));
  }
  
  module winglet(dir)
  {
    assert(dir==-1 || dir==+1);
    hull()
    {
      corner();
      rotate([0, 0, -1 * dir * winglet_angle ])
        translate([dir*winglet_len, 0, 0])
          corner();
    }
  }

  // center part
  hull()
    for(dir=[-1,+1])
      translate([dir*core_span/2, 0, 0])
        corner();
  // winglets
  for(dir=[-1,+1])
    translate([dir*core_span/2, 0, 0])
      winglet(dir);
}


back_wall(dh=0);


%if($preview)
  translate([])
  {
    rotate([0, 0, 180])
      PV_mock();
    PV_mount();
  }
