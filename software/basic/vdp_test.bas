10 BANNER$="6502-RETRO!"
20 CALL $ADC1
30 RAM = $7F40 : REG = $7F41
60 FOR B = 0 TO 23
70 X=0:Y=B:VAL=ASC("|"):GOSUB 1000
80 X=39:Y=B:VAL=ASC("|"):GOSUB 1000
85 GOSUB 1100
90 NEXT B
100 FOR B = 1 TO 38
110 X=B:Y=0:VAL=ASC("-"):GOSUB 1000
120 X=B:Y=23:VAL=ASC("-"):GOSUB 1000
125 GOSUB 1100
130 NEXT B
150 X=0:Y=0:VAL=ASC("+"):GOSUB 1000
160 Y=23:GOSUB 1000
170 X=39:GOSUB 1000
180 Y=0:GOSUB 1000
190 GOSUB 1100
200 X=20-(LEN(BANNER$)/2)
210 Y=12
220 GOSUB 1200
230 GOSUB 1100
999 END
1000 CC=$600+(Y*40)+X
1010 POKE CC,VAL
1020 RETURN
1100 CALL $AE02
1110 CALL $AE0D
1120 RETURN
1200 FOR I = 1 TO LEN(BANNER$)
1210 INC X: VAL=ASC(MID$(BANNER$,I,1)):GOSUB 1000
1220 NEXT I
1230 RETURN