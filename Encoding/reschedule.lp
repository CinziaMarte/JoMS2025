avail(1..150, DAY) :- x(_, DAY, _, _, _).
new_reg(ID, DAY, TS, N, PrID) :- new_reg(ID, TS, N, PrID), avail(_, DAY).
block(TS_MIN) :- #min{TS: new_reg(ID, D, TS, P, PrID); TS: x(ID, D, TS, PrID, P), exam_new(ID, P, NumTS)} = TS_MIN.
block(RID, P) :- x(RID, D, TS, P, PrID), block(TS_MIN), not exam_new(RID, _, _), TS < TS_MIN.
{y(ID, D, TS, PrID, P) : avail(TS, D), TS >= RequiredTS} = 1 :- new_reg(ID, D, RequiredTS, P, PrID).
{y(ID, D, TS_N, PrID, 0) : avail(TS_N, D), TS_N >= TS} = 1 :- x(ID, D, TS, PrID, 0), not block(ID, 0).
{y(ID, D, START, PrID, P+1) : avail(START,D), START >= TS+NumTS} = 1 :- y(ID, D, TS, PrID, P), exam(PrID, P, NumTS), P>=0, P<3, not block(ID, P).
{y(ID, D, START, PrID, P+1) : avail(START,D), START >= TS+NumTS} = 1 :- y(ID, D, TS, PrID, P), exam_new(ID, P, NumTS), P >= 0, P < 3.
y(ID, D, TS, PrID, P) :- x(ID, D, TS, PrID, P), block(ID, P).
:- y(ID, D, TS_N, _, P), x(ID, D, TS_O, _, P), TS_N < TS_O. 
to_move(RID) :- tomograph(ID, RID, DAY, _), unavailable_tomograph(ID, DAY).
to_move(RID) :- chair(ID, RID, DAY, _), unavailable_chair(ID, DAY).
to_move(RID) :- tomograph(ID, RID, DAY, _), tomograph(ID, ROOM), unavailable_room(ROOM, DAY, TS).
to_move(RID) :- chair(ID, RID, DAY, _), chair(ID, ROOM), unavailable_room(ROOM, DAY, TS).
1 {y(RID, DAY, TS_N, PrID, 0) : avail(TS_N,DAY)} 1 :- to_move(RID), x(RID, DAY, TS, PrID, N).
{y(RID, DAY, START, PrID, N+1) : avail(START,DAY), START >= TS+NumTS} = 1 :- y(RID, DAY, TS, PrID, N), exam(PrID, N, NumTS), N>=0, N<3.
y(RID, DAY, TS, P, N) :- x(RID, DAY, TS, P, N), not to_move(RID).
timeAnamnesi(RID, TS..TS+NumTS-1) :- y(RID, DAY, TS, PrID, 0), exam(PrID, 0, NumTS).
:- #count{RID: timeAnamnesi(RID, TS)} > 2, avail(TS,DAY).
timeOccupation(RID, DAY, TS, END, PrID) :- y(RID, DAY, TS, PrID, 1), y(RID, DAY, END, PrID, 3).
timeOccupation(RID, DAY, TS, END, PrID) :- not y(RID, DAY, _, _, 1), y(RID, DAY, TS, PrID, 2), y(RID, DAY, END, PrID, 3).
res(RID, DAY, TS..END-1,0) :- timeOccupation(RID, DAY, TS, END, PrID), required_chair(PrID).
res(RID, DAY, TS..TS+NumTS-1,1) :- y(RID, DAY, TS, PrID, 3), exam(PrID, 3, NumTS), required_chair(PrID).
res(RID, DAY, TS..END+NumTS-1,1) :- timeOccupation(RID, DAY, TS, END, PrID), exam(PrID, 3, NumTS), not required_chair(PrID).
:- #count{RID: ytomograph(ID, RID, DAY), y(RID, DAY, _, X, _)} > N, limit(X, N), tomograph(ID,_).
:- not ytomograph(ID, RID, DAY), y(RID, DAY, _, X, _), on(X, ID).
1 {ychair(ID, RID, DAY) : chair(ID, _), not unavailable_chair(ID, DAY)} 1 :- y(RID, DAY, _, PROTOCOL, _), required_chair(PROTOCOL).
1 {ytomograph(ID, RID, DAY) : tomograph(ID, _), not unavailable_tomograph(ID, DAY)} 1 :- y(RID, DAY, _, PROTOCOL, _).
:- ychair(SEDIA, RID, DAY), ytomograph(TOMOGRAFO, RID, DAY), chair(SEDIA, ID1), tomograph(TOMOGRAFO, ID2), ID1 != ID2.
ychair(ID, RID, DAY, TS) :- ychair(ID, RID, DAY), res(RID, DAY, TS, 0).
ytomograph(ID, RID, DAY, TS) :- ytomograph(ID, RID, DAY), res(RID, DAY, TS, 1).
:- #count{RID : ychair(ID, RID, DAY, TS)} > 1, chair(ID,_), avail(TS,DAY).
:- #count{RID: ytomograph(ID, RID, DAY, TS)} > 1, tomograph(ID,_), avail(TS, DAY).
:- ytomograph(ID, RID, DAY, TS), tomograph(ID, ROOM), unavailable_room(ROOM, DAY, TS).
:- ychair(ID, RID, DAY, TS), chair(ID, ROOM), unavailable_room(ROOM, DAY,TS).
:~ y(ID, D, TS, _, P), new_reg(ID, D, RequiredTS, _, P). [TS-RequiredTS@4, ID]
:~ not y(RID, _, _, _, _), to_move(RID). [1@4, RID]
:~ y(RID, DAY, TS_NEW, _, N), x(RID, DAY, TS_OLD, _, N). [|TS_NEW-TS_OLD|@3, RID]
:~ res(RID, DAY, TS, _), TS > 120. [1@2, RID, TS]
:~ not ytomograph(ID, RID, _, _), tomograph(ID, RID, _, _). [1@1,RID]
:~ not ychair(ID, RID, _, _), chair(ID, RID, _, _). [1@1,RID]


#show y/5.
#show ychair/4.
#show ytomograph/4.
