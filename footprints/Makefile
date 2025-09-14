CC ?= gcc
CFLAGS ?= -O2 -Wall

# Define all footprints to generate
FOOTPRINTS = PLCCplug.pretty/APW9322.kicad_mod \
             PLCCplug.pretty/APW9323.kicad_mod \
             PLCCplug.pretty/APW9324.kicad_mod \
             PLCCplug.pretty/APW9325.kicad_mod \
             PLCCplug.pretty/APW9326.kicad_mod \
             PLCCplug.pretty/APW9327.kicad_mod \
             PLCCplug.pretty/APW9328.kicad_mod

all: $(FOOTPRINTS)

# Create the directory if it doesn't exist
PLCCplug.pretty:
	mkdir -p PLCCplug.pretty

# Generate individual footprints
PLCCplug.pretty/APW9322.kicad_mod: apw | PLCCplug.pretty
	./apw --pins 20 --outfile $@

PLCCplug.pretty/APW9323.kicad_mod: apw | PLCCplug.pretty
	./apw --pins 28 --outfile $@

PLCCplug.pretty/APW9324.kicad_mod: apw | PLCCplug.pretty
	./apw --pins 32 --outfile $@

PLCCplug.pretty/APW9325.kicad_mod: apw | PLCCplug.pretty
	./apw --pins 44 --outfile $@

PLCCplug.pretty/APW9326.kicad_mod: apw | PLCCplug.pretty
	./apw --pins 52 --outfile $@

PLCCplug.pretty/APW9327.kicad_mod: apw | PLCCplug.pretty
	./apw --pins 68 --outfile $@

PLCCplug.pretty/APW9328.kicad_mod: apw | PLCCplug.pretty
	./apw --pins 84 --outfile $@

clean:
	rm -f apw $(FOOTPRINTS)
	rmdir PLCCplug.pretty 2>/dev/null || true
