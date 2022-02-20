library

block introduction(sidekick: human, guest: human, reason: string): human
{	
	context
	{
		greeted: boolean = false;
	    greetedFirst: boolean = false;
	    
	    recognitions: 
	    {
	    	statement: string[];
	        request: string[];
	        question: string[];
	        other: string[];
	    } = {
	            statement: [],
	            request: [],
	            question: [],
	            other: []
        };
	}
	
	start node hello
	{
		do 
		{
			var logNodeName: string = "hello";
			#log(logNodeName + " has been initialized for reason: " + $reason);
			
			if ($reason == "busy")
			{
				#say("libIntroductionHelloUnavailable");
				exit;
			}
			
			if (#waitForSpeech(5000))
			{
				#log(logNodeName + " caller has been detected");
				#say("libIntroductionHello");
				set $greeted = true;
				wait *;
			}
			else
			{
				goto greetForce;
			}
			 
		}

		transitions
		{
			greet: goto helloRepeat on true;
			greetForce: goto helloRepeat;
		}
	}
	
	node @return
	{
		do
		{
			var logNodeName: string = "@return";
	        #log(logNodeName + " has been initialized");
	        
			return $guest;
		}
	}
	
	digression @digReturn
	{
		conditions { on true tags: onclosed; }
		do 
		{
			exit;
		}
	}
	
	node helloRepeat
	{
		do
		{
			var logNodeName: string = "helloRepeat";
	        #log(logNodeName + " has been initialized");
	        
			var sentenceType = #getSentenceType(); 

	        if (sentenceType is not null)
	        {
	            $recognitions[sentenceType]?.push(#getMessageText());
	        }
			
 			#log(logNodeName + " mood: " + $guest.mood);
			#log(logNodeName + " requested: " + $guest.request);
			#log(logNodeName + " errors: " + #stringify($guest.errors));
	        #log($recognitions);
			
			if (!$greeted) 
			{
				set $greeted = true;
				#say("libIntroductionHello");
				#say("libIntroductionHelloAssist");
			}
			
			if ($guest.mood == "idle")
			{
				#say("libIntroductionHelloAssist");
			}
			
			if ($guest.mood == "confused")
			{
				#say("libIntroductionHelloMenu");
			}

			goto listen;
		}
		
		transitions
		{
			listen: goto helloListen;
		}
	}
	
	node helloListen
	{
		do
		{
			var logNodeName: string = "helloListen";
	        #log(logNodeName + " has been initialized");

			wait *;
		}
		 
		transitions
		{
			confusion: goto helloRepeat on #messageHasAnyIntent(["questions","confusion"]) priority 5;
			farewell: goto helloFarewell on #messageHasAnyIntent(["farewell"]) priority 10;
			idle: goto helloRepeat on timeout 10000;
			listen: goto helloListen on true priority 1;
			transfer: goto helloTransfer on #messageHasAnyIntent(["transfer"]) priority 9;
		}
		
		onexit
		{	
			confusion: do 
			{
				set $guest.mood = "confused";
		        set $guest.errors += 1;
			}
			
			idle: do
			{
				set $guest.mood = "idle";
		        set $guest.errors += 1;

			}
		}
	}
	
	node helloTransfer
	{
		do
		{
			var logNodeName: string = "helloTransfer";
	        #log(logNodeName + " has been initialized");
	        
			set $guest.mood = "positive";
			set $guest.request = "transfer";
			#say("libIntroductionHelloTransfer");
			return $guest;
		}
	}
	
	node helloFarewell
	{
		do
		{
			var logNodeName: string = "helloFarewell";
	        #log(logNodeName + " has been initialized");
	        
			set $guest.mood = "positive";
			set $guest.request = "farewell";
			#say("libIntroductionHelloFarewell");
			return $guest;
		}
	}
}
	
