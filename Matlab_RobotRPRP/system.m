function [ret,x0,str,ts,xts]=system(t,x,u,flag);
%SYSTEM	is the M-file description of the SIMULINK system named SYSTEM.
%	The block-diagram can be displayed by typing: SYSTEM.
%
%	SYS=SYSTEM(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes SYSTEM to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling SYSTEM with a FLAG of zero:
%	[SIZES]=SYSTEM([],[],[],0),  returns a vector, SIZES, which
%	contains the sizes of the state vector and other parameters.
%		SIZES(1) number of states
%		SIZES(2) number of discrete states
%		SIZES(3) number of outputs
%		SIZES(4) number of inputs
%		SIZES(5) number of roots (currently unsupported)
%		SIZES(6) direct feedthrough flag
%		SIZES(7) number of sample times
%
%	For the definition of other parameters in SIZES, see SFUNC.
%	See also, TRIM, LINMOD, LINSIM, EULER, RK23, RK45, ADAMS, GEAR.

% Note: This M-file is only used for saving graphical information;
%       after the model is loaded into memory an internal model
%       representation is used.

% the system will take on the name of this mfile:
sys = mfilename;
new_system(sys)
simver(1.3)
if (0 == (nargin + nargout))
     set_param(sys,'Location',[113,80,618,458])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '5')
set_param(sys,'Min step size', '0.01')
set_param(sys,'Max step size', '0.01')
set_param(sys,'Relative error','1e-3')
set_param(sys,'Return vars',   '')

add_block('built-in/From Workspace',[sys,'/',['Riferimenti',13,'(LSPB)']])
set_param([sys,'/',['Riferimenti',13,'(LSPB)']],...
		'Font Name','MS LineDraw',...
		'Font Size',12,...
		'matl_expr','[td,q_des]',...
		'position',[20,100,105,130])


%     Subsystem  ['',13,'Controllore',13,'(FL o PD)'].

new_system([sys,'/',['',13,'Controllore',13,'(FL o PD)']])
set_param([sys,'/',['',13,'Controllore',13,'(FL o PD)']],'Location',[43,45,548,456])

add_block('built-in/Inport',[sys,'/',['',13,'Controllore',13,'(FL o PD)/Riferimenti']])
set_param([sys,'/',['',13,'Controllore',13,'(FL o PD)/Riferimenti']],...
		'Font Name','MS LineDraw',...
		'Font Size',12,...
		'position',[40,95,60,115])

add_block('built-in/Inport',[sys,'/',['',13,'Controllore',13,'(FL o PD)/',13,'Uscite',13,'reazionate',13,'']])
set_param([sys,'/',['',13,'Controllore',13,'(FL o PD)/',13,'Uscite',13,'reazionate',13,'']],...
		'Font Name','MS LineDraw',...
		'Font Size',12,...
		'Port','2',...
		'position',[40,275,60,295])

add_block('built-in/MATLAB Fcn',[sys,'/',['',13,'Controllore',13,'(FL o PD)/Controllo',13,'del Robot']])
set_param([sys,'/',['',13,'Controllore',13,'(FL o PD)/Controllo',13,'del Robot']],...
		'Font Name','MS LineDraw',...
		'Font Size',12,...
		'MATLAB Fcn','control',...
		'Output Width','4',...
		'position',[290,174,365,216])

add_block('built-in/Outport',[sys,'/',['',13,'Controllore',13,'(FL o PD)/Coppie degli ',13,'Attuatori']])
set_param([sys,'/',['',13,'Controllore',13,'(FL o PD)/Coppie degli ',13,'Attuatori']],...
		'Font Name','MS LineDraw',...
		'Font Size',12,...
		'position',[440,185,460,205])

add_block('built-in/Mux',[sys,'/',['',13,'Controllore',13,'(FL o PD)/Mux1']])
set_param([sys,'/',['',13,'Controllore',13,'(FL o PD)/Mux1']],...
		'Font Name','MS LineDraw',...
		'Font Size',12,...
		'inputs','24',...
		'position',[195,2,240,383])

add_block('built-in/Demux',[sys,'/',['',13,'Controllore',13,'(FL o PD)/Demux2',13,'']])
set_param([sys,'/',['',13,'Controllore',13,'(FL o PD)/Demux2',13,'']],...
		'Font Name','MS LineDraw',...
		'Font Size',12,...
		'outputs','12',...
		'position',[105,195,145,370])

add_block('built-in/Demux',[sys,'/',['',13,'Controllore',13,'(FL o PD)/Demux1']])
set_param([sys,'/',['',13,'Controllore',13,'(FL o PD)/Demux1']],...
		'Font Name','MS LineDraw',...
		'Font Size',12,...
		'outputs','12',...
		'position',[105,16,145,189])
