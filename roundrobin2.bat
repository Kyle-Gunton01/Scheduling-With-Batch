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
SET /A total=0
SET /A averagewait=0
SET /A averageturn=0

echo Enter process details (Burst_Time Arrival_Time):

FOR /l %%i IN (1, 1, !procnum!) DO ( 
    SET /A i+=1
    set /p "input=P[%%i]: "
    for /f "tokens=1" %%a in ("!input!") do (
        SET /A pos[!i!]=!i!
        SET /A bt[!i!]=%%a
        SET /A tempbtarr[!i!]=%%a        
    )
)

SET /A procdone=0

:loop
FOR /l %%i IN (1, 1, !procnum!) DO ( 
    IF /i !tempbtarr[%%i]! LEQ !quantum! (
        IF /i !tempbtarr[%%i]! GTR 0 (
            SET /A total+=!tempbtarr[%%i]!
            SET /A tempbtarr[%%i]=0
            SET /A done=1
        )
    ) ELSE ( 
        IF /i !tempbtarr[%%i]! GTR 0 (
            SET /A tempbtarr[%%i]-=!quantum!
            SET /A total+=!quantum!
        ) 
    )
    IF /i !done! EQU 1 (
        SET /A procdone+=1
        SET /A tempwt=!total!-!bt[%%i]!
        SET /A wt[%%i]=!tempwt!
        SET /A averagewait+=!tempwt!
        SET /A temptt=!total!
        SET /A tt[%%i]=!temptt!
        SET /A averageturn+=!temptt!
        SET /A done=0
    )
)

IF /i !procdone! NEQ !procnum! (
    GOTO loop
)

SET /A averagewait/=!quantum!
SET /A averageturn/=!quantum!

ECHO Process    Burst Time    Waiting Time    Turnaround Time
FOR /l %%a IN (1,1,%procnum%) DO (
    ECHO P[%%a]    !bt[%%a]!        !wt[%%a]!        !tt[%%a]!
)
ECHO ════════════════════════════════════════════════════
ECHO Average Wait: %averagewait%
ECHO Average Turn: %averageturn%
ECHO ════════════════════════════════════════════════════
pause
