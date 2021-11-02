# Rounded Box

Creates a custom sized box with rounded corners and a push-fit lid, without the need for 3D modelling software or skills. 

Options for holes, cable cutouts and two types of standoff for mounting PCBs and the like.



## Usage
Load the file into OpenSCAD, then you can either edit the variables directly in the code, or use the [Customizer](https://www.dr-lex.be/3d-printing/customizer.html). Once you're happy, render the result, then export as an STL for slicing and printing.

### Quick start
For a simple box, you just need to set the box and lid parameters. 

## Parameters
All measurements in mm

### Box
Set the internal dimensions and wall thickness of your box here. You can also choose whether or not to print the two parts.

### Lid
Set the width and height of the lip, plus the clearance applied to get the correct fit. May require some trial and error as the fit is affected by many variables such as flow rate, nozzle size, layer height, printer accuracy. The clearance only applies to the lid, so you can just reprint the lid if you need a different clearance.

---

### Extra features
Extra features such as holes, cable cutouts and standoffs are defined in arrays. Each item is an array itself, so make sure you always retain the outer square brackets.

For example an empty array is `[]`, a single item is `[[a,b,c]]`, two items is `[[a,b,c],[x,y,z]]` and so on.

Holes and cutouts are labelled as north/south/east/west, these refer to the sides of the box as viewed from above, so north would be at the top, and so on.

__N.b.__ I've had issues with the OpenSCAD Customizer ignoring array input so if you find it's not working, you'll need to define them in the code instead.

#### Holes
Holes are entirely surrounded by the surface they're part of. Side holes are diamond-shaped for easy printing, lid and base holes are round. If you want to match up lid and base holes, remember to mirror your offsets on one axis to account for the lid being flipped over.

The hole format is `[<horizontal offset>, <vertical offset>, <hole diameter>]`. For the lid and base, the offsets are applied to the x and y axes respectively. Offsets are calculated from the centre of the external face as viewed.

#### Cutouts
Cutouts are notches in the sides of the box where it meets the lid, intended for cable entry/exit points. 

The cutout format is `[<horizontal offset>, <width>, <height>]`. Offset is calculated from the centre of the external face as viewed.

Cutouts have rounded corners, defined by `cutout_radius`. The radius is limited to half the width or height of the cutout, as this would be a fully rounded corner.

You can also set `cutout_from_lid` to your liking. When set to `true`, this will remove the section of lip behind the cutout for a clean entry point. If set to `false`, the lip will be present but the cutout height will automatically account for the lip height.

---

### Standoffs
__N.b.__ standoffs calculate their position differently from holes, this is to make measuring easier when trying to match up to PCBs etc.

Standoff offsets apply to their central point and are calculated from the internal south-west / bottom-left of the base or lid as viewed from above. Lid standoff offsets do not account for the lip automatically.

This means a standoff placed at `0,0` with a diameter of 4mm will actually encroach 2mm into the walls of the box.

#### Pins
Pins are standoffs which have an upper and lower portion of custom diameter, intended for raising PCBs off the surface.

The pin format is `[<horizontal offset>, <vertical offset>, <lower height>, <lower diameter>, <upper height>, <upper diameter>]`. 

#### Sockets
Sockets are standoffs which have only one section, with an internal hole. They're intended to take threaded inserts, or you could just specify a smaller inner diameter and screw directly into them.

The socket format is `[<horizontal offset>, <vertical offset>, <height>, <inner diameter>, <outer diameter>]`.

---

### Settings
Here you can set the resolution of the final render. Essentially the value of `resolution` is the total number of line segments a circular element such as a rounded corner or hole will be broken down into for rendering, but more information can be found in the [OpenSCAD manual](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Other_Language_Features#.24fa.2C_.24fs_and_.24fn). 

It is recommended to keep this set at the default of `100` unless your renders are taking a very long time, but don't forget to bump it back up before exporting!

---

## Licensing
© Kris Noble 2021

CC BY 4.0 https://creativecommons.org/licenses/by/4.0/

Derived from [Customizable round box with standoffs and lid](https://www.thingiverse.com/thing:1746190) by Simon John, used under CC BY 4.0