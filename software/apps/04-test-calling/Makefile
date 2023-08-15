TOP = ..
all: clean 04-test-calling.bin

04-test-calling.bin:
	ca65 --cpu 65c02 -l kernal.lst -I $(TOP)/../inc -I $(TOP)/include -o kernal.o $(TOP)/include/kernal.s
	
	cc65 --cpu 65c02 -I $(TOP)/../inc -I $(TOP)/include -o main.s main.c
	ca65 --cpu 65c02 -l main.lst -I $(TOP)/../inc -I $(TOP)/include -o main.o main.s
	ld65 -C $(TOP)/../cfg/ram.cfg -m main.map -o main.raw main.o kernal.o $(TOP)/../build/lib/os.lib
	
	python3 $(TOP)/../loadtrim.py main.raw $@
clean:
	rm -f *.o *.lst *.map *.raw *.bin *.s