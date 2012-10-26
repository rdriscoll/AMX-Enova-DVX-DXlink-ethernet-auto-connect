MODULE_NAME='DVX DXLink Ethernet Input Connect' (DEV dvSwitcherPort, DEV dvDXLink) // dvSwitcherPort (eg 5002:1:0), dvDXLink (eg 15201:01:0)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(*
	20121026 v0.1 RRD
	 Automatically connect a DXLink Tx device to a DVX.
*)    
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

INTEGER TL_DXLINK_ONLINE	= 1;

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

VOLATILE CHAR cDxLinkOnline = 0;
VOLATILE CHAR cDxLinkOnlineRetries = 0;
LONG lDxLinkFastOnlineTimeline[] = { 5000, 5100 }; // 5 secs then another 1 sec
LONG lDxLinkSlowOnlineTimeline[] = { 30000, 30100 }; // 30 secs then another 1 sec

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)

DEFINE_FUNCTION SetDxLinkOnline()
{
	cDxLinkOnlineRetries = 0;
	IF (!TIMELINE_ACTIVE(TL_DXLINK_ONLINE))
		TIMELINE_CREATE(TL_DXLINK_ONLINE, lDxLinkFastOnlineTimeline, MAX_LENGTH_ARRAY(lDxLinkFastOnlineTimeline), TIMELINE_ABSOLUTE, TIMELINE_REPEAT);
	ELSE
		TIMELINE_RESTART(TL_DXLINK_ONLINE);
}

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

TIMELINE_EVENT[TL_DXLINK_ONLINE]
{
	STACK_VAR CHAR cOutput_;
	
	IF(cDxLinkOnline)
		TIMELINE_KILL(TIMELINE.ID);
	ELSE IF(cDxLinkOnlineRetries = 24) // After 24 tries attempt less often (24 * 5 seconds = 2 min)
		TIMELINE_RELOAD(TIMELINE.ID, lDxLinkSlowOnlineTimeline, MAX_LENGTH_ARRAY(lDxLinkSlowOnlineTimeline));
	ELSE
	{
		IF(TIMELINE.SEQUENCE == 1)
			SEND_COMMAND dvSwitcherPort,'dxlink_in_eth-off';
		ELSE
			SEND_COMMAND dvSwitcherPort,'dxlink_in_eth-auto';
	}
	cDxLinkOnlineRetries++;
}

DATA_EVENT[dvDXLink]
{
	ONLINE:
	{
		cDxLinkOnline = 1;
		TIMELINE_KILL(TL_DXLINK_ONLINE); // if it’s online then dxlink-eth must not be off so no need to check
	}
	OFFLINE:
	{
		cDxLinkOnline = 0;
		SetDxLinkOnline();
	}
}

DATA_EVENT[dvSwitcherPort]
{
	ONLINE:
		SetDxLinkOnline();
}

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
