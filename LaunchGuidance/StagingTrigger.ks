PARAMETER max_stage.
PARAMETER set_curr_stage IS 0.
PARAMETER should_print IS 1.

SET curr_stage TO set_curr_stage.

WHEN SHIP:MAXTHRUST = 0 THEN {
    STAGE.
    SET stage_start TO time.

    IF should_print = 1 {
        PRINT " ".
        PRINT "Stage " + curr_stage + " separation.".
    }

    SET curr_stage TO curr_stage + 1.

    IF should_print = 1 { PRINT "Now on stage " + curr_stage. }

    IF curr_stage < max_stage {
        PRESERVE.
    }
}.
