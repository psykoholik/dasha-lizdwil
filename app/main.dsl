// Liz D. Wil 
import "sidekicklibrary/all.dsl";

type human = {
	name: string;
};

type people = {
	hosts: human;
	siekick: human;
	guests: human;
};

context {
	input phone: string;
	input forward: string;
	input reason: string;
}

start node assist {
	do
	{	
		#log("call information: " + $phone + " " + $forward + " " + $reason + "with following attendees: ");
		#connectSafe($phone);

		wait *;
	}

	transitions
	{
		idle: goto assistGreetAttempt on timeout 300;
	}
}

node @exit 
{
    do 
    {
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

node assistGreetAttempt {
	do
	{
		var logNodeName: string = "assistGreetAttempt";
		var attendees: people = {
				hosts: { name: "Chris D. Wil" }, 
				sidekick: { name: "Liz D. Wil" }],
				guest: { name: "" }
		};
		
		blockcall introduction(attendees, $reason);
		
		if ($reason != "busy")
		{	
				#forward($forward);
				exit;
		}
	}
	
	transitions
	{
		greetAttemptIdle: goto assistGreetAttempt on timeout 10000;
	}
}

