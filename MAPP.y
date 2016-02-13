%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *str);
void storeResistor(char *str);
void storeCapacitor(char *str);
void storeInductor(char *str);
void storeVoltage(char *str);
void storeCurrent(char *str);
void storeSinVoltage(char *str);
void storeAnalysisInfo(char *str);
int checkNodeExist(char *node);
int yylex();
void yyerror(const char *s);
extern FILE * yyin;
struct res
{
	char *name;
	char *value;
	char *nodes[2];
};
struct cap
{
	char *name;
	char *value;
	char *nodes[2];
};
struct in
{
	char *name;
	char *value;
	char *nodes[2];
};
struct voltageSource
{
	char *name;
	char *DCvalue;
	char *ACvalue;
	char *nodes[2];
};
struct currentSource
{
	char *name;
	char *DCvalue;
	char *ACvalue;
	char *nodes[2];
};
struct voltageSourceSin
{
	char *name;
	char *freq;
	char *DC;
	char *amplitude;
	char *td;
	char *damp;
	char *nodes[2];
};
struct tranAnalysis
{
	char *step;
	char *tStop;
	char *delay;
	char *maxStep;
};
struct res totalResistors[100];
struct cap totalCapacitors[100];
struct in totalInductors[100];
struct voltageSource totalVSource[100];
struct currentSource totalISource[100];
struct voltageSourceSin totalVSourceSin[100];
struct tranAnalysis plot;
char *totalNodes[100];
int nodeIndex = 0;
int numResistors = 0;
int numCapacitors = 0;
int numInductors = 0;
int numVoltage = 0;
int numCurrent = 0;
int numSinVoltage = 0;
int plotFlag = 0;
%}

%union
{
    int intValue;
    int length;
    char *stringValue;
}
%token RESISTOR CAPACITOR INDUCTOR VSOURCE ISOURCE NODE VALUE VSOURCESIN TRAN PLOTTRAN
%type <stringValue> RESISTOR 
%type <stringValue> CAPACITOR 
%type <stringValue> INDUCTOR 
%type <stringValue> VSOURCE 
%type <stringValue> ISOURCE 
%type <stringValue> NODE 
%type <stringValue> VALUE
%type <stringValue> VSOURCESIN 
%type <stringValue> TRAN
%type <stringValue> PLOTTRAN

%%
commands: R
		|
		L
		|
		C
		|
		V
		|
		I
		|
		VSIN
		|
		TANALYSIS
		|
		PLOT
		|
		commands R
		|
		commands L
		|
		commands C
		|
		commands V
		|
		commands I
		|
		commands VSIN
		|
		commands TANALYSIS
		|
		commands PLOT
;

