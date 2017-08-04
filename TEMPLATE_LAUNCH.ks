// initialization
// RUNONCEPATH("LaunchGuidance/StagingTrigger.ks", [max_stage]).
// RUNONCEPATH("LaunchGuidance/StagingTriggerUllage.ks", [max_stage], [start_stage]).
RUNONCEPATH("LaunchGuidance/PitchControl.ks").

CLEARSCREEN.

PRINT "Initiating launch sequence...".
PRINT "Throttling up...".

LOCK STEERING TO HEADING(0,90).
LOCK THROTTLE TO 1.

// LAUNCH SEQUENCE GOES HERE

// start mission timer
SET mission_start TO time.
LOCK mission_time TO time - mission_start.

WAIT UNTIL SHIP:ALTITUDE > 1500.
PRINT "Initiating gravity turn...".

// GRAVITY TURN GOES HERE

circularize().
