PARAMETER max_stage.
PARAMETER set_curr_stage IS 0.
PARAMETER should_print IS TRUE.
PARAMETER ullage_delay IS 1.
PARAMETER interstage_delay IS 5.

SET curr_stage TO set_curr_stage.

WHEN SHIP:MAXTHRUST = 0 THEN {
    STAGE.
    SET stage_start TO time.

    IF should_print {
        PRINT " ".
        PRINT "Stage " + curr_stage + " separation.".
        PRINT "Firing ullage motors...".
    }
    WAIT ullage_delay.

    STAGE.
    IF should_print { PRINT "Igniting engines.". }
    WAIT interstage_delay.

    STAGE.
    IF should_print { PRINT "Separating interstage fairing.". }

    SET curr_stage TO curr_stage + 1.

    IF should_print { PRINT "Now on stage " + curr_stage. }

    IF curr_stage < max_stage {
        PRESERVE.
    }
}.
