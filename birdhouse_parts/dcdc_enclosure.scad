include <m3d/all.scad>

pcb_size = [43.7, 21.1, 15.1];
usb_socket_size = [12, 14.5, 14.5];
usb_offset = 5;
radiator_h = 25.9;
PV_cable_d = 6.1;
PV_cable_offset = 5;

module pcb_mock()
{
  // PV power cable
  translate([PV_cable_d/2, pcb_size.y/2, 0])
    cylinder(d=PV_cable_d, h=radiator_h, $fn=fn(30));
  // PCB
  translate([PV_cable_d + PV_cable_offset, 0, 0])
  {
    cube(pcb_size);
    // radiator 1
    translate([14.8, 14.1, 0])
      cylinder(d=5, h=radiator_h, $fn=fn(20));
    // radiator 2
    translate([27, 7, 0])
      cylinder(d=5, h=radiator_h, $fn=fn(20));
    // usb mock
    translate([pcb_size.x + usb_offset, pcb_size.y/2, radiator_h])
      translate([0, -usb_socket_size.y/2, -usb_socket_size.z])
      cube(usb_socket_size);
  }
}


module enclosure(mocks=false)
{
  pcb_full_size = [ PV_cable_d + PV_cable_offset + pcb_size.x + usb_offset + usb_socket_size.x,
                    max(pcb_size.y, usb_socket_size.y),
                    max(radiator_h, pcb_size.z, usb_socket_size.z) ];
  wall = 2;
  spacing = 3;
  box_int = pcb_full_size + spacing*[2,2,0];
  box_ext = box_int + wall*[2,2,1];

  module screw_slots()
  {
    screw_side_space = 15;
    screw_d = 3 + 0.5;
    rounding = 10;
    scew_pad_size = [box_ext.x, box_ext.y, wall] + screw_side_space*[2,0,0];
    translate([-screw_side_space, 0, 0])
      difference()
      {
        side_rounded_cube(scew_pad_size, rounding);
        for(dx=[screw_side_space/2, scew_pad_size.x - screw_side_space/2])
          translate([dx, scew_pad_size.y/2, -eps])
            cylinder(d=screw_d, h=wall+2*eps, $fn=fn(50));
      }
  }

  module box()
  {
    rounding = 5;
    zip_tie_slot = [wall+2*eps, 2, 5];
    difference()
    {
      $fn=fn(30);
      side_rounded_cube(box_ext, rounding);
      translate(wall*[1,1,0] + eps*[0,0,-1])
        side_rounded_cube(box_int + wall*[0,0,1] + eps*[0,0,2], rounding-wall);
      // zip ties slots for cable mounts
      for(dx=[0, box_ext.x-wall])
        for(dy=[-1,+1])
          translate([dx, dy*(PV_cable_d/2 + 1), box_ext.z - zip_tie_slot.z - 5])
            translate([-eps, -zip_tie_slot.y/2 + box_ext.y/2, 0])
            cube(zip_tie_slot);
    }
  }

  screw_slots();
  translate(wall*[0,0,1])
  {
    box();
    %if(mocks)
      translate(wall*[1,1,1] + spacing*[1,1,0])
      pcb_mock();
  }
}


enclosure(mocks=$preview);
