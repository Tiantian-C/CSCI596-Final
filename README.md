# Implementation of Kinetic Energy Visualization in Molecular Dynamics Simulation

## Team Members

- Mengtian Chen
- Shulei Wu
- Yu Wu

## Overview

This project aims to visualize the kinetic energy distribution in molecular dynamics simulation through color-coding atoms. The primary objective is to provide an intuitive way to observe atomic motion and energy states by mapping kinetic energy values to a color spectrum, where different colors represent varying levels of atomic motion. Through this visualization, we can better understand the dynamic behavior of atoms in the simulation system, particularly their relative motion and energy distribution patterns.

## Detailed Implementation Steps

### 1. Data Loading

```
1. Open VMD software
2. File → New Molecule
3. Select lmd.xyz file
   - This file contains 50 frames of MD simulation
   - Each frame records positions of 108 argon atoms
4. Set file type as "XYZ"
5. Ensure "Load all frames" is checked
```

### 2. Kinetic Energy Calculation

Execute the following TCL script:

```
# Create atom selector for all atoms
set sel [atomselect top "all"]
# Get total number of frames
set n [molinfo top get numframes]

# Iterate through frames
for {set i 1} {$i < $n} {incr i} {
    # Get positions from current frame
    $sel frame $i
    set pos2 [$sel get {x y z}]
    # Get positions from previous frame
    $sel frame [expr $i-1]
    set pos1 [$sel get {x y z}]

    # Calculate kinetic energy for each atom
    set ke {}
    foreach p1 $pos1 p2 $pos2 {
        # Extract coordinates
        lassign $p1 x1 y1 z1
        lassign $p2 x2 y2 z2

        # Calculate velocity components
        set vx [expr $x2 - $x1]
        set vy [expr $y2 - $y1]
        set vz [expr $z2 - $z1]

        # Calculate and normalize kinetic energy
        set v_squared [expr $vx*$vx + $vy*$vy + $vz*$vz]
        set ke_val [expr 1.0 - exp(-50.0 * $v_squared)]
        lappend ke $ke_val
    }

    # Store kinetic energy values in beta field
    $sel frame $i
    $sel set beta $ke
}
```

### 3. Visualization Settings

```
1. Open Graphics → Representations
2. Configure display parameters:
   - Drawing Method: "VDW"
   - Coloring Method: "Beta"
3. In Trajectory tab:
   - Set Color Scale Data Range
   - Min: 0.0
   - Max: 1.0
```

### 4. Technical Details

### Kinetic Energy Calculation Method

1. Position Change Analysis
    - Calculate displacement between consecutive frames
    - Use as proxy for velocity
2. Energy Normalization
    - Use squared velocity sum as kinetic energy proxy
    - Apply exponential function for normalization
    - Scale factor (50.0) adjusts sensitivity of color mapping
3. Color Mapping
    - Low kinetic energy: Blue
    - High kinetic energy: Red
    - Intermediate values: Color gradient

## Results and Visualization

- Visualization achieved through VMD's color mapping
- Dynamic display of atomic motion
- Color distribution reflects kinetic energy distribution
- Animation playback controlled through VMD Main window

## Files Use

- Input: Data/lmd.xyz (50 frames, 108 argon atoms)
- Format per frame:
    
    ```
    108
    Molecular dynamics simulation of argon
    Ar x y z (coordinates for each atom)
    ```
## Display
![Visualization Example](/Image/visualization.png)
    

## Limitations and Considerations

1. Velocity estimation based on position changes
2. Relative rather than absolute kinetic energy values
3. Color scale may need adjustment based on specific data ranges
   
