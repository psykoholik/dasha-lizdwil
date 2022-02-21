// Liz D. Wil 
import "sidekicklibrary/all.dsl";

type people = {
		primary: person;
		sidekick: person;
		incoming: person;
};

type person = {
		name: string;
		nick: string;
		discussions: discussion[];
};

type discussion = {
		agenda: string;
		result: interpretation;
};

type interpretation = {
		request: string; // examples: transfer, message, farewell, unknown
		behavior: string; // examples: positive, negative, idle, confused
		journal: sentence[]; // log for all things discussed during function/library
};

type sentence = {
		sentence: string;
		type: string;
};

context {
	input phone: string;
	input forward: string;
	input reason: string;
}

start node assist 
{
	do
	{	
		#log("call information: " + $phone + " " + $forward + " " + $reason + "with following attendees: ");
		#connectSafe($phone);

		wait *;
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