add_line([sys,'/',['',13,'Controllore',13,'(FL o PD)']],[370,195;435,195])
add_line([sys,'/',['',13,'Controllore',13,'(FL o PD)']],[65,105;100,105])
add_line([sys,'/',['',13,'Controllore',13,'(FL o PD)']],[65,285;100,285])
add_line([sys,'/',['',13,'Controllore',13,'(FL o PD)']],[150,20;190,20])
add_line([sys,'/',['',13,'Controllore',13,'(FL o PD)']],[150,35;190,35])
add_line([sys,'/',['',13,'Controllore',13,'(FL o PD)']],[150,50;190,50])
add_line([sys,'/',['',13,'Controllore',13,'(FL o PD)']],[150,65;190,65])
add_line([sys,'/',['',13,'Controllore',13,'(FL o PD)']],[150,80;190,80])
add_line([sys,'/',['',13,'Controllore',13,'(FL o PD)']],[150,95;190,95])
add_line([sys,'/',['',13,'Controllore',13,'(FL o PD)']],[245,195;285,195])
add_line([sys,'/',['',13,'Controllore',13,'(FL o PD)']],[150,110;190,110])
add_line([sys,'/',['',13,'Controllore',13,'(FL o PD)']],[150,125;190,125])
add_line([sys,'/',['',13,'Controllore',13,'(FL o PD)']],[150,140;190,140])
add_line([sys,'/',['',13,'Controllore',13,'(FL o PD)']],[150,155;190,155])
add_line([sys,'/',['',13,'Controllore',13,'(FL o PD)']],[150,170;190,170])
add_line([sys,'/',['',13,'Controllore',13,'(FL o PD)']],[150,185;190,185])
add_line([sys,'/',['',13,'Controllore',13,'(FL o PD)']],[150,200;190,200])
add_line([sys,'/',['',13,'Controllore',13,'(FL o PD)']],[150,215;190,215])
add_line([sys,'/',['',13,'Controllore',13,'(FL o PD)']],[150,230;190,230])
add_line([sys,'/',['',13,'Controllore',13,'(FL o PD)']],[150,245;190,245])
add_line([sys,'/',['',13,'Controllore',13,'(FL o PD)']],[150,260;190,260])
add_line([sys,'/',['',13,'Controllore',13,'(FL o PD)']],[150,275;190,275])
add_line([sys,'/',['',13,'Controllore',13,'(FL o PD)']],[150,290;190,290])
add_line([sys,'/',['',13,'Controllore',13,'(FL o PD)']],[150,305;190,305])
add_line([sys,'/',['',13,'Controllore',13,'(FL o PD)']],[150,320;190,320])
add_line([sys,'/',['',13,'Controllore',13,'(FL o PD)']],[150,335;190,335])
add_line([sys,'/',['',13,'Controllore',13,'(FL o PD)']],[150,350;190,350])
add_line([sys,'/',['',13,'Controllore',13,'(FL o PD)']],[150,365;190,365])


%     Finished composite block ['',13,'Controllore',13,'(FL o PD)'].

set_param([sys,'/',['',13,'Controllore',13,'(FL o PD)']],...
		'Font Name','MS LineDraw',...
		'Font Size',12,...
		'position',[180,98,215,167])

add_block('built-in/To Workspace',[sys,'/',['',13,'Uscite',13,'(pos,vel,acc)']])
set_param([sys,'/',['',13,'Uscite',13,'(pos,vel,acc)']],...
		'Font Name','MS LineDraw',...
		'Font Size',12,...
		'mat-name','q',...
		'position',[455,127,505,143])

add_block('built-in/To Workspace',[sys,'/','Coppie'])
set_param([sys,'/','Coppie'],...
		'Font Name','MS LineDraw',...
		'Font Size',12,...
		'mat-name','tau',...
		'position',[455,37,505,53])


%     Subsystem  ['Robot',13,'(RPRP)'].

new_system([sys,'/',['Robot',13,'(RPRP)']])
set_param([sys,'/',['Robot',13,'(RPRP)']],'Location',[30,49,589,452])

add_block('built-in/Integrator',[sys,'/',['Robot',13,'(RPRP)/v1']])
set_param([sys,'/',['Robot',13,'(RPRP)/v1']],...
		'orientation',2,...
		'Font Name','MS LineDraw',...
		'Font Size',12,...
		'Initial','v1_start',...
		'position',[285,25,305,45])

add_block('built-in/Integrator',[sys,'/',['Robot',13,'(RPRP)/q1']])
set_param([sys,'/',['Robot',13,'(RPRP)/q1']],...
		'orientation',2,...
		'Font Name','MS LineDraw',...
		'Font Size',12,...
		'Initial','q1_start',...
		'position',[225,25,245,45])

