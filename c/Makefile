# ASSEMBLY
ASM_LIB_SOURCES = 	zeropage.s \
                  	acia.s \
	          	interrupt.s \
	          	xmodem.s \
	          	kbd.s \
	          	utils.s \
	          	via.s \
	          	sysram.s \
	          	conio.s

C_LIB_SOURCES   =     	tms.c

C_SOURCES       =       main.c
LOAD_C_SOURCES  =       tms_demo.c \
			demo.c

ASM_LIB_OBJECTS =	$(ASM_LIB_SOURCES:%.s=%.o)
C_LIB_OBJECTS   =	$(C_LIB_SOURCES:%.c=%.o)
C_OBJECTS       =       $(C_SOURCES:%.c=%.o)
LOAD_C_OBJECTS  =       $(LOAD_C_SOURCES:%.c=%.o)
LOAD_C_BINS     =       $(LOAD_C_SOURCES:%.c=%.bin)

all: clean rom $(LOAD_C_BINS)

$(ASM_LIB_OBJECTS):
	ca65 --cpu 65c02 -I include -o $(@:%.o=build/%.o) -l $(@:%.o=build/%.lst) $(@:%.o=lib/%.s)

$(C_LIB_OBJECTS):
	cc65 --cpu 65c02 -I headers -O -t none -o $(@:%.o=build/%.s) $(@:%.o=lib/%.c)
	ca65 --cpu 65c02 -o $(@:%.o=build/%.o) -l $(@:%.o=build/%.lst) $(@:%.o=build/%.s)

$(C_OBJECTS):
	cc65 --cpu 65c02 -I headers -O -t none -o $(@:%.o=build/%.s) $(@:%.o=%.c)
	ca65 --cpu 65c02 -o $(@:%.o=build/%.o) -l $(@:%.o=build/%.lst) $(@:%.o=build/%.s)

$(LOAD_C_OBJECTS):
	cc65 --cpu 65c02 -I headers -O -t none -o $(@:%.o=build/%.s) $(@:%.o=%.c)
	ca65 --cpu 65c02 -o $(@:%.o=build/%.o) -l $(@:%.o=build/%.lst) $(@:%.o=build/%.s)

rom_lib:$(ASM_LIB_OBJECTS) $(C_LIB_OBJECTS)
	cp none.lib build/rom.lib
	ca65 -t none --cpu 65c02 -I include -o build/crt0.o config/crt0_rom.s
	ar65 a build/rom.lib build/crt0.o $(ASM_LIB_OBJECTS:%.o=build/%.o) $(C_LIB_OBJECTS:%.o=build/%.o)

ram_lib:$(ASM_LIB_OBJECTS) $(C_LIB_OBJECTS)
	cp none.lib build/ram.lib
	ca65 -t none --cpu 65c02 -I include -o build/crt0.o config/crt0_ram.s
	ar65 a build/ram.lib build/crt0.o $(ASM_LIB_OBJECTS:%.o=build/%.o) $(C_LIB_OBJECTS:%.o=build/%.o)

rom: rom_lib $(C_OBJECTS)
	cl65 -C config/rom.cfg -m build/rom.map -o dist/rom.bin $(C_OBJECTS:%.o=build/%.o) build/rom.lib

$(LOAD_C_BINS): ram_lib $(LOAD_C_OBJECTS)
	cl65 -C config/ram.cfg -m $(@:%.bin=build/%.map) -o $(@:%.bin=build/%.raw) $(@:%.bin=build/%.o) build/ram.lib
	python3 loadtrim.py $(@:%.bin=build/%.raw) dist/$@
clean:
	rm -f build/*
	rm -f dist/*