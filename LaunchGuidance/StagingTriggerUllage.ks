// Include this file when you want to stage automatically WITHOUT ullage thrusters
PARAMETER max_stage.                // the last stage that will start automatically
PARAMETER start_stage IS 0.         // the first stage that will start automatically
PARAMETER init_curr_stage IS 0.      // the current stage the rocket is on when this file is included
PARAMETER should_print IS TRUE.     // should messages print to screen?
PARAMETER ullage_delay IS 1.        // delay in seconds between firing ullage thrusters and firing engines
PARAMETER interstage_delay IS 5.    // delay in seconds before firing engines and separating interstage (set to -1 to not separate interstage)

SET curr_stage TO init_curr_stage.
SET stage_start TO TIME.

WHEN SHIP:MAXTHRUST = 0 AND curr_stage >= start_stage THEN {
    STAGE.
    SET stage_start TO TIME.

    IF should_print {
        PRINT " ".
        PRINT "Stage " + curr_stage + " separation.".
        PRINT "Firing ullage motors...".
    }

    WAIT ullage_delay.
    STAGE.
    IF should_print { PRINT "Igniting engines.". }

    IF interstage_delay >= 0 {
        WAIT interstage_delay.
        STAGE.
        IF should_print { PRINT "Separating interstage fairing.". }
    }

    SET curr_stage TO curr_stage + 1.

    IF should_print { PRINT "Now on stage " + curr_stage. }

    IF curr_stage < max_stage {
        PRESERVE.
    }
}.

FUNCTION get_curr_stage {
    RETURN curr_stage.
}

FUNCTION set_curr_stage {
    PARAMETER set_curr_stage.
    SET curr_stage TO set_curr_stage.
}

FUNCTION increment_stage {
    SET curr_stage TO curr_stage + 1.
}

FUNCTION get_stage_time {
    SET stage_time TO TIME - stage_start.
    return stage_time:SECONDS.
}
