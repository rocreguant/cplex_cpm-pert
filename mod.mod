/*********************************************
 * OPL 12.2 Model
 * Author: roc.reguant
 * Creation Date: 30/11/2012 at 11:26:33
 *********************************************/



 	{string} Tasks = ...;
 	int NumTasks  = card(Tasks);
 	range totalTasks = 1..NumTasks;
 	float CostTask[Tasks] = ...;
 	float InitialTime[Tasks] = ...;
 	float WaitingCost[Tasks] = ...;
 
 	
	tuple arc {
	   string from;
	   string too;
	}
 	
 	{arc} Prerequisite = ...;

	
	dvar float+ PartialTime[Tasks] in totalTasks;
	dvar float+ WaitingTime[Tasks];
	dexpr float TotalTime = sum(i in Tasks) WaitingCost[i]*(WaitingTime[i]);

	minimize TotalTime; 
	
	subject to {	
		
		forall (t in Tasks){
			InitialTime[t] + CostTask[t] - PartialTime[t] >= WaitingTime[t];
			WaitingTime[t] <= 0;
			PartialTime[t] >= CostTask[t];
		}
				
		forall (p in Prerequisite) {
		  	PartialTime[p.too] >= PartialTime[p.from] + CostTask[p.too];
		}

	}		

	execute{
		write("\nThe minimum waste of money of this project is ", TotalTime*(-1), "€ \n");
		
		write("\n\nThe nodes with money waste are: \n");
		for(var t in Tasks){
		  if(WaitingTime[t]<0)write(t, " amb ", WaitingTime[t]*WaitingCost[t]*(-1), "€\n");
		}
			  
		write("\nThe recomended initial time for each Task: \nTask -> Initial time recomended\n");
		for(var t in Tasks){
		  write(t, " -> ", PartialTime[t] - CostTask[t], "\n");
		}
 
	}
		