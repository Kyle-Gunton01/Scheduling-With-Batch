setlocal EnableDelayedExpansion

@ECHO OFF
CHCP 65001 >NUL

:start
SET /p procnum=" 	Enter number (max 20): "
ECHO %procnum%

IF /i !procnum! gtr 20 (
	goto start
)


SET i=0
SET /A averagewait=0
SET /A averageturn=0
SET /A turntime=0
SET /A waittime=0
FOR /l %%a IN (1, 1, %procnum%) DO ( 
  	SET /A i+=1 
	SET /p listp[!i!]="p[%%a]: "

	SET /A wt[!i!]=!turntime!
	SET /A averagewait+=!wt[%%a]!
	SET /A tt[!i!]=!listp[%%a]!+!wt[%%a]!
	SET /A averageturn+=!tt[%%a]!
	SET /A turntime=!tt[%%a]!
)

SET /A averagewait/=%procnum%
SET /A averageturn/=%procnum%

ECHO Process	Burst Time	Waiting Time	Turnaround Time
FOR /l %%a IN (1,1,%procnum%) DO (
	SET /A waittime=!turntime!
	SET /A turntime=!listp[%%a]!+!waittime!
	ECHO P[%%a]	!listp[%%a]!		!wt[%%a]!		!tt[%%a]!
)
ECHO ════════════════════════════════════════════════════
ECHO Average Wait: %averagewait%
ECHO Average Turn: %averageturn%
ECHO ════════════════════════════════════════════════════
pause