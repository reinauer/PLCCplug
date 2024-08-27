# Makefile for PLCC plugs

PINS?=20 28 32 44 52 68 84
STLS=$(foreach pin,$(PINS),stl/plcc$(pin).stl) stl/plcc_all.stl

all: $(STLS)

stl/plcc_all.stl: plccplug.scad
	openscad $< -o $@

stl/plcc%.stl: plccplug.scad
	openscad -D output_pins=$(@:stl/plcc%.stl=%) $< -o $@

clean:
	rm stl/plcc??.stl stl/plcc_all.stl
