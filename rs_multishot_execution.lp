% Implementation rs_multishot_execution.lp
% Hoang Long Nguyen

#program base.

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

% rotations
rotationLeft(n,w).
rotationLeft(e,n).
rotationLeft(s,e).
rotationLeft(w,s).

rotationRight(n,e).
rotationRight(e,s).
rotationRight(s,w).
rotationRight(w,n).

% save the order at conflicting positions
tpgorder(agent(A),(Y,X),Order):- basestate(agent(A),(Y,X),_,T1), basestate(agent(B),(Y,X),_,T2), A !=B,
					  Order = #count{C,T : basestate(agent(C),(Y,X),_,T), T<T1, C != A}.

% initial state
state(agent(A),Pos,D,0):- basestate(agent(A),Pos,D,0).

time(8).


#program check(t1).
% check if there is no tpgorder conflict
:- curOrder(agent(A),(Y,X),Order,t1), not tpgorder(agent(A),(Y,X),Order), query1(t1).

#program check(t2).
% check if the initplan is completed
:- basestate(agent(A),Pos,_,T1), {state(agent(A),Pos,_,T2):T1<=T2}=0, query2(t2).

% goal constraint
:- end(agent(A),(Y,X),latestArrival), state(agent(A),(Y,X),T), T>latestArrival.



#program step(t).

% real actions
action(agent(A), wait, t-1) :- state(agent(A),(Y,X),D,t), state(agent(A),(Y,X),D,t-1).
action(agent(A), move_forward, t-1) :-  state(agent(A),(Y1,X1),D,t-1), state(agent(A),(Y2,X2),D,t),(Y1,X1)!=(Y2,X2).
action(agent(A), move_left, t-1) :- state(agent(A),(Y1,X1),D1,t-1), state(agent(A),(Y2,X2),D2,t), cell((Y1,X1),Type), switch(Type,D1), rotationLeft(D1,D2).
action(agent(A), move_right, t-1) :- state(agent(A),(Y1,X1),D1,t-1), state(agent(A),(Y2,X2),D2,t), cell((Y1,X1),Type), switch(Type,D1), rotationRight(D1,D2).


% if a delay occurs, other trains may also get delays
0{delay(agent(A),dur(1),t)}1 :- delay(agent(B),dur(Dur1),T1), state(agent(A),_,_,t),
						A!=B, T1+Dur1 >=  t.
 

% state if there is no delay
state(agent(A),(Y,X),D,t):- basestate(agent(A),(Y,X),D,t), {delay(agent(A),_,0..t)}=0.

% count the durations of the active delays for a train
activeDelay(agent(A), Active,t) :-
    Active = #sum{t-T : delay(agent(A), dur(D), T), T+D>t, t>=T},
    basestate(agent(A),_,_,_).

% count the delays that are finished for a train
oldDelay(agent(A), Old,t) :-
    Old = #sum{D,T: delay(agent(A), dur(D), T), T+D<=t},
    basestate(agent(A),_,_,_).

% track the basestate position before delays
state(agent(A),(Y,X),Dir,t):-
    basestate(agent(A),(Y,X),Dir,t-Old-Active),
    oldDelay(agent(A), Old,t),
    activeDelay(agent(A), Active,t).

% % save the order at conflicting positions at real time
curOrder(agent(A),(Y,X),Order,t) :- state(agent(A),(Y,X),_,t),basestate(agent(B),(Y,X),_,T2), A !=B,
					  Order = #count{C,T : basestate(agent(C),(Y,X),_,T), T<t, C != A}.

% no multiple agents at the same position at the same time
:- state(agent(A),(Y,X),_,t), state(agent(B),(Y,X),_,t), A!=B.

% trains are not allowed to switch positions (avoids crashes)
:- state(agent(A),(Y1,X1),_,t-1), state(agent(B),(Y2,X2),_,t-1),state(agent(A),(Y2,X2),_,t), state(agent(B),(Y1,X1),_,t), A!=B.



#show state/4.
%#show action/3.
%#show delay/3.
%#show activeDelay/3.
%#show oldDelay/3.
%#show tpgorder/3.
%#show basestate/4.
%#show curOrder/4.