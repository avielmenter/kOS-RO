PARAMETER max_stage.
PARAMETER curr_stage IS 0.
PARAMETER should_print IS 1.
PARAMETER ullage_delay IS 1.
PARAMETER interstage_delay IS 5.

WHEN SHIP:MAXTHRUST = 0 THEN {
    STAGE.
    SET stage_start TO time.

    IF should_print = 1 {
        PRINT " ".
        PRINT "Stage " + curr_stage + " separation.".
        PRINT "Firing ullage motors...".
    }
    WAIT ullage_delay.

    STAGE.
    IF should_print = 1 { PRINT "Igniting engines.". }
    WAIT interstage_delay.

    STAGE.
    IF should_print = 1 { PRINT "Separating interstage fairing.". }

    SET curr_stage TO curr_stage + 1.

    IF should_print = 1 { PRINT "Now on stage " + curr_stage. }

    IF curr_stage < max_stage {
        PRESERVE.
    }
}.