R: RESISTOR {storeResistor($1);}
;
L: INDUCTOR {storeInductor($1);}
;
C: CAPACITOR {storeCapacitor($1);}
;
V: VSOURCE {storeVoltage($1);}
;
I: ISOURCE {storeCurrent($1);}
;
VSIN: VSOURCESIN {storeSinVoltage($1);} 
;
TANALYSIS: TRAN {storeAnalysisInfo($1);}
;
PLOT: PLOTTRAN {plotFlag = 1;}
;
%%
void yyerror(const char *str)
{
        fprintf(stderr,"error: %s\n",str);
}
void storeAnalysisInfo(char *str)
{
	void *token;
	//Contains .TRAN
	token = strtok(str, " ");
	//Contains step interval
	plot.step = strtok(NULL, " ");
	//Contains stop time
	plot.tStop = strtok(NULL, " ");
	//Contains delay
	plot.delay = strtok(NULL, " ");
	//Contains Max step size
	plot.maxStep = strtok(NULL, " ");
}
void storeSinVoltage(char *str)
{
	int i = 0;
	void *token;
	token = strtok(str, " ()");
	while(token)
	{
		switch(i)
		{
			case 0:
				totalVSourceSin[i].name = token;
				break;
			case 1: 
			case 2:
				totalVSourceSin[numSinVoltage].nodes[i-1] = token;
				if(!checkNodeExist(totalVSourceSin[numSinVoltage].nodes[i-1]))
				{
					totalNodes[nodeIndex] = totalVSourceSin[numSinVoltage].nodes[i-1];
					nodeIndex++;
				}
				break;
			case 3:
				break;
			case 4:
				totalVSourceSin[numSinVoltage].DC = token;									
				break;
			case 5:
				totalVSourceSin[numSinVoltage].amplitude = token;
				printf("AMPLITUDE: %s \n", (char *)token);
				break;
			case 6:
				totalVSourceSin[numSinVoltage].freq = token;
				printf("FREQ: %s \n", (char *)token);
				break;
			case 7:
				totalVSourceSin[numSinVoltage].td = token;
				printf("TD: %s \n", (char *)token);
				break;
			case 8:
				totalVSourceSin[numSinVoltage].damp = token;
				printf("DAMP: %s \n", (char *)token);
				break;
		}
		i++;
		token = strtok(NULL, " ()");
	}
	numSinVoltage++;
}
void storeVoltage(char *str)
{
	int i = 0;
	void *token;
	token = strtok(str, " ");
	while(token)
	{
		switch(i)
		{
			case 0:
				totalVSource[numVoltage].name = token;
				break;
			case 1:
			case 2:
				totalVSource[numVoltage].nodes[i-1] = token;
				if(!checkNodeExist(totalVSource[numVoltage].nodes[i-1]))
				{
					totalNodes[nodeIndex] = totalVSource[numVoltage].nodes[i-1];
					nodeIndex++;
				}
				break;
			case 3:
			case 5:
				if(strcmp(token,"DC")==0)
				{
					token = strtok(NULL, " ");
					totalVSource[numVoltage].DCvalue = token;
					i++;
				}
				else if(strcmp(token,"AC")==0)
				{
					token = strtok(NULL, " ");
					totalVSource[numVoltage].ACvalue = token;
					i++;
				}
				break;
		}
		i++;
		token = strtok(NULL, " ");
		
	}	
	numVoltage++;
}
void storeCurrent(char *str)
{
	int i = 0;
	void *token;
	token = strtok(str, " ");
	
	while(token)
	{
		switch(i)
		{
			case 0:
				totalISource[numCurrent].name = token;
				break;
			case 1:
			case 2:
				totalISource[numCurrent].nodes[i-1] = token;
				if(!checkNodeExist(totalISource[numCurrent].nodes[i-1]))
				{
					totalNodes[nodeIndex] = totalISource[numCurrent].nodes[i-1];
					nodeIndex++;
				}
				break;
			case 3:
			case 5:
				if(strcmp(token,"DC")==0)
				{
					token = strtok(NULL, " ");
					totalISource[numCurrent].DCvalue = token;
					i++;
				}
				else if(strcmp(token,"AC")==0)
				{
					token = strtok(NULL, " ");
					totalISource[numCurrent].ACvalue = token;
					i++;
				}
				break;
		}
		i++;
		token = strtok(NULL, " ");		
	}	
	numCurrent++;
}
void storeResistor(char *str)
{
	int i = 0;
	void *token;
	token = strtok(str, " ");
	
	while(token)
	{
		switch(i)
		{
			case 0:
				totalResistors[numResistors].name = token;
				break;
			case 1:
			case 2:
				totalResistors[numResistors].nodes[i-1] = token;
				if(!checkNodeExist(totalResistors[numResistors].nodes[i-1]))
				{
					totalNodes[nodeIndex] = totalResistors[numResistors].nodes[i-1];
					nodeIndex++;
				}
				break;
			case 3:
				totalResistors[numResistors].value = token;
				break;
		}
		i++;
		token = strtok(NULL, " ");		
	}	
	numResistors++;

}
void storeCapacitor(char *str)
{
	
	int i = 0;
	void *token;
	token = strtok(str, " ");
	
	while(token)
	{
		switch(i)
		{
			case 0:
				totalCapacitors[numCapacitors].name = token;
				break;
			case 1:
			case 2:
				totalCapacitors[numCapacitors].nodes[i-1] = token;
				if(!checkNodeExist(totalCapacitors[numCapacitors].nodes[i-1]))
				{
					totalNodes[nodeIndex] = totalCapacitors[numCapacitors].nodes[i-1];
					nodeIndex++;
				}
				break;
			case 3:
				totalCapacitors[numCapacitors].value = token;
				break;
		}
		i++;
		token = strtok(NULL, " ");		
	}	
	numCapacitors++;
}
void storeInductor(char *str)
{
	int i = 0;
	void *token;
	token = strtok(str, " ");
	
	while(token)
	{
		switch(i)
		{
			case 0:
				totalInductors[numInductors].name = token;
				break;
			case 1:
			case 2:
				totalInductors[numInductors].nodes[i-1] = token;
				if(!checkNodeExist(totalInductors[numInductors].nodes[i-1]))
				{
					totalNodes[nodeIndex] = totalInductors[numInductors].nodes[i-1];
					nodeIndex++;
				}				
				break;
			case 3:
				totalInductors[numInductors].value = token;
				break;
		}
		i++;
		token = strtok(NULL, " ");		
	}	
	numInductors++;
}
int checkNodeExist(char *node)
{
	int result = 0;
	int i  = 0;
	for(i=0;i<nodeIndex;i++)
	{
		if(strcmp(node,totalNodes[i])==0)
			result = 1;
	}
	return result;
}
void printElements(void *file)
{
	int i = 0;
	for(i=0;i<numResistors;i++)
		fprintf(file, "cktnetlist = add_element(cktnetlist, resModSpec(), '%s', {'%s','%s'}, {{'R',%s}});\n", totalResistors[i].name,totalResistors[i].nodes[0],totalResistors[i].nodes[1],totalResistors[i].value);
	for(i=0;i<numCapacitors;i++)
		fprintf(file, "cktnetlist = add_element(cktnetlist, capModSpec(), '%s', {'%s','%s'}, %s);\n", totalCapacitors[i].name,totalCapacitors[i].nodes[0],totalCapacitors[i].nodes[1],totalCapacitors[i].value);
	for(i=0;i<numInductors;i++)
		fprintf(file, "cktnetlist = add_element(cktnetlist, indModSpec(), '%s', {'%s','%s'}, %s);\n", totalInductors[i].name,totalInductors[i].nodes[0],totalInductors[i].nodes[1],totalInductors[i].value);

}
void printSources(void *file)
{
	int i = 0;
	for(i=0;i<numVoltage;i++)
	{
		fprintf(file, "cktnetlist = add_element(cktnetlist, vsrcModSpec, '%s', {'%s','%s'}, {},", totalVSource[i].name,totalVSource[i].nodes[0],totalVSource[i].nodes[1]);
		if(totalVSource[i].ACvalue)
		{
			if(totalVSource[i].DCvalue)
				fprintf(file, " {{'AC', %s},{'DC', %s}});\n",totalVSource[i].ACvalue,totalVSource[i].DCvalue);
			else
				fprintf(file, " {{'AC', %s}});\n",totalVSource[i].ACvalue);
		}
		else  if(totalVSource[i].DCvalue)
			fprintf(file, " {{'DC', %s}});\n",totalVSource[i].DCvalue);
		
	}
	for(i=0;i<numCurrent;i++)
	{
		fprintf(file, "cktnetlist = add_element(cktnetlist, isrcModSpec, '%s', {'%s','%s'}, {},{{", totalISource[i].name,totalISource[i].nodes[0],totalISource[i].nodes[1]);
		if(totalISource[i].ACvalue)
		{
			if(totalISource[i].DCvalue)
				fprintf(file, " {{'AC', %s},{'DC', %s}});\n",totalISource[i].ACvalue,totalISource[i].DCvalue);
			else
				fprintf(file, " {{'AC', %s}});\n",totalISource[i].ACvalue);
		}
		else  if(totalISource[i].DCvalue)
			fprintf(file, " {{'DC', %s}});\n",totalISource[i].DCvalue);
	}
	for(i=0;i<numSinVoltage;i++)
	{
		//Creates function
		fprintf(file, "tranfunc = @(t, args) args.A*sin(2*pi*args.f*t + args.phi);\n");	
		//Creates variables for function	
		fprintf(file, "tranargs.A = %s; tranargs.f = %s; tranargs.phi = %s;\n", totalVSourceSin[i].amplitude, totalVSourceSin[i].freq, totalVSourceSin[i].td);
		fprintf(file, "cktnetlist = add_element(cktnetlist, vsrcModSpec, '%s', {'%s', '%s'}, {},", totalVSourceSin[i].name, totalVSourceSin[i].nodes[0], totalVSourceSin[i].nodes[1]);
		fprintf(file, "{{'E' {'DC',%s} {'TRAN',tranfunc,tranargs}}});\n", totalVSourceSin[i].DC);
	}
		
}

