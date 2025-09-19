# Makefile for PLCC plugs

PINS?=20 28 32 44 52 68 84

OPENSCAD:=openscad-nightly
STLDIR=./PLCCplug.stl
VRMLDIR=./PLCCplug.3dshapes

# Check if PINS is set to its default value
ifneq ($(PINS),20 28 32 44 52 68 84)
    STLS=$(foreach pin,$(PINS),$(STLDIR)/PLCCplug-$(pin)pin.stl)
    VRMLS=$(foreach pin,$(PINS),$(VRMLDIR)/PLCCplug-$(pin)pin.wrl)
else
    STLS=$(foreach pin,$(PINS),$(STLDIR)/PLCCplug-$(pin)pin.stl) $(STLDIR)/PLCCplug_all_versions.stl
    VRMLS=$(foreach pin,$(PINS),$(VRMLDIR)/PLCCplug-$(pin)pin.wrl) $(VRMLDIR)/PLCCplug_all_versions.wrl
endif

all: $(STLS) $(VRMLS) footprint

footprint:
	make -C footprints

$(STLDIR)/PLCCplug_all_versions.stl: plccplug.scad
	$(OPENSCAD) -D scale_factor=1 $< -o $@

$(VRMLDIR)/PLCCplug_all_versions.wrl: plccplug.scad
	$(OPENSCAD) -Drender_pins=1 -D scale_factor=0.3937 $< -o $@

$(STLDIR)/PLCCplug-%pin.stl: plccplug.scad
	$(OPENSCAD) -D output_pins=$(patsubst %pin,%,$*) -D scale_factor=1 $< -o $@

$(VRMLDIR)/PLCCplug-%pin.wrl: plccplug.scad
	$(OPENSCAD) -D output_pins=$(patsubst %pin,%,$*) -Drender_pins=1 -D scale_factor=0.3937 $< -o $@

clean:
	rm -f $(STLDIR)/PLCCplug-??pin.stl $(STLDIR)/PLCCplug_all_versions.stl $(VRMLDIR)/PLCCplug-??pin.wrl $(VRMLDIR)/PLCCplug_all_versions.wrl
