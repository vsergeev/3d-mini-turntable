/********************************************************
 * Mini Turntable - vsergeev
 * https://github.com/vsergeev/3d-mini-turntable
 * CC-BY-4.0
 *
 * Release Notes
 *  * v1.0 - 02/19/2022
 *      * Initial release.
 ********************************************************/

/* [Visibility] */

turntable_type = "cube"; // [cube, ring]

connector_type = "wire"; // [wire, usb]

show_motor = true;

show_usb_connector = true;

show_stand = true;

show_turntable = true;

show_base = true;

show_cross_section = true;

/******************************************************************************/
/* Modeled Dimensions */
/******************************************************************************/

motor_x_width = 12;
motor_y_height = 10;
motor_z_depth = 28;

motor_shaft_z_depth = 10;
motor_shaft_xy_diameter = 3;
motor_shaft_xy_slot_width = 2.5;

usb_connector_x_width = 7.40;
usb_connector_z_height = 2.30;
usb_connector_y_depth = 6.00;

usb_connector_pcb_x_width = 20.32;
usb_connector_pcb_y_height = 11.43;
usb_connector_pcb_z_depth = 1.5;

usb_connector_pcb_solder_x_width = 12.5;
usb_connector_pcb_solder_y_height = 3;
usb_connector_pcb_solder_z_depth = 0.8;

wire_connector_xz_diameter = 3.0;

/******************************************************************************/
/* Parameters */
/******************************************************************************/

/* Turntable Parameters */

turntable_xy_diameter = 20;

turntable_holder_xy_width = 20;
turntable_holder_z_depth = 4.8;
turntable_holder_y_thickness = 5;

turntable_stand_xy_clearance = 1;
turntable_shaft_xy_clearance = 0.075;

/* Stand Parameters */

stand_slope = 0.2;
stand_wall_xy_thickness = 1.5;
stand_shaft_z_protrusion = 5;
stand_motor_cavity_z_depth = 12;
stand_bottom_z_gap = 6.5;

stand_motor_shaft_xy_clearance = 1.25;
stand_usb_connector_xz_clearance = 0.1;
stand_wire_connector_xz_clearance = 0.2;
stand_motor_cavity_xy_clearance = 0.1;

/* Base Parameters */

base_z_depth = 3;
base_lip_z_depth = 3;

base_motor_peg_base_xy_diameter = 5.5;
base_motor_peg_base_z_depth = stand_bottom_z_gap - base_lip_z_depth;
base_motor_peg_xy_diameter = 1.75;
base_motor_peg_z_depth = 0.8;

base_wire_connector_y_length = 12;

base_stand_xy_clearance = 0.05;
base_usb_connector_xy_clearance = 0.10;
base_wire_connector_x_clearance = -0.10;

/* Constants */

$fn = 100;

overlap_epsilon = 0.05;

/******************************************************************************/
/* Derived Parameters */
/******************************************************************************/

stand_z_depth = motor_z_depth + motor_shaft_z_depth + stand_bottom_z_gap + turntable_xy_diameter / 2 - stand_shaft_z_protrusion;

stand_outer_xy_top_width = turntable_xy_diameter + stand_wall_xy_thickness * 2;
stand_inner_xy_top_width = stand_outer_xy_top_width + stand_slope * (motor_z_depth - stand_motor_cavity_z_depth - stand_bottom_z_gap);

stand_outer_xy_bottom_width = stand_outer_xy_top_width + (stand_slope * stand_z_depth);
stand_inner_xy_bottom_width = stand_outer_xy_bottom_width - stand_wall_xy_thickness * 2;

usb_connector_position = [0, (usb_connector_pcb_y_height + 2 * base_usb_connector_xy_clearance) / 2 - stand_inner_xy_bottom_width / 2];

/******************************************************************************/
/* 2D Profiles */
/******************************************************************************/

module profile_motor_body() {
    square([motor_x_width, motor_y_height], center=true);
}

module profile_motor_shaft() {
    difference() {
        circle(d=motor_shaft_xy_diameter);
        translate([motor_shaft_xy_slot_width, 0])
            square([motor_shaft_xy_diameter, motor_shaft_xy_diameter], center=true);
    }
}

module profile_usb_connector_cutout() {
    translate([0, (usb_connector_z_height + stand_usb_connector_xz_clearance) / 2 - overlap_epsilon, 0])
        square([usb_connector_x_width + stand_usb_connector_xz_clearance,
                usb_connector_z_height + stand_usb_connector_xz_clearance + overlap_epsilon], center=true);
}

