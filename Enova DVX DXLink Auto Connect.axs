PROGRAM_NAME='Enova DVX DXLink Auto Connect'
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(*
	The module will turn ethernet on for the DXLink port, then
	if no device comes online in 5 seconds ethernet for the DXLink
	port will be turned	off for a second then back on again, this
	will repeat for 2 minutes and then the retry will be every 
	30 seconds.
	
	It is advised to set the DXLink box IP address, master connection 
	and device ID before using this module as the ethernet channel
	gets turned off every few seconds until the unit is online.
	
	This demo is for a DVX-3155HD with 2 x Tx and 2 x Rx.
	Comment out or delete unused DXlink devices and associated modules.	
	
	20121026 v0.1 RRD
	 Automatically connect a DXLink device to a DVX.
*)    
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

/********************* DVX-x155 inputs *********************/
dvDVX_DXLinkIn_01 = 5002:09:0 // Port  9 is 1st DXLink input on DVX-3155. Change to port 5 for a DVX-2155.
dvDVX_DXLinkIn_02 = 5002:10:0 // Port 10 is 2nd DXLink input on DVX-3155.  Change to port 6 for a DVX-2155.

/******************** DVX-x155 outputs *********************/
dvDVX_DXLinkOut_01 = 5002:01:0 // Port 1 is 1st DXLink input on DVX-3155. Change to port 3 for a DVX-2155.
dvDVX_DXLinkOut_02 = 5002:03:0 // Port 3 is 2nd DXLink input on DVX-3155. Comment out for DVX-2155 as it only has 1 DXLink output .

/*********************** DVX-x155 Tx ***********************/
// started addressing at device 15201 because there is a screenshot in the manual where they used this device number.
dvDXLinkTx_01 		= 15201:01:0 // TX-MULTI-DXLINK 
dvDXLinkTx_02 		= 15202:01:0 // TX-MULTI-DXLINK

/*********************** DVX-x155 Rx ***********************/
dvDXLinkRx_01 		= 15301:01:0 // RX-DXLINK-HDMI
dvDXLinkRx_02 		= 15302:01:0 // RX-DXLINK-HDMI

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

DEFINE_MODULE 'DVX DXLink Ethernet Input Connect' mod1(dvDVX_DXLinkIn_01, dvDXLinkTx_01)
DEFINE_MODULE 'DVX DXLink Ethernet Input Connect' mod2(dvDVX_DXLinkIn_02, dvDXLinkTx_02)

DEFINE_MODULE 'DVX DXLink Ethernet Output Connect' mod1(dvDVX_DXLinkOut_01, dvDXLinkRx_01)
DEFINE_MODULE 'DVX DXLink Ethernet Output Connect' mod2(dvDVX_DXLinkOut_02, dvDXLinkRx_02)

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