void createckt(void *file)
{
	fprintf(file, "cktnetlist.cktname = 'ckt';\n");
}

void prepareTran(void *file)
{
	 fprintf(file, "DAE = MNA_EqnEngine(cktnetlist);\n");
	 //calculate DC operating point
	 fprintf(file, "dcop = dot_op(DAE);");
	 fprintf(file, "feval(dcop.print, dcop);\n");
	 fprintf(file, "xinit = zeros(feval(DAE.nunks, DAE), 1);\n");
	 fprintf(file, "tstart = %s; tstep = %s; tstop = %s;  \n", plot.delay, plot.step, plot.tStop);
	 fprintf(file, "TRANobj = dot_transient(DAE, xinit, tstart, tstep, tstop);\n");
	 if(plotFlag)
	 	fprintf(file, "feval(TRANobj.plot, TRANobj);\n");     
}

void declareNodes(void *file)
{
	int i = 0;
	int ground = 0;
	char *gnd = "gnd";
	fprintf(file, "cktnetlist.nodenames = {'%s'",totalNodes[0]);
	for(i=1;i<nodeIndex;i++)
	{
		if(strcmp(totalNodes[i],gnd) == 0)
			ground = 1;
		else
			fprintf(file, ",'%s'",totalNodes[i]);
	}
	fprintf(file,"};\n");
	if(ground)
		fprintf(file,"cktnetlist.groundnodename = 'gnd';\n");
}

int main(int argc, char *argv[])
{
	if (argc>0)
        yyin = fopen(argv[1], "r");
    else
    	yyin = stdin;    

    yylex();
	FILE *fptr;
	fptr = fopen("Generated.m", "w");

	yyparse();
	createckt(fptr);
	declareNodes(fptr);
	printSources(fptr);
	printElements(fptr);
	prepareTran(fptr);
	fclose(fptr);
	return 1;
}
