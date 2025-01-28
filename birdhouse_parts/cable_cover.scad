use <PV_mount.scad>
include <m3d/all.scad>
include <detail/PV_mock.scad>

wall = 2;

back_wall_h = 30;

front_wall_len = 60;
front_wall_h = 55;
front_wall_overlap = 6;

core_span = 100;
winglet_angle = 60;
winglet_len = 40;

PV_slot_spacing = 0.30;


module back_wall(dh=0)
{
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



module front_overlap()
{
  dh = pv_size.z + PV_slot_spacing;

  module connector()
  {
    // TODO
    lin
    intersection()
    {
      projection()
        back_wall();
      translate([-front_wall_overlap, -core_span])
        square((core_span*2)*[1, 1]);
    }
  }

  // front part
  translate([0, 0, -(wall + dh)])
    linear_extrude(wall)
      hull()
      {
        // body support
        intersection()
        {
          projection()
            back_wall();
          translate([-front_wall_overlap, -core_span])
            square((core_span*2)*[1, 1]);
        }
        // bottom part
        translate([-front_wall_overlap, -winglet_len-5])
          square([front_wall_overlap + core_span/2, 1]);
      }
}

front_overlap();
back_wall();


%if($preview)
  translate([-pv_size.x/2, -25, 0])
    {
      rotate([0, 0, 180])
        PV_mock();
      PV_mount();
      // USB plug and cable
      usb_plug_size = [50, 15, 7];
      translate([pv_size.x/2-10, -usb_plug_size.y/2, 2])
        cube(usb_plug_size);
    }
