10 REG=$7F41 : RAM=$7F40
15 PRINT "0 = $00"
20 POKE REG,$00 : POKE REG,$80
25 PRINT "1 = $F0"
30 POKE REG,$F0 : POKE REG,$81
35 PRINT "2 = $05"
40 POKE REG,$05 : POKE REG,$82
45 PRINT "3 = $80"
50 POKE REG,$80 : POKE REG,$83
55 PRINT "4 = $01"
60 POKE REG,$01 : POKE REG,$84
65 PRINT "5 = $20"
70 POKE REG,$20 : POKE REG,$85
75 PRINT "6 = $00"
80 POKE REG,$00 : POKE REG,$86
85 PRINT "7 = $E1"
90 POKE REG,$E1 : POKE REG,$87
100 PRINT "WRITING 'D' TO THE SCREEN"
110 CL=0 : CH=$14 : GOSUB 1000
120 FOR A = 32 TO 64 : POKE RAM,ASC("D") : NEXT A
130 CL=0 : CH=$20 : GOSUB 1000
140 FOR A=1 TO 32: POKE RAM,$22 : NEXT A
999 END
1000 REM SET VRAM ADDRESS
1010 POKE REG,CL:POKE REG,CH + 64
1020 RETURN