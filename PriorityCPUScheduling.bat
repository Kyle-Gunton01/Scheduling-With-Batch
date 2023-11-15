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

echo Enter process details (Burst_Time Priority):


SET /A i=0
SET /A p=0
SET /A low=0
SET /A burn=0
SET /A averagewait=0
SET /A averageturn=0
SET /A turntime=0
SET /A waittime=0

FOR /l %%i IN (1, 1, %procnum%) DO ( 
	SET /A i+=1
	set /p "input=P[!i!]: "
	for /f "tokens=1,2" %%a in ("!input!") do (
	    set /A pos[!i!]=!i!
	    set /A bt[!i!]=%%a
	    set /A rt[!i!]=%%b
	)
)


FOR /l %%j IN (1,1,!i!) DO (
	SET /A a+=1
	SET /A p=0
	SET /A low=!rt[%%j]!
	SET /A burn=!bt[%%j]!

	FOR /l %%k IN (%%j+1,1,!i!) DO (
		IF !rt[%%k]! LSS !low! (
			SET /A p=%%k
			SET /A ps=!pos[%%k]!
			SET /A burn=!bt[%%k]!
			SET /A low=!rt[%%k]!
		)
	)

	IF !p! GTR 0 (
		SET /A tem=!rt[%%j]!
		SET /A rt[%%j]=!low!
		SET /A rt[!p!]=!tem!

		SET /A tem=!bt[%%j]!
		SET /A bt[%%j]=!burn!
		SET /A bt[!p!]=!tem!

		SET /A tem=!pos[%%j]!
		SET /A pos[%%j]=ps
		SET /A pos[!p!]=!tem!
	)

	SET /A wt[%%j]=!turntime!
	SET /A averagewait+=!wt[%%j]!
	SET /A tt[%%j]=!bt[%%j]!+!wt[%%j]!
	SET /A averageturn+=!tt[%%j]!
	SET /A turntime=!tt[%%j]!
)


SET /A averagewait/=%procnum%
SET /A averageturn/=%procnum%

ECHO Process	Burst Time	Waiting Time	Turnaround Time
FOR /l %%a IN (1,1,%procnum%) DO (
	SET /A waittime=!turntime!
	SET /A turntime=!listp[%%a]!+!waittime!
	ECHO P[!pos[%%a]!]	!bt[%%a]!		!wt[%%a]!		!tt[%%a]!
)

ECHO ════════════════════════════════════════════════════
ECHO Average Wait: %averagewait%
ECHO Average Turn: %averageturn%
ECHO ════════════════════════════════════════════════════
pause