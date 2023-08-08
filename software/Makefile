common_lib_sources = crt0.s \
		sysram.s \
		zeropage.s
common_lib_objects = $(common_lib_sources:%.s=%.o)
lib         =   build/lib/os.lib

lib_sources =   kernal.s \
		acia.s \
		conio.s \
		ehbasic.s \
		kbd.s \
		utils.s \
		vdp.s \
		via.s \
		wozmon.s \
		xmodem.s \

lib_objects =   $(lib_sources:%.s=%.o)

rom_sources = 	01-test.s \
		02-wozmon.s \
		03-kbd.s \
		04-vdp.s
rom_objects = 	$(rom_sources:%.s=%.o)
rom_bins    =   $(rom_sources:%.s=%.bin)

all: clean $(lib) $(rom_bins)

make_dirs:
	mkdir -pv build/lib
	mkdir -pv build/rom

$(common_lib_objects): make_dirs
	ca65 --cpu 65c02 -l $(@:%.o=build/lib/%.lst) -I inc -o $(@:%.o=build/lib/%.o) $(@:%.o=lib/%.s)

$(lib_objects): make_dirs
	ca65 --cpu 65c02 -l $(@:%.o=build/lib/%.lst) -I inc -o $(@:%.o=build/lib/%.o) $(@:%.o=lib/%.s)

$(rom_objects): $(lib_objects)
	mkdir -pv build/rom
	ca65 --cpu 65c02 -l $(@:%.o=build/rom/%.lst) -I inc -o $(@:%.o=build/rom/%.o) $(@:%.o=rom/%.s)

$(lib): $(common_lib_objects)
	cp -f cfg/none.lib build/lib/os.lib
	ar65 a build/lib/os.lib $(^:%.o=build/lib/%.o)

$(rom_bins): $(rom_objects)
	ld65 -C cfg/rom.cfg -Ln $(@:%.bin=build/rom/%.lnk) -m $(@:%.bin=build/rom/%.map) -o $(@:%.bin=build/rom/%.bin) $(@:%.bin=build/rom/%.o) $(lib_objects:%.o=build/lib/%.o) $(common_lib_objects:%.o=build/lib/%.o) $(lib)

clean:
	rm -fr build