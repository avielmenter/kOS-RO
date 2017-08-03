// Include this file when you want to stage automatically WITHOUT ullage thrusters
PARAMETER max_stage.                // the last stage that will start automatically
PARAMETER set_curr_stage IS 0.      // the current stage the rocket is on when this file is included
PARAMETER should_print IS TRUE.     // should messages print to screen?

SET curr_stage TO set_curr_stage.

WHEN SHIP:MAXTHRUST = 0 THEN {
    STAGE.
    SET stage_start TO time.

    IF should_print {
        PRINT " ".
        PRINT "Stage " + curr_stage + " separation.".
    }

    SET curr_stage TO curr_stage + 1.

    IF should_print { PRINT "Now on stage " + curr_stage. }

    IF curr_stage < max_stage {
        PRESERVE.
    }
}.
