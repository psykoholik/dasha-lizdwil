library

block hello ( discussion: interaction ): interaction
{
	context
	{
		defaultAttempts: number = 4;
	}
	
	start node main
	{
		do
		{
			var localFunctionName = "@";
			#log("[" + $discussion.name + "] - [" + localFunctionName + "] has been executed");
			
			if ($discussion.greet)
			{
				goto talk;
			}
			else
			{
				goto listen;
			}
			
			goto selfReturn;
		}
		
		transitions
		{
			selfReturn: goto @return;
			talk: goto talk;
			listen: goto listen;
		}
	}
	
	node @return
	{
		do
		{
			var localFunctionName = "@return";
			#log("[" + $discussion.name + "] - [" + localFunctionName + "] has been executed");
			
			return $discussion;
		}
	}
	
	digression @digReturn
	{
		conditions
		{
			on true tags: onclosed;
		}
		do
		{
			var localFunctionName = "@digReturn";
			#log("[" + $discussion.name + "] - [" + localFunctionName + "] has been executed");
			
			return $discussion;
		}
	}
	
	node talk
	{
		do
		{
			var localFunctionName = "talk";
			#log("[" + $discussion.name + "] - [" + localFunctionName + "] has been executed");
			#log($discussion);
			set $discussion.text = #getMessageText();

			if ($discussion.greet)
			{
				#say("hello.greet");
				set $discussion.greet = false;
				#log("[" + $discussion.name + "] - [" + localFunctionName + "] has been greeted");
			}

			if ($discussion.sentenceType != "null")
			{
				
			}

			if ($discussion.behavior == "idle")
			{
				#say("hello.idle");
				#log("[" + $discussion.name + "] - [" + localFunctionName + "] caller is idle or not understandable");
			}
			
			goto listen;
		}
		
		transitions
		{
			selfReturn: goto @return;
			listen: goto listen;
		}
	}
	
	node listen
	{
		do
		{
			var localFunctionName = "listen";
			#log("[" + $discussion.name + "] - [" + localFunctionName + "] has been executed");
			#log($discussion);
			
			wait *;
		}
		
		transitions
		{
			greeted: goto talk on #messageHasIntent("greeted");
			idle: goto talk on timeout 10000;
			listen: goto listen on true priority 1;
		}
		
		onexit
		{
			greeted: do
			{
				set $discussion.behavior = "positive";
				set $discussion.request = "greeted";
				set $discussion.sentenceType = #getSentenceType();
				
			}
			idle: do
			{
				#log("transition idle");
				
				set $discussion.behavior = "idle";
				set $discussion.request = "repeat";
			}
			
			default: do
			{
				#log("transition default");
				set $discussion.behavior = "positive";
				set $discussion.request = "repeat";
				set $discussion.sentenceType = #getSentenceType();
				set $discussion.text = #getMessageText();
			}
		}
	}
}

node action
{
	do
	{

	}

	transitions
	{

	}
}