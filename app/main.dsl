
context {
	input phone: string;
	input forward: string? = null;
	
	feelingResponse: string = "";
	intentConfused; string = "";
}
// core complex conversations
start node mainIntroduction {
	do {
		#log("-- node mainIntroduction -- Introduction to caller");

		if(#getVisitCount("mainIntroduction") < 2) 
		{
			#connectSafe($phone);
			#say("mainIntroduction");
		}
		
		if($getVisitCount("mainIntroduction") >= 2)
		{
			if ($intentConfused == "yes")
			{
				#sayText("testing")
			}
					
		}

		if(#getVisitCount("mainIntroduction") > 10) 
		{		
			goto callerTimeout;
		}
	
		if(!#waitForSpeech(500)) 
		{
			wait 
			{ 
				restartself
			};
		}
		
		wait 
		{
				agree
				disagree
		};
	}
	
	transitions 
	{
		agree: goto offerAssistance on #messageHasSentiment("positive");
		disagree: goto offerAssistance on #messageHasSentiment("negative");
		
		callerTimeout: goto callerTimeout;
		confusedyes: goto mainIntroduction on #messageHasIntents("yes");
		restartself: goto mainIntroduction on true priority -1000 tags: ontick;
	}
	
	onexit 
	{
		agree: do 
		{ 
			set $feelingResponse = "positive"; 
		}
		disagree: do 
		{ 
			set $feelingResponse = "negative"; 
		}
		confusedyes: do
		{
			set $intentConfused = "yes";
		}
	}
}

node offerAssistance 
{
	do 
	{
		#log("-- node offerAssistance -- offering assistance to caller");
		
		if($feelingResponse == "positive") 
		{
			#say("howAreYouPositive");
		}
		
		if($feelingResponse == "negative") 
		{
			#say("howAreYouNegative");
		}
		
		#say("offerAssistance");
		exit;
	}
}

node respondToAssistance {
	do {
		#log("-- node respondToAssistance -- Introduction to caller");

		if(#getVisitCount("respondToAssistance") < 2) 
		{
			#connectSafe($phone);
			#say("respondToAssistance"); 
		} 

		if(#getVisitCount("respondToAssistance") > 10) 
		{		
			goto callerTimeout;
		}
	
		if(!#waitForSpeech(500)) 
		{
			wait 
			{ 
				restartself
			};
		}
		
		wait 
		{
			// see transition ideas below
		};
	}
	
	transitions 
	{
		// transfer me
		// send chris a message
		// text for me
		// i'll leave a voicemail
		// not sure (give options?)
		// confused ?
		
		callerTimeout: goto callerTimeout;
		restartself: goto mainIntroduction on true priority -1000 tags: ontick;
	}
	
	onexit 
	{

	}
}

// digressions located here
digression demandTransfer 
{
	conditions 
	{
		on #messageHasIntent("transfer");
	}
	do 
	{
		#sayText("Okay let me check if he's available.");
		wait *;
	}
	
	transitions 
	{
		agree: goto mainIntroduction on #messageHasSentiment("positive");
		disagree: goto fastHangUp on #messageHasSentiment("positive");
	}
}

// create digression for wrong number scenarios

// call wrapup
node callerTimeout 
{
	do 
	{
        #log("-- node @exit -- ending conversation");

        #say("callerTimeout");
        exit;
	}
}

node fastHangUp
{
	do
	{
		#sayText("Goodbye");
		exit;
	}
}

node @exit 
{
    do 
    {
        #log("-- node @exit -- ending conversation");
        
        exit;
    }
}

digression @exit_dig 
{
		conditions 
		{ 
			on true tags: onclosed; 
		}
		
		do 
		{
			exit;
		}
}