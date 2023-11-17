setlocal EnableDelayedExpansion
@ECHO OFF
CHCP 65001 >NUL


echo Priority CPU Scheduling Simulation
echo.

:start
SET /p procnum="Enter number (max 20): "
IF /i !procnum! gtr 20 (
	goto start
)


echo Enter process details (Burst_Time Arrival_Time Priority):


SET /A i=0
SET /A p=0
SET /A low=0
SET /A burn=0
SET /A averagewait=0
SET /A averageturn=0
SET /A turntime=0
SET /A waittime=0
SET /A time=0
SET /A procdone=0

SET /A queue[0]=0	
SET /A queuepos=0

FOR /l %%i IN (1, 1, %procnum%) DO ( 
	SET /A i+=1
	set /p "input=P[!i!]: "
	for /f "tokens=1,2,3" %%a in ("!input!") do (
	    set /A pos[!i!]=!i!
	    set /A bt[!i!]=%%a
	    set /A rt[!i!]=%%b
	    set /A pt[!i!]=%%c
	)
)


FOR /l %%j IN (1,1,!procnum!) DO (
	SET /A a+=1
	SET /A p=0
	SET /A low=!pt[%%j]!
	SET /A arriv=!rt[%%j]!
	SET /A burn=!bt[%%j]!

	FOR /l %%k IN (%%j+1,1,!procnum!) DO (
		IF !pt[%%k]! GTR !low! (
			SET /A p=%%k
			SET /A ps=!pos[%%k]!
			SET /A burn=!bt[%%k]!
			SET /A arriv=!rt[%%k]!
			SET /A low=!pt[%%k]!
		)
	)

	IF !p! GTR 0 (
		SET /A tem=!pt[%%j]!
		SET /A pt[%%j]=!low!
		SET /A pt[!p!]=!tem!

		SET /A tem=!rt[%%j]!
		SET /A rt[%%j]=!arriv!
		SET /A rt[!p!]=!tem!

		SET /A tem=!bt[%%j]!
		SET /A bt[%%j]=!burn!
		SET /A bt[!p!]=!tem!

		SET /A tem=!pos[%%j]!
		SET /A pos[%%j]=ps
		SET /A pos[!p!]=!tem!
	)


)

SET /A index=0
SET /A qi=1
SET /A at=0
:que
FOR /l %%i IN (1, 1, !procnum!) DO ( 
ECHO Round !rt[%%i]! : !at!
	IF /i !rt[%%i]! LEQ !at! (
		IF !switch[%%i]! EQU 0 (
			SET /A at+=!bt[%%i]!
			
			SET /A index+=1
			SET /A queue[!index!]=%%i
			SET /A switch[%%i]=1
			GOTO que
		)
	)
)


ECHO Process	Burst Time	Arrival Time	Waiting Time	Turnaround Time
FOR /l %%a IN (1,1,%procnum%) DO (


	FOR /l %%k IN (!queue[%%a]!,1,!queue[%%a]!) DO (
		SET /A wt=!lastturntime!-!rt[%%k]!
		SET /A averagewait+=!wt!
		SET /A tt=!bt[%%k]!+!wt!
		SET /A averageturn+=!tt!
		SET /A turntime=!tt!
		SET /A lastturntime=!tt!+!rt[%%k]!
		ECHO P[!pos[%%k]!]	!bt[%%k]!		!rt[%%k]!		!wt!		!tt!
	)


)

SET /A averagewait/=%procnum%
SET /A averageturn/=%procnum%

ECHO ════════════════════════════════════════════════════
ECHO Average Wait: %averagewait%
ECHO Average Turn: %averageturn%
ECHO ════════════════════════════════════════════════════
pause