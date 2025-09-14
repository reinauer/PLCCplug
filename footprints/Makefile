CC ?= gcc
CFLAGS ?= -O2 -Wall

# Define pin counts and variants
PIN_COUNTS = 20 28 32 44 52 68 84
COMPONENT_NAMES = APW9322 APW9323 APW9324 APW9325 APW9326 APW9327 APW9328

# Generate all variants for each pin count
FOOTPRINTS_DOUBLE_SIDED = $(foreach name,$(COMPONENT_NAMES),PLCCplug.pretty/$(name).kicad_mod)
FOOTPRINTS_SINGLE_SIDED = $(foreach name,$(COMPONENT_NAMES),PLCCplug.pretty/$(name)_single_sided.kicad_mod)
FOOTPRINTS_SINGLE_SIDED_VIA_OUT = $(foreach name,$(COMPONENT_NAMES),PLCCplug.pretty/$(name)_single_sided_via_outside.kicad_mod)

FOOTPRINTS = $(FOOTPRINTS_DOUBLE_SIDED) $(FOOTPRINTS_SINGLE_SIDED) $(FOOTPRINTS_SINGLE_SIDED_VIA_OUT)

all: $(FOOTPRINTS)

# Create the directory if it doesn't exist
PLCCplug.pretty:
	mkdir -p PLCCplug.pretty

# Double-sided footprints (default behavior)
PLCCplug.pretty/APW9322.kicad_mod: apw | PLCCplug.pretty
	./apw --pins 20 --double-sided --outfile $@
PLCCplug.pretty/APW9323.kicad_mod: apw | PLCCplug.pretty
	./apw --pins 28 --double-sided --outfile $@
PLCCplug.pretty/APW9324.kicad_mod: apw | PLCCplug.pretty
	./apw --pins 32 --double-sided --outfile $@
PLCCplug.pretty/APW9325.kicad_mod: apw | PLCCplug.pretty
	./apw --pins 44 --double-sided --outfile $@
PLCCplug.pretty/APW9326.kicad_mod: apw | PLCCplug.pretty
	./apw --pins 52 --double-sided --outfile $@
PLCCplug.pretty/APW9327.kicad_mod: apw | PLCCplug.pretty
	./apw --pins 68 --double-sided --outfile $@
PLCCplug.pretty/APW9328.kicad_mod: apw | PLCCplug.pretty
	./apw --pins 84 --double-sided --outfile $@

# Single-sided footprints
PLCCplug.pretty/APW9322_single_sided.kicad_mod: apw | PLCCplug.pretty
	./apw --pins 20 --single-sided --outfile $@
PLCCplug.pretty/APW9323_single_sided.kicad_mod: apw | PLCCplug.pretty
	./apw --pins 28 --single-sided --outfile $@
PLCCplug.pretty/APW9324_single_sided.kicad_mod: apw | PLCCplug.pretty
	./apw --pins 32 --single-sided --outfile $@
PLCCplug.pretty/APW9325_single_sided.kicad_mod: apw | PLCCplug.pretty
	./apw --pins 44 --single-sided --outfile $@
PLCCplug.pretty/APW9326_single_sided.kicad_mod: apw | PLCCplug.pretty
	./apw --pins 52 --single-sided --outfile $@
PLCCplug.pretty/APW9327_single_sided.kicad_mod: apw | PLCCplug.pretty
	./apw --pins 68 --single-sided --outfile $@
PLCCplug.pretty/APW9328_single_sided.kicad_mod: apw | PLCCplug.pretty
	./apw --pins 84 --single-sided --outfile $@

# Single-sided footprints with vias outside
PLCCplug.pretty/APW9322_single_sided_via_outside.kicad_mod: apw | PLCCplug.pretty
	./apw --pins 20 --single-sided --via-outside --outfile $@
PLCCplug.pretty/APW9323_single_sided_via_outside.kicad_mod: apw | PLCCplug.pretty
	./apw --pins 28 --single-sided --via-outside --outfile $@
PLCCplug.pretty/APW9324_single_sided_via_outside.kicad_mod: apw | PLCCplug.pretty
	./apw --pins 32 --single-sided --via-outside --outfile $@
PLCCplug.pretty/APW9325_single_sided_via_outside.kicad_mod: apw | PLCCplug.pretty
	./apw --pins 44 --single-sided --via-outside --outfile $@
PLCCplug.pretty/APW9326_single_sided_via_outside.kicad_mod: apw | PLCCplug.pretty
	./apw --pins 52 --single-sided --via-outside --outfile $@
PLCCplug.pretty/APW9327_single_sided_via_outside.kicad_mod: apw | PLCCplug.pretty
	./apw --pins 68 --single-sided --via-outside --outfile $@
PLCCplug.pretty/APW9328_single_sided_via_outside.kicad_mod: apw | PLCCplug.pretty
	./apw --pins 84 --single-sided --via-outside --outfile $@

clean:
	rm -f apw $(FOOTPRINTS)
	rmdir PLCCplug.pretty 2>/dev/null || true
