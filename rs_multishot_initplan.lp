% Implementation rs_multishot_initplan.lp
% Hoang Long Nguyen

%%% BASE PROGAM %%%
#program base.

% initial state
basestate(agent(A),(Y,X),D,EarliestDeparture) :- 
    start(agent(A), (Y,X), EarliestDeparture, dir(D)).

m(forward). 	m(left). 	m(right). m(wait).
dir(e).     dir(w).     dir(n).     dir(s).

% tracks(Type of the track, direction of agent, move)
track(32800,s,forward).	
track(32800,n,forward).

track(1025,e,forward).	
track(1025,w,forward).

track(4608,n,left).	    
track(4608,e,right).

track(16386,w,left).	
track(16386,n,right).

track(72,s,left).	   
 track(72,w,right).

track(2064,e,left).	    
track(2064,s,right).

track(37408,n,left).	
track(37408,e,right).	
track(37408,n,forward).	
track(37408,s,forward).

track(17411,w,left).	
track(17411,n,right).	
track(17411,w,forward).	
track(17411,e,forward).

track(32872,s,left).	
track(32872,w,right).	
track(32872,s,forward).	
track(32872,n,forward).

track(3089,e,left).	    
track(3089,s,right).	
track(3089,e,forward).	
track(3089,w,forward).

track(49186,n,right).	
track(49186,w,left).	
track(49186,n,forward).	
track(49186,s,forward).

track(1097,w,right).	
track(1097,s,left).	    
track(1097,w,forward).	
track(1097,e,forward).

track(34864,s,right).	
track(34864,e,left).	
track(34864,s,forward).	
track(34864,n,forward).

track(5633,e,right).	
track(5633,n,left).	    
track(5633,e,forward).	
track(5633,w,forward).

track(33825,s,forward).	
track(33825,n,forward).	
track(33825,w,forward).	
track(33825,e,forward).

track(38433,s,forward). 
track(38433,w,forward).	
track(38433,n,forward). 
track(38433,n,left).	
track(38433,e,forward). 
track(38433,e,right).

track(50211,e,forward). 
track(50211,s,forward).	
track(50211,w,forward). 
track(50211,w,left).	
track(50211,n,forward). 
track(50211,n,right).

track(33897,n,forward). 
track(33897,e,forward).	
track(33897,s,forward). 
track(33897,s,left).	
track(33897,w,forward). 
track(33897,w,right).

track(35889,w,forward). 
track(35889,n,forward).	
track(35889,e,forward). 
track(35889,e,left).	
track(35889,s,forward). 
track(35889,s,right).

track(38505,s,forward). 
track(38505,s,left).    
track(38505,n,forward). 
track(38505,n,left).    
track(38505,w,forward). 
track(38505,w,right).   
track(38505,e,forward). 
track(38505,e,right).	

track(52275,n,forward). 
track(52275,n,right).   
track(52275,s,forward). 
track(52275,s,right).   
track(52275,e,forward). 
track(52275,e,left).    
track(52275,w,forward). 
track(52275,w,left).	

track(20994,n,left).	
track(20994,e,right).	
track(20994,w,left).	
track(20994,n,right).  

track(16458,w,left).	
track(16458,n,right).	
track(16458,s,left).	
track(16458,w,right).

track(2136,s,left).	    
track(2136,w,right).	
track(2136,e,left).	    
track(2136,s,right). 
   
track(6672,e,left).	    
track(6672,s,right).	
track(6672,n,left).	
track(6672,e,right).

track(8192,n,forward).
track(4,w,forward).
track(128,s,forward).
track(256,e,forward).

% wait tracks
track(Type,D,wait) :- track(Type,_,_), dir(D).

% tracks with atleast two paths
% switch(Type with switch, direction of train)
switch(37408, n).   
switch(17411, w).   
switch(32872, s).   
switch(3089, e).
switch(49186, n).   
switch(1097, w).   
switch(34864, s).   
switch(5633, e).
switch(38433, n).   switch(38433, e).   
switch(50211, w).   switch(50211, n).
switch(33897, s).   switch(33897, w). 
switch(35889, e).   switch(35889, s).
switch(20994, n).  
switch(16458, w).   
switch(2136, s).    
switch(6672, e).
switch(38505, (n;e;s;w)).
switch(52275, (n;e;s;w)).

