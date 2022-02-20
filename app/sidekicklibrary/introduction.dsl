library

block introduction(sidekick: human, guest: human, greetFirst: boolean): human
{	
	context
	{
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
			var logNodeName: string = "assistGreetAttempt";
			
			if ($greetFirst)
			{
				set $greetFirst = false;
				#say("libIntroductionHello");	
			}
			wait *;
			return $guest;
		}

		transitions
		{
			transfer: goto @return on #messageHasIntent("transfer");
		}
		
		onexit
		{
			default: do 
			{
				var sentenceType = #getSentenceType();
				
				if (sentenceType is not null)
				{
					set $guest.responses += 1;
					$recognitions[sentenceType]?.push(#getMessageText());
				}
				else
				{
					set $guest.errors += 1;
				}	
				
				#log($recognitions);
			}
		}
	}
	
	node @return
	{
		do
		{
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
}

/*
 
 			#log(logNodeName + " mood: " + $guest.mood);
			#log(logNodeName + " requested: " + $guest.request);
			#log(logNodeName + " responses: " + #stringify($guest.responses));			
			#log(logNodeName + " errors: " + #stringify($guest.errors));
			#log($recognitions);
 
	node helloMenu
	{
		do
		{
			#say("libIntroductionHelloMenu");
			wait *;
		}
		
		transitions
		{
			confirmedYes: goto hello on #messageHasIntent("yes");

			confusion: goto helloMenu on #messageHasAnyIntent(["questions","confusion"]);
			idle: goto hello on timeout 10000;
			sentinmentYes: goto hello on #messageHasSentiment("positive");

			transfer: goto @return on #messageHasIntent("transfer");
		}

		onexit 
		{
			confusion: do 
			{ 
				set $guest.mood = "confusion"; 
				set $guest.responses += 1;
			}
			idle: do 
			{ 
				set $guest.mood = "idle"; 
				set $guest.errors += 1;
			}
		}
	}
*/
	
