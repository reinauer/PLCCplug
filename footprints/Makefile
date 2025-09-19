CC ?= gcc
CFLAGS ?= -O2 -Wall

DEST?=../PLCCplug.pretty

# Define pin counts and variants
PIN_COUNTS = 20 28 32 44 52 68 84
COMPONENT_NAMES = APW9322 APW9323 APW9324 APW9325 APW9326 APW9327 APW9328

# Generate all variants for each pin count
FOOTPRINTS_SINGLE_SIDED = $(foreach name,$(COMPONENT_NAMES),$(DEST)/$(name)_single_sided.kicad_mod)
FOOTPRINTS_DOUBLE_SIDED = $(foreach name,$(COMPONENT_NAMES),$(DEST)/$(name).kicad_mod)
FOOTPRINTS_SINGLE_SIDED_VIA_OUT = $(foreach name,$(COMPONENT_NAMES),$(DEST)/$(name)_single_sided_via_outside.kicad_mod)
FOOTPRINTS_DOUBLE_SIDED_VIA_OUT = $(foreach name,$(COMPONENT_NAMES),$(DEST)/$(name)_via_outside.kicad_mod)

FOOTPRINTS = $(FOOTPRINTS_SINGLE_SIDED) $(FOOTPRINTS_DOUBLE_SIDED) $(FOOTPRINTS_SINGLE_SIDED_VIA_OUT) $(FOOTPRINTS_DOUBLE_SIDED_VIA_OUT)

PLCCGEN=./plcc-gen

all: $(FOOTPRINTS)

# Create the directory if it doesn't exist
$(DEST):
	mkdir -p $(DEST)

# Double-sided footprints (vias inside)
$(DEST)/APW9322.kicad_mod: $(PLCCGEN) | $(DEST)
	$(PLCCGEN) --pins 20 --double-sided --outfile $@
$(DEST)/APW9323.kicad_mod: $(PLCCGEN) | $(DEST)
	$(PLCCGEN) --pins 28 --double-sided --outfile $@
$(DEST)/APW9324.kicad_mod: $(PLCCGEN) | $(DEST)
	$(PLCCGEN) --pins 32 --double-sided --outfile $@
$(DEST)/APW9325.kicad_mod: $(PLCCGEN) | $(DEST)
	$(PLCCGEN) --pins 44 --double-sided --outfile $@
$(DEST)/APW9326.kicad_mod: $(PLCCGEN) | $(DEST)
	$(PLCCGEN) --pins 52 --double-sided --outfile $@
$(DEST)/APW9327.kicad_mod: $(PLCCGEN) | $(DEST)
	$(PLCCGEN) --pins 68 --double-sided --outfile $@
$(DEST)/APW9328.kicad_mod: $(PLCCGEN) | $(DEST)
	$(PLCCGEN) --pins 84 --double-sided --outfile $@

# Single-sided footprints
$(DEST)/APW9322_single_sided.kicad_mod: $(PLCCGEN) | $(DEST)
	$(PLCCGEN) --pins 20 --single-sided --outfile $@
$(DEST)/APW9323_single_sided.kicad_mod: $(PLCCGEN) | $(DEST)
	$(PLCCGEN) --pins 28 --single-sided --outfile $@
$(DEST)/APW9324_single_sided.kicad_mod: $(PLCCGEN) | $(DEST)
	$(PLCCGEN) --pins 32 --single-sided --outfile $@
$(DEST)/APW9325_single_sided.kicad_mod: $(PLCCGEN) | $(DEST)
	$(PLCCGEN) --pins 44 --single-sided --outfile $@
$(DEST)/APW9326_single_sided.kicad_mod: $(PLCCGEN) | $(DEST)
	$(PLCCGEN) --pins 52 --single-sided --outfile $@
$(DEST)/APW9327_single_sided.kicad_mod: $(PLCCGEN) | $(DEST)
	$(PLCCGEN) --pins 68 --single-sided --outfile $@
$(DEST)/APW9328_single_sided.kicad_mod: $(PLCCGEN) | $(DEST)
	$(PLCCGEN) --pins 84 --single-sided --outfile $@

# Single-sided footprints with vias outside
$(DEST)/APW9322_single_sided_via_outside.kicad_mod: $(PLCCGEN) | $(DEST)
	$(PLCCGEN) --pins 20 --single-sided --via-outside --outfile $@
$(DEST)/APW9323_single_sided_via_outside.kicad_mod: $(PLCCGEN) | $(DEST)
	$(PLCCGEN) --pins 28 --single-sided --via-outside --outfile $@
$(DEST)/APW9324_single_sided_via_outside.kicad_mod: $(PLCCGEN) | $(DEST)
	$(PLCCGEN) --pins 32 --single-sided --via-outside --outfile $@
$(DEST)/APW9325_single_sided_via_outside.kicad_mod: $(PLCCGEN) | $(DEST)
	$(PLCCGEN) --pins 44 --single-sided --via-outside --outfile $@
$(DEST)/APW9326_single_sided_via_outside.kicad_mod: $(PLCCGEN) | $(DEST)
	$(PLCCGEN) --pins 52 --single-sided --via-outside --outfile $@
$(DEST)/APW9327_single_sided_via_outside.kicad_mod: $(PLCCGEN) | $(DEST)
	$(PLCCGEN) --pins 68 --single-sided --via-outside --outfile $@
$(DEST)/APW9328_single_sided_via_outside.kicad_mod: $(PLCCGEN) | $(DEST)
	$(PLCCGEN) --pins 84 --single-sided --via-outside --outfile $@

# Double-sided footprints with vias outside
$(DEST)/APW9322_via_outside.kicad_mod: $(PLCCGEN) | $(DEST)
	$(PLCCGEN) --pins 20 --double-sided --via-outside --outfile $@
$(DEST)/APW9323_via_outside.kicad_mod: $(PLCCGEN) | $(DEST)
	$(PLCCGEN) --pins 28 --double-sided --via-outside --outfile $@
$(DEST)/APW9324_via_outside.kicad_mod: $(PLCCGEN) | $(DEST)
	$(PLCCGEN) --pins 32 --double-sided --via-outside --outfile $@
$(DEST)/APW9325_via_outside.kicad_mod: $(PLCCGEN) | $(DEST)
	$(PLCCGEN) --pins 44 --double-sided --via-outside --outfile $@
$(DEST)/APW9326_via_outside.kicad_mod: $(PLCCGEN) | $(DEST)
	$(PLCCGEN) --pins 52 --double-sided --via-outside --outfile $@
$(DEST)/APW9327_via_outside.kicad_mod: $(PLCCGEN) | $(DEST)
	$(PLCCGEN) --pins 68 --double-sided --via-outside --outfile $@
$(DEST)/APW9328_via_outside.kicad_mod: $(PLCCGEN) | $(DEST)
	$(PLCCGEN) --pins 84 --double-sided --via-outside --outfile $@

clean:
	rm -f $(PLCCGEN) $(FOOTPRINTS)
	rmdir $(DEST) 2>/dev/null || true
