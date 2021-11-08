/******************************************************************************
*
* Rounded Box
* v0.1.1
* Kris Noble 2021
* Licence: CC BY 4.0 https://creativecommons.org/licenses/by/4.0/
* Derived from https://www.thingiverse.com/thing:1746190 by Simon John
*
/******************************************************************************/

/******************************************************************************
* Parameters
* All measurements in mm
/******************************************************************************/

/* [Box] */
internal_length = 90;
internal_width  = 60;
internal_height = 30;
wall_thickness  = 2;

print_box = true;
print_lid = true;

/* [Lid] */
lip_width = 2;
lip_height = 2;
// May need adjusting +/- to get a good fit depending on your setup.
lip_clearance = 0.00;

/* [Holes] */
// Hole format: [<horizontal offset>, <vertical offset>, <hole diameter>]. Offsets are calculated from the centre of the external face as viewed. Side holes are diamonds for easy printing.
holes_n = [];
holes_e = [];
holes_s = [];
holes_w = [];

// Base and lid holes are round.
holes_lid  = [];
holes_base = [];

/* [Cutouts] */
//Cutout format: [<horizontal offset>, <width>, <height>]. Offset is calculated from the centre of the external face as viewed.
cutouts_n = [[0,10,5]];
cutouts_e = [];
cutouts_s = [[0,10,5]];
cutouts_w = [];

// Radius of cutout corners. Limited to (cutout width / 2) and ((cutout height + lip height) / 2) to avoid weirdness.
cutout_radius = 1;
// Remove cutout from lip? If not, cutout heights will account for the lip automatically.
cutout_from_lid = true;

/* [Pins] */
// Pin format: [<horizontal offset>, <vertical offset>, <lower height>, <lower diameter>, <upper height>, <upper diameter>,]. Offsets apply to the central point of the pin and are calculated from the internal south-west / bottom-left of the base or lid as viewed from above. Lid pin offsets do not account for the lip.
pins_base = [];
pins_lid  = [];

/* [Sockets] */
// Socket format: [<horizontal offset>, <vertical offset>, <height>, <inner diameter>, <outer diameter>]. Offsets apply to the central point of the socket and are calculated from the internal south-west / bottom-left of the base or lid as viewed from above. Lid socket offsets do not account for the lip.
sockets_base = [];
sockets_lid  = [];

/* [Settings] */
// Recommended to keep this at 100 but can be adjusted down for quicker rendering.
resolution = 100;

/****************************************
* Edit below this line at your own risk!
/****************************************/

/* [Hidden] */
// Set global resolution and Minkowski cylinder height
$fn = resolution;
minkowski_cylinder_height = 0.000000001;

// Calculated values
corner_radius = wall_thickness;
external_length = internal_length + (wall_thickness * 2);
external_width = internal_width + (wall_thickness * 2);
box_height = internal_height + wall_thickness; // Height of box without lid

/******************************************************************************
* Modules
/******************************************************************************/

module normalBox(length, width, height)
{
	cube(size=[width,length, height]);
}

module roundedBox(length, width, height, radius, minkowski_cylinder_height=minkowski_cylinder_height)
{
	minkowski() {
		cube(size=[width-(radius*2),length-(radius*2), height]);
		cylinder(r=radius, h=minkowski_cylinder_height);
	}
}

module cutout(length, width, height, radius, minkowski_cylinder_height=minkowski_cylinder_height)
{
	minkowski() {
		cube(size=[width-(radius*2),length-(radius*2), height]);
		cylinder(r=radius, h=minkowski_cylinder_height);
		
	}
	translate([-radius,0,0]){
		cube(size=[width,length, height]);
	}
}

/*****************************************************************************
* Build
/*****************************************************************************/