add_block('built-in/Mux',[sys,'/',['Robot',13,'(RPRP)/Mux1']])
set_param([sys,'/',['Robot',13,'(RPRP)/Mux1']],...
		'Font Name','MS LineDraw',...
		'Font Size',12,...
		'inputs','12',...
		'position',[465,39,490,216])

add_block('built-in/Integrator',[sys,'/',['Robot',13,'(RPRP)/q2']])
set_param([sys,'/',['Robot',13,'(RPRP)/q2']],...
		'orientation',2,...
		'Font Name','MS LineDraw',...
		'Font Size',12,...
		'Initial','q2_start',...
		'position',[225,75,245,95])

add_block('built-in/Integrator',[sys,'/',['Robot',13,'(RPRP)/v2']])
set_param([sys,'/',['Robot',13,'(RPRP)/v2']],...
		'orientation',2,...
		'Font Name','MS LineDraw',...
		'Font Size',12,...
		'Initial','v2_start',...
		'position',[290,75,310,95])

add_block('built-in/Demux',[sys,'/',['Robot',13,'(RPRP)/Demux2']])
set_param([sys,'/',['Robot',13,'(RPRP)/Demux2']],...
		'Font Name','MS LineDraw',...
		'Font Size',12,...
		'position',[360,154,400,221])

add_block('built-in/Mux',[sys,'/',['Robot',13,'(RPRP)/Mux']])
set_param([sys,'/',['Robot',13,'(RPRP)/Mux']],...
		'Font Name','MS LineDraw',...
		'Font Size',12,...
		'inputs','12',...
		'position',[160,105,185,270])

add_block('built-in/Inport',[sys,'/',['Robot',13,'(RPRP)/in']])
set_param([sys,'/',['Robot',13,'(RPRP)/in']],...
		'Font Name','MS LineDraw',...
		'Font Size',12,...
		'position',[10,120,30,140])

add_block('built-in/Demux',[sys,'/',['Robot',13,'(RPRP)/Demux1']])
set_param([sys,'/',['Robot',13,'(RPRP)/Demux1']],...
		'Font Name','MS LineDraw',...
		'Font Size',12,...
		'position',[50,99,85,156])

add_block('built-in/Integrator',[sys,'/',['Robot',13,'(RPRP)/q3']])
set_param([sys,'/',['Robot',13,'(RPRP)/q3']],...
		'orientation',2,...
		'Font Name','MS LineDraw',...
		'Font Size',12,...
		'Initial','q3_start',...
		'position',[230,285,250,305])

add_block('built-in/Integrator',[sys,'/',['Robot',13,'(RPRP)/v3']])
set_param([sys,'/',['Robot',13,'(RPRP)/v3']],...
		'orientation',2,...
		'Font Name','MS LineDraw',...
		'Font Size',12,...
		'Initial','v3_start',...
		'position',[290,285,310,305])

add_block('built-in/Integrator',[sys,'/',['Robot',13,'(RPRP)/q4']])
set_param([sys,'/',['Robot',13,'(RPRP)/q4']],...
		'orientation',2,...
		'Font Name','MS LineDraw',...
		'Font Size',12,...
		'Initial','q4_start',...
		'position',[230,345,250,365])

add_block('built-in/Integrator',[sys,'/',['Robot',13,'(RPRP)/v4']])
set_param([sys,'/',['Robot',13,'(RPRP)/v4']],...
		'orientation',2,...
		'Font Name','MS LineDraw',...
		'Font Size',12,...
		'Initial','v4_start',...
		'position',[290,345,310,365])

add_block('built-in/Outport',[sys,'/',['Robot',13,'(RPRP)/out']])
set_param([sys,'/',['Robot',13,'(RPRP)/out']],...
		'Font Name','MS LineDraw',...
		'Font Size',12,...
		'position',[530,120,550,140])

add_block('built-in/MATLAB Fcn',[sys,'/',['Robot',13,'(RPRP)/Robot RPRP']])
set_param([sys,'/',['Robot',13,'(RPRP)/Robot RPRP']],...
		'Font Name','MS LineDraw',...
		'Font Size',12,...
		'MATLAB Fcn','robot',...
		'Output Width','4',...
		'position',[225,167,315,213])
