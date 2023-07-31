CC = cl65
CA = ca65
AR = ar65

# ASSEMBLY
LIB_SOURCES = zeropage.s acia.s interrupt.s xmodem.s

%.o: lib/%.s
	ca65 -I include --cpu 65c02 -o build/$@ -l build/$(@:.o=.lst) $<

LIB_OBJECTS = $(LIB_SOURCES:%.s=build/%.o)

# C
C_FW_SOURCES = tty.c main.c
C_LD_SOURCES = demo.c

%.o: %.c
	cc65 --cpu 65c02 -O -o build/$(@:.o=.s) -I headers $<
	ca65 --cpu 65c02 -o build/$@ -l build/$(@:.o=.lst) build/$(<:.c=.s)

C_FW_OBJECTS = $(C_FW_SOURCES:%.c=build/%.o)
C_LD_OBJECTS = $(C_LD_SOURCES:%.c=build/%.o)

# 
all: clean rom_lib firmware ram_lib demo.bin

# Standard libraries
rom_lib: $(LIB_SOURCES:.s=.o)
	cp none.lib build/rom.lib
	$(CA) -t none --cpu 65c02 -I include -o build/crt0.o config/crt0_rom.s
	$(AR) a build/rom.lib build/crt0.o $(LIB_OBJECTS)

ram_lib:
	cp none.lib build/ram.lib
	$(CA) -t none --cpu 65c02 -I include -o build/crt0.o config/crt0_ram.s
	$(AR) a build/ram.lib build/crt0.o $(LIB_OBJECTS)
	
firmware: $(C_FW_SOURCES:.c=.o)
	cl65 -C config/rom.cfg -m build/retro_firmware.map -o build/retro_firmware.bin $(C_FW_OBJECTS) build/rom.lib

demo.raw: $(C_LD_SOURCES:.c=.o)
	cl65 -C config/ram.cfg -m build/$^.map -o build/$@ build/tty.o $(C_LD_OBJECTS) build/ram.lib
	
demo.bin: demo.raw
	python3 loadtrim.py build/$^ build/$@

# CLEAN
clean:
	rm -f build/*
