 #! /usr/bin/env tclsh

set total_iterations 100
set inputfile [open [lindex $argv 0]]
set tracks [split [read $inputfile] "\n"]
close $inputfile

proc printTracksWithCart {tracks i j} {
    set row_index 0
    
    foreach line $tracks {
        if {$row_index == $j} then {
            puts [string replace $line $i $i "O"]
        } else {
            puts $line
        }
        incr row_index
    }
}

proc getTrackAt {tracks i j} {
    set trackPiece [string index [lindex $tracks $j] $i]
    return $trackPiece
}

set x 0
set y 0
set d "R"

set output ""

for {set steps 0} {$steps < $total_iterations} {incr steps} {
    set track [getTrackAt $tracks $x $y]

    # Turning
    if {$d == "R"} then {
        if {$track == "╗"} then { set d "D" } elseif {$track == "╝"} then { set d "U" }
    } elseif {$d == "L"} then {
        if {$track == "╔"} then { set d "D" } elseif {$track == "╚"} then { set d "U" }
    } elseif {$d == "U"} then {
        if {$track == "╔"} then { set d "R" } elseif {$track == "╗"} then { set d "L" }
    } elseif {$d == "D"} then {
        if {$track == "╚"} then { set d "R" } elseif {$track == "╝"} then { set d "L" }
    }

    # Moving
    if {$d == "R"} then {
        set x [expr $x+1]
    } elseif {$d == "L"} then {
        set x [expr $x-1]
    } elseif {$d == "U"} then {
        set y [expr $y-1]
    } elseif {$d == "D"} then {
        set y [expr $y+1]
    }

    if {[expr $steps % 5] == 0 && $steps > 5 && $steps <= 31} then {
        set output [string cat $output "\nStep $steps: x=$x, y=$y"]
    }

    # clear terminal
    puts [exec clear]
    
    # print
    printTracksWithCart $tracks $x $y
    puts ""

    # different speed for vertical movement
    if {$d == "U" || $d == "D"} then {
        after 120
    } else {
        after 70
    }
}

puts $output
puts ""
