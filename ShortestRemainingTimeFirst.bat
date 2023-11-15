setlocal EnableDelayedExpansion
@ECHO OFF
CHCP 65001 >NUL


echo Shortest Remaining Time First (SRTF) Scheduling Simulation
echo.

:start
SET /p procnum="Enter number (max 20): "
IF /i !procnum! gtr 20 (
	goto start
)

SET /A i=0
echo Enter process details (Burst_Time Arrival_Time):


SET /A i=0
FOR /l %%i IN (1, 1, %procnum%) DO ( 
	SET /A i+=1
	set /p "input=P[!i!]: "
	for /f "tokens=1,2" %%a in ("!input!") do (
	    set /A pos[!i!]=!i!
	    set /A bt[!i!]=%%a
	    set /A rt[!i!]=%%b
	)
)

SET /A p=0
SET /A low=0
SET /A burn=0
FOR /l %%j IN (1,1,!i!) DO (
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
)

ECHO.
ECHO Process	Burst Time	Arrival Time	
SET /A totalrt=0
FOR /l %%j IN (1,1,!i!) DO (
	ECHO P[!pos[%%j]!]	!bt[%%j]!		!rt[%%j]!
	SET /A totalrt+=!rt[%%j]!
)

SET /A totalrt/=%procnum%
ECHO ════════════════════════════════════════════════════
ECHO Average Wait: %totalrt%
ECHO ════════════════════════════════════════════════════
pause