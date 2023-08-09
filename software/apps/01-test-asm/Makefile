TOP = ..

all: clean 01-test-asm.bin

01-test-asm.bin:
	ca65 --cpu 65c02 -l kernal.lst -I $(TOP)/../inc -I $(TOP)/inc -o kernal.o $(TOP)/inc/kernal.s
	ca65 --cpu 65c02 -l main.lst -I $(TOP)/../inc -I $(TOP)/inc -o main.o main.s
	ld65 -C $(TOP)/../cfg/ram.cfg -m main.map -o main.raw main.o kernal.o $(TOP)/../build/lib/os.lib
	python3 $(TOP)/../loadtrim.py main.raw $@
clean:
	rm -f *.o *.lst *.map *.raw *.bin