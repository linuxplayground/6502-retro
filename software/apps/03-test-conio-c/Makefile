TOP = ..
all: clean 03-test-conio-c.bin

03-test-conio-c.bin:
	ca65 --cpu 65c02 -o kernal.o -l kernal.lst $(TOP)/include/kernal.s
	cc65 --cpu 65c02 -I $(TOP)/../inc -I $(TOP)/include -o main.s main.c
	ca65 --cpu 65c02 -l main.lst -I $(TOP)/../inc -I $(TOP)/include -o main.o main.s
	ld65 -C $(TOP)/../cfg/ram.cfg -m main.map -o main.raw main.o kernal.o $(TOP)/../build/lib/os.lib
	python3 $(TOP)/../loadtrim.py main.raw $@
clean:
	rm -f *.o *.lst *.map *.raw *.bin *.s