translate([corner_radius, corner_radius, 0]) {

	/****************************************/
	// Box

	if(print_box) {
		difference() {
			roundedBox(external_length, external_width, box_height, corner_radius); 
			translate([0,0,wall_thickness]) {
				normalBox(internal_length, internal_width, box_height); 
			}
			
			/********************/
			// Holes and cutouts
			
			// North face aka top when viewed from above
			for(hole = holes_n) {
				offset_h = hole[0];
				offset_v = hole[1];
				diameter = hole[2];
				translate([(internal_width/2)-(diameter/2)-offset_h,internal_length+wall_thickness+0.5,(box_height/2)+offset_v]) {
					resize([diameter,wall_thickness+1, diameter]) {
						rotate([90,45,0]) {
							cube([1,1,wall_thickness+1]);
						}
					}
				}
			}
			
			for(cutout = cutouts_n) {
				offset_x = cutout[0];
				width = cutout[1];
				height = cutout_from_lid ? cutout[2] : cutout[2]+lip_height;
				radius = min(cutout_radius, (width/2)-minkowski_cylinder_height, (height/2)-minkowski_cylinder_height);
				
				translate([internal_width/2-width/2+radius-offset_x,internal_length+wall_thickness+0.5,(box_height-height)+radius]) {
					rotate([90,0,0]){
						cutout(height,width,wall_thickness+1, radius, wall_thickness+1);
					}
				}
			}
			
			// East aka right
			for(hole = holes_e) {
				offset_h = hole[0];
				offset_v = hole[1];
				diameter = hole[2];
				
				translate([internal_width-0.5,(internal_length/2)-(diameter/2)+offset_h,(box_height/2)+offset_v]) {
					resize([wall_thickness+1, diameter, diameter]) {
						rotate([0,90,0]) {
							rotate([0,0,45]) {
								cube([diameter,diameter,wall_thickness+1]);
							}
						}
					}
				}
			}
			
			for(cutout = cutouts_e) {
				offset_x = cutout[0];
				width = cutout[1];
				height = cutout_from_lid ? cutout[2] : cutout[2]+lip_height;
				radius = min(cutout_radius, (width/2)-minkowski_cylinder_height, (height/2)-minkowski_cylinder_height);
				
				translate([internal_width-0.5,(internal_length/2)-(width/2)+radius+offset_x,(box_height-height)+radius]) {
					rotate([0,0,90]) rotate([90,0,0]){
						cutout(height,width,wall_thickness+1, radius);
					}
				}
			}
			
			// South aka bottom
			for(hole = holes_s) {
				offset_h = hole[0];
				offset_v = hole[1];
				diameter = hole[2];
				translate([(internal_width/2)-(diameter/2)+offset_h,0.5,(box_height/2)+offset_v]) {
					resize([diameter,wall_thickness+1, diameter]) {
						rotate([90,45,0]) {
							cube([1,1,wall_thickness+1]);
						}
					}
				}
			}
			
			for(cutout = cutouts_s) {
				offset_x = cutout[0];
				width = cutout[1];
				height = cutout_from_lid ? cutout[2] : cutout[2]+lip_height;
				radius = min(cutout_radius, (width/2)-minkowski_cylinder_height, (height/2)-minkowski_cylinder_height);
				
				translate([(internal_width/2)-(width/2)+radius+offset_x,0.5,(box_height-height)+radius]) {
					rotate([90,0,0]){
						cutout(height,width,wall_thickness+1, radius, wall_thickness+1);
					}
				}
				
			}
			
			// West aka left
			for(hole = holes_w) {
				offset_h = hole[0];
				offset_v = hole[1];
				diameter = hole[2];
				
				translate([0-(wall_thickness+0.5),(internal_length/2)-(diameter/2)-offset_h,(box_height/2)+offset_v]) {
					resize([wall_thickness+1, diameter, diameter]) {
						rotate([0,90,0]) {
							rotate([0,0,45]) {
								cube([diameter,diameter,wall_thickness+1]);
							}
						}
					}
				}
			}
			
			for(cutout = cutouts_w) {
				offset_x = cutout[0];
				width = cutout[1];
				height = cutout_from_lid ? cutout[2] : cutout[2]+lip_height;
				radius = min(cutout_radius, (width/2)-minkowski_cylinder_height, (height/2)-minkowski_cylinder_height);
				
				translate([-wall_thickness-0.5,(internal_length/2)-(width/2)+radius-offset_x,box_height-height+radius]) {
					rotate([0,0,90]) rotate([90,0,0]){
						cutout(height,width,wall_thickness+1, radius);
					}
				}
			}
			
			// Base 
			for(hole = holes_base) {
				offset_x = hole[0];
				offset_y = hole[1];
				diameter = hole[2];
				translate([(internal_width/2)+offset_x,(internal_length/2)+offset_y,-0.5]) {
					cylinder(d=diameter, h=wall_thickness+1);
				}
			}
			
		}
		
		// Pins
		for(pin = pins_base) {
			offset_x = pin[0];
			offset_y = pin[1];
			lower_height = pin[2];
			lower_diameter = pin[3];
			upper_height = pin[4];
			upper_diameter = pin[5];
			
			translate([offset_x+wall_thickness,offset_y+wall_thickness,wall_thickness]) {
				cylinder(d=lower_diameter, h=lower_height);
			}
			translate([offset_x+wall_thickness,offset_y+wall_thickness,wall_thickness+lower_height]) {
				cylinder(d=upper_diameter, h=upper_height);
			}
		}
		
		// Sockets
		for(socket = sockets_base) {
			offset_x = socket[0];
			offset_y = socket[1];
			height = socket[2];
			inner_diameter = socket[3];
			outer_diameter = socket[4];
			
			difference(){
				translate([offset_x+wall_thickness,offset_y+wall_thickness,wall_thickness]) {
					cylinder(d=outer_diameter, h=height);
				}
				translate([offset_x+wall_thickness,offset_y+wall_thickness,wall_thickness]) {
					cylinder(d=inner_diameter, h=height+0.1);
				}
			}
		}
	}

	/****************************************/
	// Lid

	if(print_lid) {
		translate([external_width+wall_thickness*2, 0, 0]) {
			difference() {
				roundedBox(external_length, external_width, wall_thickness, corner_radius);
				/********************/
				// Lid holes
				for(hole = holes_lid) {
					offset_x = hole[0];
					offset_y = hole[1];
					diameter = hole[2];
					translate([(internal_width/2)+offset_x,(internal_length/2)+offset_y,-0.5]) {
						cylinder(d=diameter, h=wall_thickness+1);
					}
				}
			}
			difference() {
				translate([(lip_clearance),(lip_clearance),wall_thickness]) {
					normalBox(internal_length-(lip_clearance*2),internal_width-(lip_clearance*2),lip_height);
				}
				translate([lip_width+lip_clearance,lip_width+lip_clearance,wall_thickness]) {
					normalBox(internal_length-(lip_width*2)-(lip_clearance*2),internal_width-(lip_width*2)-(lip_clearance*2),lip_height+1);
				}
				
				/********************/
				// Lid cutouts
				if(cutout_from_lid){
					for(cutout = cutouts_n) {
						offset_x = cutout[0];
						width = cutout[1];
						
						translate([(internal_width/2)-(width/2)+offset_x,(internal_length-lip_width-lip_clearance)-0.5,wall_thickness]) {
							normalBox(lip_width+1,width,lip_height+0.5);
						}
						
					}
					
					for(cutout = cutouts_e) {
						offset_x = cutout[0];
						width = cutout[1];
						
						translate([lip_clearance-0.5,(internal_length/2)-(width/2)+offset_x,wall_thickness]) {
							normalBox(width,lip_width+1,lip_height+0.5);
						}
						
					}
					
					for(cutout = cutouts_s) {
						offset_x = cutout[0];
						width = cutout[1];
						
						translate([(internal_width/2)-(width/2)-offset_x,lip_clearance-0.5,wall_thickness]) {
							normalBox(lip_width+1,width,lip_height+0.5);
						}
						
					}
					
					for(cutout = cutouts_w) {
						offset_x = cutout[0];
						width = cutout[1];
						
						translate([(internal_width-lip_width)-0.5-lip_clearance,(internal_length/2)-(width/2)-offset_x,wall_thickness]) {
							normalBox(width,lip_width+1,lip_height+0.5);
						}
						
					}
				}
				
			}
			// Pins
				for(pin = pins_lid) {
					offset_x = pin[0];
					offset_y = pin[1];
					lower_height = pin[2];
					lower_diameter = pin[3];
					upper_height = pin[4];
					upper_diameter = pin[5];
					
					translate([offset_x+(wall_thickness),offset_y+(wall_thickness),wall_thickness]) {
						cylinder(d=lower_diameter, h=lower_height);
					}
					translate([offset_x+(wall_thickness),offset_y+(wall_thickness),wall_thickness+lower_height]) {
						cylinder(d=upper_diameter, h=upper_height);
					}
				}
				
				// Sockets
				for(socket = sockets_lid) {
					offset_x = socket[0];
					offset_y = socket[1];
					height = socket[2];
					inner_diameter = socket[3];
			outer_diameter = socket[4];
					
					difference(){
						translate([offset_x+(lip_clearance)+(wall_thickness),offset_y+lip_clearance+(wall_thickness),wall_thickness]) {
							cylinder(d=outer_diameter, h=height);
						}
						translate([offset_x+(lip_clearance)+(wall_thickness),offset_y+lip_clearance+(wall_thickness),wall_thickness]) {
							cylinder(d=inner_diameter, h=height+0.1);
						}
					}
				}
		}
	}
}