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
SET /A tempbtarr[21]=2147483647

FOR /l %%i IN (1, 1, %procnum%) DO ( 
	SET /A i+=1
	set /p "input=P[!i!]: "
	for /f "tokens=1,2" %%a in ("!input!") do (
		set /A pos[!i!]=!i!
		set /A bt[!i!]=%%a
		SET /A tempbtarr[!i!]=%%a
		set /A rt[!i!]=%%b
		SET /A totalbt+=%%a
	)
)


SET /A currproc=1
SET /A lastproc=21

ECHO Process	Burst Time Remaining	Current Time
FOR /l %%j IN (0,1,!totalbt!+1) DO (

	FOR /l %%l IN (!currproc!,1,!currproc!) DO (
		IF !tempbtarr[%%l]! EQU 0 (
			SET /A currproc=21
			SET /A tt[%%l]=%%j-!rt[%%l]!
			
			SET /A wt[%%l]=%%j-!rt[%%l]!-!bt[%%l]!
			SET /A averagewait+=!wt[%%l]!
			SET /A averageturn+=!tt[%%l]!
		)	
	)

	FOR /l %%k IN (1,1,!procnum!) DO (
		IF !tempbtarr[%%k]! GTR 0 (
			IF !rt[%%k]! LEQ %%j (
				FOR /l %%l IN (!currproc!,1,!currproc!) DO (
					IF !tempbtarr[%%k]! LSS !tempbtarr[%%l]! (
						SET /A currproc=%%k
					)
				)
			)
		)
	)
	FOR /l %%l IN (!currproc!,1,!currproc!) DO (
		IF /I !lastproc! NEQ !currproc! (
			IF /i !currproc! NEQ 21 (
				SET /A lastproc=!currproc!
				ECHO P[!pos[%%l]!]	!tempbtarr[%%l]!			%%j
			)
		)
	)
	SET /A tempbtarr[!currproc!]-=1
)




ECHO.
ECHO Process	Burst Time	Arrival Time	Waiting Time	Turnaround Time
SET /A totalrt=0
FOR /l %%j IN (1,1,!procnum!) DO (
	ECHO P[!pos[%%j]!]	!bt[%%j]!		!rt[%%j]!		!wt[%%j]!		!tt[%%j]!
	SET /A totalrt+=!rt[%%j]!
)


SET /A averagewait/=%procnum%
SET /A averageturn/=%procnum%

ECHO ════════════════════════════════════════════════════
ECHO Average Wait: %averagewait%
ECHO Average Turn: %averageturn%
ECHO ════════════════════════════════════════════════════
pause