% mark the tracks with deadends
deadend(8192).
deadend(4).
deadend(128).
deadend(256).

% schedule plan
schedule(A, EarliestDeparture, LatestArrival):- 
    start(agent(A),_,EarliestDeparture,_), 
    end(agent(A),_,LatestArrival).

% determines the new direction and position
% calc_newDir(direction of train, move, new direction after move, offset). 
calc_newDir(s,forward,s,(1,0)). 
calc_newDir(w,forward,w,(0,-1)). 	
calc_newDir(n,forward,n,(-1,0)). 	
calc_newDir(e,forward,e,(0,1)). 	

calc_newDir(e,right,s,(1,0)).	
calc_newDir(s,right,w,(0,-1)).	
calc_newDir(w,right,n,(-1,0)). 
calc_newDir(n,right,e,(0,1)). 

calc_newDir(w,left,s,(1,0)). 
calc_newDir(n,left,w,(0,-1)). 
calc_newDir(e,left,n,(-1,0)).	
calc_newDir(s,left,e,(0,1)).	

calc_newDir(w,wait,w,(0,0)).
calc_newDir(e,wait,e,(0,0)).
calc_newDir(s,wait,s,(0,0)).
calc_newDir(n,wait,n,(0,0)).

% reverse direction
dir_rev(n,s).
dir_rev(w,e).
dir_rev(s,n).
dir_rev(e,w).

time(2).

%%% CHECK PROGRAM
#program check(t).

% goal constraint
:- {finished(A,0..LatestArrival)}=0, end(agent(A),_,LatestArrival), query(t).

%:- not time(t), query(t).


%%% STEP PROGRAM %%%
#program step(t).

% choose for every timestep a move for a train
{ move(A,M,t-1) : m(M) } =1 :- 
    basestate(agent(A),_,_,t-1),
    schedule(A, EarliestDeparture, LatestArrival), 
    EarliestDeparture <= t <= LatestArrival.

% real actions
action(agent(A), wait, t-1) :- move(A,wait,t-1).
action(agent(A), move_forward, t-1) :- move(A,M,t-1), not action(agent(A), move_left, t-1), not action(agent(A), move_right, t-1), not action(agent(A), wait, t-1).
action(agent(A), move_left, t-1) :- move(A,left,t-1), basestate(agent(A),(Y,X),D,t-1), cell((Y,X),Type), switch(Type,D).
action(agent(A), move_right, t-1) :- move(A,right,t-1), basestate(agent(A),(Y,X),D,t-1), cell((Y,X),Type), switch(Type,D).

% state without deadends
basestate(agent(A),(Y_old+Y,X_old+X),D,t) :- 
    basestate(agent(A),(Y_old,X_old),D_old,t-1), 
    move(A,M,t-1), 
    calc_newDir(D_old,M,D,(Y,X)),
    cell((Y_old,X_old),Type),
    not deadend(Type).

% check if train reached his destination
finished(A,t) :- basestate(agent(A),(Y,X),_,t), end(agent(A),(Y,X),_).


% state with deadends
basestate(agent(A),(Y_old+Y,X_old+X),D,t) :- 
    basestate(agent(A),(Y_old,X_old),D_old,t-1), 
    move(A,M,t-1),
    cell((Y_old,X_old),Type),
    deadend(Type),
    dir_rev(D_old,D_rev),
    calc_newDir(D_rev,M,D,(Y,X)).

% check if trains move acording how the tracks are connected
:- move(A,M,t-1), basestate(agent(A),(Y,X),D,t-1), cell((Y,X), Type), not track(Type,D,M).

% no multiple agents at the same position at the same time
:- basestate(agent(A),(Y,X),_,t), basestate(agent(B),(Y,X),_,t), A!=B.

% trains are not allowed to switch positions (avoids crashes)
:- basestate(agent(A),(Y1,X1),_,t-1), basestate(agent(B),(Y2,X2),_,t-1),basestate(agent(A),(Y2,X2),_,t), basestate(agent(B),(Y1,X1),_,t), A!=B.

% legal position
:- basestate(_,(Y,X),_,_), not cell((Y,X),_).

#show basestate/4.
%#show move/3.
%#show schedule/3.
%#show action/3.
%#show query/1.