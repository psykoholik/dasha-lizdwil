// Liz D. Wil 
//import "sidekicklibrary/all.dsl";

type interpretation = {
		request: string; // examples: transfer, message, farewell, unknown
		behavior: string; // examples: positive, negative, idle, confused
		journal: string[];
};

type discussion = {
		agenda: string;
		result: interpretation;
};

type person = {
		name: string;
		nick: string;
		discussions: discussion[];
};

type people = {
		primary: person;
};

context {
	input phone: string;
	input forward: string;
	input reason: string;
	
	attendees: people = {
			primary: {
				name: "Chris D. Wil",
				nick: "Chris",
				discussions: [
				              {agenda: "", result: { request: "", behavior: "", journal: []}}
				]
			}
	};
}

start node assist 
{
	do
	{	
		#log("call information: " + $phone + " " + $forward + " " + $reason + "with following attendees: ");
		#connectSafe($phone);

		exit;
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
