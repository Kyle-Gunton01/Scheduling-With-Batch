setlocal EnableDelayedExpansion

@ECHO OFF
CHCP 65001 >NUL

echo Round Robin Scheduling Simulation
echo.


:getprocnum
SET /p procnum="Enter number of processes (max 20): "

IF /i !procnum! GTR 20 (
	GOTO getprocnum
)
IF /i !procnum! LSS 0 (
	GOTO getprocnum
)

:getquantum
SET /p quantum="Enter Quantum: "

IF /i !quantum! LSS 0 (
	GOTO getquantum
)

SET i=0
SET /A counter=0
SET /A procdone=1
SET /A total=0
SET /A averagewait=0
SET /A averageturn=0
SET /A turntime=0
SET /A waittime=0
SET /A max=!procnum!
SET /A queue[0]=0	
SET /A queuepos=0
SET /A maxct=0

echo Enter process details (Burst_Time Arrival_Time):

FOR /l %%i IN (1, 1, !procnum!) DO ( 
	SET /A i+=1
	set /p "input=P[%%i]: "
	for /f "tokens=1,2" %%a in ("!input!") do (
		SET /A pos[!i!]=!i!
		SET /A bt[!i!]=%%a
		SET /A tempbtarr[!i!]=%%a
		SET /A rt[!i!]=%%b
		SET /A maxct+=%%a
		
	)
)

SET /A maxct=(!maxct!+!quantum!)/quantum 
SET /A index=0
SET /A qi=1
SET /A qt=0

:que
ECHO Round !qt!
SET /A qch=!qt!*!quantum!
SET /A qcl=!qch!-quantum
FOR /l %%i IN (1, 1, !procnum!) DO ( 
	IF /i !rt[%%i]! LEQ !qch! (
		IF /i !rt[%%i]! GTR !qcl! (
			ECHO P%%i
			SET /A switch[%%i]=1
			SET /A index+=1
			SET /A queue[!index!]=%%i

		)
	) 	
)


FOR /l %%i IN (1, 1, !procnum!) DO ( 
	IF /i !rt[%%i]! LEQ !qch! (
		IF !switch[%%i]! EQU 0 (
			ECHO NP%%i
			SET /A index+=1
			SET /A queue[!index!]=%%i
			SET /A switch[%%i]=1
		) ELSE (
			IF !switch[%%i]! EQU 1 (
				SET /A switch[%%i]=0
			)
		)
	)
)



SET /A qt+=1
IF /i !index! LEQ !maxct! GOTO que




FOR /l %%h IN (1, 1, !index!) DO ( 
	SET /A j=!queue[%%h]!
		ECHO QUEUE#%%h - !j!
	FOR /l %%i IN (!j!, 1, !j!) DO ( 
		SET /A tempbt=!tempbtarr[%%i]!


		IF /i !tempbt! LEQ !quantum! (
			IF /i !tempbt! GTR 0 (
				SET /A total+=!tempbt!
				SET /A tempbtarr[%%i]=0
				SET /A counter=1
			)
		) ELSE ( 
			IF /i !tempbt! GTR 0 (
				SET /A tempbtarr[%%i]-=!quantum!
				SET /A total+=!quantum!
			) 
		)
		IF /i !counter! EQU 1 (
			SET /A tempwt=!total!-!rt[%%i]!-!bt[%%i]!
			SET /A wt[%%i]=!tempwt!
			SET /A averagewait+=!tempwt!
			SET /A temptt=!total!-!rt[%%i]!
			SET /A tt[%%i]=!temptt!
			SET /A averageturn+=!temptt!
			SET /A counter=0
		)
		ECHO Process P[%%i]	Burst Time !bt[%%i]!	Burt Time Remaining  !tempbtarr[%%i]!	Waiting Time !wt[%%i]!	Turnaround Time !tt[%%i]! Total !total! 
	)
echo.
)

SET /A averagewait/=!procnum!
SET /A averageturn/=!procnum!


ECHO Process	Burst Time	Waiting Time	Turnaround Time
FOR /l %%a IN (1,1,%procnum%) DO (
	ECHO P[%%a]	!bt[%%a]!		!wt[%%a]!		!tt[%%a]!
)
ECHO ════════════════════════════════════════════════════
ECHO Average Wait: %averagewait%
ECHO Average Turn: %averageturn%
ECHO ════════════════════════════════════════════════════
pause