module profile_usb_connector_footprint() {
    translate([0, -(usb_connector_pcb_y_height - usb_connector_y_depth) / 2 - 1])
        square([usb_connector_x_width, usb_connector_y_depth], center=true);
}

module profile_usb_connector_pcb_footprint() {
    square([usb_connector_pcb_x_width, usb_connector_pcb_y_height], center=true);
}

module profile_usb_connector_pcb_solder_footprint() {
    translate([0, (usb_connector_pcb_y_height - usb_connector_pcb_solder_y_height) / 2])
        square([usb_connector_pcb_solder_x_width, usb_connector_pcb_solder_y_height], center=true);
}

module profile_wire_connector_cutout() {
    union() {
        translate([0, wire_connector_xz_diameter / 2])
            circle(d=wire_connector_xz_diameter);
        translate([0, wire_connector_xz_diameter / 4])
            square([wire_connector_xz_diameter, wire_connector_xz_diameter / 2], center=true);
    }
}

module profile_wire_connector_footprint() {
    square([wire_connector_xz_diameter + base_wire_connector_x_clearance,
           base_wire_connector_y_length], center=true);
}

/******************************************************************************/
/* 3D Helpers */
/******************************************************************************/

module prism(top_xy_width, bottom_xy_width, z_depth) {
    polyhedron(
        [
            [  -bottom_xy_width / 2,  -bottom_xy_width / 2,  0 ],
            [ bottom_xy_width / 2,  -bottom_xy_width / 2,  0 ],
            [ bottom_xy_width / 2,  bottom_xy_width / 2,  0 ],
            [  -bottom_xy_width / 2,  bottom_xy_width / 2,  0 ],
            [  -top_xy_width / 2,  -top_xy_width / 2,  z_depth ],
            [ top_xy_width / 2,  -top_xy_width / 2,  z_depth ],
            [ top_xy_width / 2,  top_xy_width / 2,  z_depth ],
            [  -top_xy_width / 2,  top_xy_width / 2,  z_depth ]
        ],
        [
            [0, 1, 2, 3],
            [4, 5, 1, 0],
            [7, 6, 5, 4],
            [5, 6, 2, 1],
            [6, 7, 3, 2],
            [7, 4, 0, 3]
        ],
        convexity=10
    );
}

/******************************************************************************/
/* 3D Extrusions */
/******************************************************************************/

module motor() {
    color("silver") {
        union() {
            /* Motor and Gearbox Body */
            linear_extrude(motor_z_depth)
                profile_motor_body();

            /* Shaft */
            translate([0, 0, motor_z_depth])
                linear_extrude(motor_shaft_z_depth)
                    profile_motor_shaft();
        }
    }
}

module usb_connector() {
    color("silver") {
        union() {
            /* PCB */
            linear_extrude(usb_connector_pcb_z_depth)
                profile_usb_connector_pcb_footprint();

            /* Connector */
            translate([0, 0, usb_connector_pcb_z_depth])
                linear_extrude(usb_connector_z_height)
                    profile_usb_connector_footprint();
        }
    }
}

module stand() {
    difference() {
        /* Outside of stand */
        prism(stand_outer_xy_top_width, stand_outer_xy_bottom_width, stand_z_depth);

        /* Turntable cutout */
        translate([0, 0, stand_z_depth])
            sphere(d=turntable_xy_diameter);

        /* Shaft bore */
        translate([0, 0, motor_z_depth + stand_bottom_z_gap - overlap_epsilon])
            cylinder(d=motor_shaft_xy_diameter + stand_motor_shaft_xy_clearance, h=motor_shaft_z_depth + overlap_epsilon);

        /* Motor Cavity */
        translate([0, 0, motor_z_depth + stand_bottom_z_gap - stand_motor_cavity_z_depth - overlap_epsilon])
            linear_extrude(stand_motor_cavity_z_depth + overlap_epsilon)
                offset(stand_motor_cavity_xy_clearance)
                    profile_motor_body();

        /* Inside of stand */
        translate([0, 0, -overlap_epsilon])
            prism(stand_inner_xy_top_width, stand_inner_xy_bottom_width,
                  motor_z_depth + stand_bottom_z_gap - stand_motor_cavity_z_depth + overlap_epsilon);

        if (connector_type == "usb") {
            /* USB connector cutout */
            rotate([90, 0, 0])
                linear_extrude(stand_outer_xy_bottom_width + overlap_epsilon)
                    profile_usb_connector_cutout();
        } else if (connector_type == "wire") {
            /* Wire connector cutout */
            rotate([90, 0, 0])
                linear_extrude(stand_outer_xy_bottom_width + overlap_epsilon)
                    offset(stand_wire_connector_xz_clearance)
                        profile_wire_connector_cutout();
        }
    }
}

