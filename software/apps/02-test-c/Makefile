TOP = ..
all: clean 02-test-c.bin

02-test-c.bin:
	ca65 --cpu 65c02 -o kernal.o -l kernal.lst ../inc/kernal.s
	cc65 --cpu 65c02 -I $(TOP)/../inc -I $(TOP)/inc -o main.s main.c
	ca65 --cpu 65c02 -l main.lst -I $(TOP)/../inc -I $(TOP)/inc -o main.o main.s
	ld65 -C $(TOP)/../cfg/ram.cfg -m main.map -o main.raw main.o kernal.o $(TOP)/../build/lib/os.lib
	python3 $(TOP)/../loadtrim.py main.raw $@
clean:
	rm -f *.o *.lst *.map *.raw *.bin *.s