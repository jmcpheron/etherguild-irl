// Ethereum Logo Parameters
height = 100;       // Total height of the model
middle_width = 35;  // Width at the middle where the pyramids meet
gap_size = 4;       // Size of the gap between pyramids

// Base Parameters - Adjustable Controls
base_width = 50;    // Width of rectangular base
base_depth = 15;    // Depth of rectangular base
base_height = 110;  // Height of rectangular base
base_offset_x = 0;  // Horizontal offset of base (X axis)
base_offset_y = -0;// Horizontal offset of base (Y axis)
base_offset_z = -60;// Vertical offset of base (Z axis)
round_radius = 3;   // Radius of the rounded edges

// Calculate individual pyramid heights
pyramid_height = (height - gap_size) / 2;

// Module for rounding the side edges (along depth)
module rounded_base_sides(width, depth, height, radius) {
    minkowski() {
        translate([0, radius, radius])
        cube([width, depth - 2*radius, height - 2*radius]);
        
        // Cylinder on its side (along Y axis)
        rotate([90, 0, 0])
        cylinder(r=radius, h=0.0001, $fn=30);
    }
}

// Create a module for the full Ethereum logo
module ethereum_logo() {
    // Add rotation transformation - 45 degrees around Z axis
    rotate([0, 0, 45]) {
        // Upper pyramid
        translate([0, 0, gap_size/2])
        hull() {
            // Bottom face (square)
            translate([-middle_width/2, -middle_width/2, 0])
            cube([middle_width, middle_width, 0.01]);
            
            // Top point
            translate([0, 0, pyramid_height])
            sphere(0.01);
        }
        
        // Lower pyramid (inverted)
        translate([0, 0, -gap_size/2])
        hull() {
            // Top face (square)
            translate([-middle_width/2, -middle_width/2, 0])
            cube([middle_width, middle_width, 0.01]);
            
            // Bottom point
            translate([0, 0, -pyramid_height])
            sphere(0.01);
        }
    }
}

// Module for the half Ethereum logo (front half only)
module half_ethereum_logo() {
    // Use intersection to cut the logo
    intersection() {
        ethereum_logo();
        
        // Cutting plane - extend it 5 units into the base to ensure overlap
        // This ensures there's no gap between the logo and the base
        translate([-100, base_offset_y + base_depth/2 - 5, -100])
        cube([200, 105, 200]);
    }
}

// Create the final model - using explicit union to ensure proper connection
union() {
    // The base with rounded edges
    translate([
        base_offset_x - base_width/2, 
        base_offset_y - base_depth/2, 
        base_offset_z
    ])
    rounded_base_sides(base_width, base_depth, base_height, round_radius);
    
    // Only the front half of the Ethereum logo
    half_ethereum_logo();
}