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