module turntable() {
    difference() {
        difference() {
            /* Sphere */
            sphere(d=turntable_xy_diameter - turntable_stand_xy_clearance);

            /* Remove top half */
            translate([-turntable_xy_diameter / 2, -turntable_xy_diameter / 2, 0])
                cube([turntable_xy_diameter, turntable_xy_diameter, turntable_xy_diameter]);
        }

        /* Shaft */
        translate([0, 0, -turntable_xy_diameter / 2])
            linear_extrude(stand_shaft_z_protrusion)
                offset(turntable_shaft_xy_clearance)
                    profile_motor_shaft();

        /* Holder */
        if (turntable_type == "cube") {
            /* Cube corner holder */
            translate([0, 0, -turntable_holder_z_depth])
                rotate([45, -atan(cos(45)), 0])
                    cube(turntable_holder_xy_width);
        } else if (turntable_type == "ring") {
            /* Ring holder */
            translate([0, 0, turntable_holder_xy_width / 2 - turntable_holder_z_depth])
                rotate([90, 0, 0])
                    linear_extrude(turntable_holder_y_thickness, center=true)
                        circle(d=turntable_holder_xy_width);
        }
    }
}

module base() {
    difference() {
        union() {
            /* Base */
            prism(stand_outer_xy_bottom_width, stand_outer_xy_bottom_width + stand_slope * base_z_depth, base_z_depth);

            /* Lip */
            translate([0, 0, base_z_depth - overlap_epsilon])
                prism(stand_inner_xy_bottom_width - base_stand_xy_clearance - stand_slope * base_lip_z_depth,
                      stand_inner_xy_bottom_width - base_stand_xy_clearance, base_lip_z_depth + overlap_epsilon);

            /* Motor center mount base */
            translate([0, 0, base_z_depth + base_lip_z_depth - overlap_epsilon])
                linear_extrude(base_motor_peg_base_z_depth + overlap_epsilon)
                    circle(d=base_motor_peg_base_xy_diameter);

            /* Motor center mount */
            translate([0, 0, base_z_depth + base_lip_z_depth + base_motor_peg_base_z_depth - overlap_epsilon])
                linear_extrude(base_motor_peg_z_depth + overlap_epsilon)
                    circle(d=base_motor_peg_xy_diameter);
        }

        if (connector_type == "usb") {
            /* USB Connector PCB footprint */
            translate(concat(usb_connector_position, base_z_depth - usb_connector_pcb_z_depth - overlap_epsilon))
                linear_extrude(base_lip_z_depth + usb_connector_pcb_z_depth + 2 * overlap_epsilon)
                    offset(base_usb_connector_xy_clearance)
                        profile_usb_connector_pcb_footprint();

            /* USB Connector PCB solder footprint */
            translate(concat(usb_connector_position, base_z_depth - usb_connector_pcb_z_depth - usb_connector_pcb_solder_z_depth))
                linear_extrude(usb_connector_pcb_solder_z_depth + overlap_epsilon)
                    offset(base_usb_connector_xy_clearance)
                        profile_usb_connector_pcb_solder_footprint();
        } else if (connector_type == "wire") {
            /* Wire Connector footprint */
            translate([0, -(stand_inner_xy_bottom_width - base_wire_connector_y_length) / 2,
                       base_z_depth - overlap_epsilon])
                linear_extrude(base_lip_z_depth + 2 * overlap_epsilon)
                    profile_wire_connector_footprint();
        }
    }
}

/******************************************************************************/
/* Top Level */
/******************************************************************************/

module assembly() {
    if (show_motor) {
        translate([0, 0, stand_bottom_z_gap])
            motor();
    }

    if (show_usb_connector) {
        translate(concat(usb_connector_position, -usb_connector_pcb_z_depth))
            usb_connector();
    }

    if (show_stand) {
        stand();
    }

    if (show_turntable) {
        translate([0, 0, stand_z_depth])
            turntable();
    }

    if (show_base) {
        translate([0, 0, -base_z_depth])
            base();
    }
}

difference() {
    assembly();

    /* Model cross-section */
    if (show_cross_section) {
        translate([-stand_outer_xy_bottom_width, 0, -stand_z_depth / 2])
            cube([2 * stand_outer_xy_bottom_width, stand_outer_xy_bottom_width, stand_z_depth * 2]);
    }
}