add_line([sys,'/',['Robot',13,'(RPRP)']],[320,190;355,190])
add_line([sys,'/',['Robot',13,'(RPRP)']],[190,190;220,190])
add_line([sys,'/',['Robot',13,'(RPRP)']],[280,35;250,35])
add_line([sys,'/',['Robot',13,'(RPRP)']],[285,85;250,85])
add_line([sys,'/',['Robot',13,'(RPRP)']],[220,35;220,10;450,10;460,45])
add_line([sys,'/',['Robot',13,'(RPRP)']],[495,130;525,130])
add_line([sys,'/',['Robot',13,'(RPRP)']],[90,120;155,120])
add_line([sys,'/',['Robot',13,'(RPRP)']],[90,105;155,105])
add_line([sys,'/',['Robot',13,'(RPRP)']],[35,130;45,130])
add_line([sys,'/',['Robot',13,'(RPRP)']],[405,165;500,165;500,35;310,35])
add_line([sys,'/',['Robot',13,'(RPRP)']],[405,180;515,180;515,85;315,85])
add_line([sys,'/',['Robot',13,'(RPRP)']],[220,85;210,85;210,60;460,60])
add_line([sys,'/',['Robot',13,'(RPRP)']],[285,85;285,70;105,70;105,240;155,240])
add_line([sys,'/',['Robot',13,'(RPRP)']],[280,35;270,35;270,50;135,50;135,225;155,225])
add_line([sys,'/',['Robot',13,'(RPRP)']],[220,35;115,35;115,165;155,165])
add_line([sys,'/',['Robot',13,'(RPRP)']],[220,85;110,85;110,180;155,180])
add_line([sys,'/',['Robot',13,'(RPRP)']],[285,295;255,295])
add_line([sys,'/',['Robot',13,'(RPRP)']],[285,355;255,355])
add_line([sys,'/',['Robot',13,'(RPRP)']],[90,135;155,135])
add_line([sys,'/',['Robot',13,'(RPRP)']],[90,150;155,150])
add_line([sys,'/',['Robot',13,'(RPRP)']],[225,295;110,295;110,195;155,195])
add_line([sys,'/',['Robot',13,'(RPRP)']],[225,355;115,355;115,210;155,210])
add_line([sys,'/',['Robot',13,'(RPRP)']],[285,295;285,320;85,320;85,255;155,255])
add_line([sys,'/',['Robot',13,'(RPRP)']],[285,355;275,375;140,375;140,270;155,270])
add_line([sys,'/',['Robot',13,'(RPRP)']],[405,180;460,180])
add_line([sys,'/',['Robot',13,'(RPRP)']],[405,165;460,165])
add_line([sys,'/',['Robot',13,'(RPRP)']],[285,85;285,120;460,120])
add_line([sys,'/',['Robot',13,'(RPRP)']],[280,35;270,35;270,15;425,15;425,105;460,105])
add_line([sys,'/',['Robot',13,'(RPRP)']],[405,195;425,195;425,295;315,295])
add_line([sys,'/',['Robot',13,'(RPRP)']],[405,210;435,210;435,355;315,355])
add_line([sys,'/',['Robot',13,'(RPRP)']],[405,195;460,195])
add_line([sys,'/',['Robot',13,'(RPRP)']],[405,210;460,210])
add_line([sys,'/',['Robot',13,'(RPRP)']],[285,355;285,390;450,390;460,150])
add_line([sys,'/',['Robot',13,'(RPRP)']],[225,355;215,355;215,105;400,105;400,90;460,90])
add_line([sys,'/',['Robot',13,'(RPRP)']],[225,295;205,295;205,110;390,110;390,75;460,75])
add_line([sys,'/',['Robot',13,'(RPRP)']],[285,295;275,295;275,275;200,275;200,135;460,135])


%     Finished composite block ['Robot',13,'(RPRP)'].

set_param([sys,'/',['Robot',13,'(RPRP)']],...
		'Font Name','MS LineDraw',...
		'Font Size',12,...
		'position',[305,90,335,180])

add_block('built-in/To Workspace',[sys,'/','Tempo'])
set_param([sys,'/','Tempo'],...
		'Font Name','MS LineDraw',...
		'Font Size',12,...
		'mat-name','t',...
		'position',[350,302,400,318])

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'Font Name','MS LineDraw',...
		'Font Size',12,...
		'position',[115,300,135,320])

add_block('built-in/Memory',[sys,'/','Memory'])
set_param([sys,'/','Memory'],...
		'orientation',2,...
		'Font Name','Arial',...
		'Font Size',8,...
		'position',[225,230,265,260])
add_line(sys,[140,310;345,310])
add_line(sys,[340,135;450,135])
add_line(sys,[110,115;175,115])
add_line(sys,[220,135;300,135])
add_line(sys,[220,135;235,135;235,45;450,45])
add_line(sys,[340,135;380,135;380,245;270,245])
add_line(sys,[220,245;125,245;125,150;175,150])

drawnow

% Return any arguments.
if (nargin | nargout)
	% Must use feval here to access system in memory
	if (nargin > 3)
		if (flag == 0)
			eval(['[ret,x0,str,ts,xts]=',sys,'(t,x,u,flag);'])
		else
			eval(['ret =', sys,'(t,x,u,flag);'])
		end
	else
		[ret,x0,str,ts,xts] = feval(sys);
	end
else
	drawnow % Flash up the model and execute load callback
end
