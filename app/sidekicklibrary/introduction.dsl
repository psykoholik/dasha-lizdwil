library

block introduction(me: human, them: human, greetFirst: boolean): human
{
	start node hello
	{
		do 
		{
			if ($greetFirst)
			{
				#waitForSpeech(1000);
				#say("libIntroductionHello", {name: $me.phonetic});
				wait *;				
			}
			else
			{
				wait *;
			}
			return $them;
		}

		transitions
		{
			idle: goto hello on timeout 10000;
			confusion: goto helloConfused on #messageHasAnyIntent(["questions","confusion"]);
		}

		onexit 
		{
			idle: do { set $them.mood = "silent"; }
			confusion: do { set $them.mood = "confusion"; }
		}
	}

	node @return 
	{
		do { return $them; }
	}
			
	node helloConfused
	{
		do
		{
			#say("libIntroductionHelloConfusion");
			wait *;
		}

		transitions
		{
			idle: goto @return on timeout 10000;
			confusion: goto helloMenu on #messageHasAnyIntent(["questions","confusion"]);
		}

		onexit
		{
			idle: do { set $them.mood = "silent"; }
			confusion: do { set $them.mood = "confusion"; }
		}
	}
	
	node helloMenu
	{
		do
		{
			#say("libIntroductionHelloMenu");
			wait *;
		}
	}
	
	
	digression @digReturn
	{
		conditions { on true tags: onclosed; }
		do { exit; }
	}
	
}