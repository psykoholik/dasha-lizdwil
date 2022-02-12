// Liz D. Wil
import "assistantLibrary/all.dsl";

context {
	input phone: string;
	input forward: string = "sip:+12817829187@lizdwil.pstn.twilio.com;transport=udp";
	input sprint: boolean;
	
	callMood: string = "positive";
	callStepsCur: number = 1;
	callStepsRisk: number = 5;
	callStepsIdle: number = 0;
	assistGreetFull: boolean = true;
}

start node assist {
	do
	{	
		#connect($phone);
		wait *;
	}
	
	transitions
	{
		assistGreetAttempt: goto assistGreetAttempt on timeout 300;
	}
}

node assistGreetAttempt {
	do
	{
		var logNodeName: string = "assistGreetAttempt";
		
		#log(logNodeName + " mood " + #stringify($callMood) + " Attempt(s)");
		#log(logNodeName + " steps " + #stringify($callStepsCur) + " Attempt(s)");
		#log(logNodeName + " idle" + #stringify($callStepsIdle) + " Attempt(s)");
		
		
		if ($assistGreetFull)
		{
			set $assistGreetFull = false;
			set $callStepsCur += 1;
			
			#say("assistGreetAttempt", interruptible: true, options: { emotion: "from text: i love you" });
			wait 
			{
				greetAttemptIdle
			};
		}
		else
		{	
			//repeat
			if (($callMood == "positive") || ($callMood == "negative") || ($callStepsCur == 3))
			{
				set $callStepsCur += 1;
				#say("assistGreetRepeat", interruptible: true, options: { emotion: $callMood });
				wait
				{
					greetAttemptIdle
					greetAttemptPos
					greetAttemptNeg
				};
			}
			
			//explanation
			if ($callMood == "confusion")
			{
				#say("assistGreetExplain", options: { emotion: "positive", speed: 0.7 });
			}	
		}		

		wait 
		{
			greetAttemptIdle
		};
	}
	
	transitions
	{
		greetAttemptIdle: goto assistGreetAttempt on timeout 10000;
		greetAttemptPos: goto assistGreetAttempt on #messageHasSentiment("positive");
		greetAttemptNeg: goto assistGreetAttempt on #messageHasSentiment("negative");
	}
	
	onexit {
		greetAttemptIdle: do { set $callStepsIdle += 1; }
		greetAttemptPos: do 
		{ 
			set $callMood = "positive";
		}
		greetAttemptNeg: do 
		{ 
			set $callMood = "negative"; 
		}
	}
}

node @exit 
{
    do 
    {
        #say("assistHangUp");
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