setlocal EnableDelayedExpansion
@ECHO OFF
CHCP 65001 >NUL

:start
SET /p procnum="Enter number (max 20): "
IF /i !procnum! gtr 20 (
	goto start
)


SET i=0

FOR /l %%a IN (1, 1, %procnum%) DO ( 
  	SET /A i+=1
 	SET /A pos[%%a]=%%a
	SET /p bt[%%a]="P[%%a] : "
)




SET /A low=0
FOR /l %%j IN (1,1,%procnum%) DO (
	SET /A low=!bt[%%j]!
	SET /A p=0

	FOR /l %%k IN (%%j+1,1,%procnum%) DO (
		IF !bt[%%k]! LSS !low! (
			SET /A p=%%k
			SET /A ps=!pos[%%k]!
			SET /A low=!bt[%%k]!

		)
	)
	IF !p! GTR 0 (
		SET /A tem=!bt[%%j]!
		SET /A bt[%%j]=!low!
		SET /A bt[!p!]=!tem!

		SET /A tem=!pos[%%j]!
		SET /A pos[%%j]=!ps!
		SET /A pos[!p!]=!tem!
	)
)

ECHO.
ECHO Process	Burst Time	Waiting Time	Turnaround Time
SET /A tt=0
SET /A totaltt=0
SET /A totalwt=0
FOR /l %%j IN (1,1,%procnum%) DO (
	SET /A wt[%%j]=!tt!
	SET /A totalwt+=!wt[%%j]!
	SET /A tt+=!bt[%%j]!
	SET /A totaltt+=!tt!
	ECHO P[!pos[%%j]!]	!bt[%%j]!		!wt[%%j]!		!tt!
)




SET /A averagewait=!totalwt!/!procnum!
SET /A totaltt/=%procnum%



ECHO ════════════════════════════════════════════════════
ECHO Average Wait: %averagewait%
ECHO Average Turn: %totaltt%
ECHO ════════════════════════════════════════════════════
pause