# PLCC Footprint Generator

This directory contains a C program (`plcc-gen.c`) that generates KiCAD footprints for Adapters-Plus APW932x series PLCC (Plastic Leaded Chip Carrier) plugs.

## Supported Components

The program generates footprints for 6 different PLCC plug models:

- **APW9328** (84 pins) - 36.6×36.6mm package
- **APW9327** (68 pins) - 30.10×30.10mm package
- **APW9326** (52 pins) - 25.10×25.10mm package
- **APW9325** (44 pins) - 22.50×22.50mm package
- **APW9324** (32 pins) - 17.40×19.90mm package
- **APW9323** (28 pins) - 17.40×17.40mm package
- **APW9322** (20 pins) - 15.00×15.00mm package

## Features

- Complete KiCAD `.kicad_mod` footprint files with:
  - Proper pad placement following PLCC standard
  - Silkscreen layer with pin 1 indicator
  - Courtyard and fabrication layers
  - 3D model references
- Configurable pad types (SMD or through-hole)
- Configurable via placement (inside/outside footprint)
- Dimensional data from component datasheets

## Pin Numbering

Follows PLCC standard with pin 1 located at the center of the top edge (marked with a notch), numbered sequentially clockwise around the package perimeter.

## Usage

1. Compile: `gcc -o plcc-gen plcc-gen.c`
2. Run: `./plcc-gen -p PINS [-o output_file]`

Where PINS is the number of pins (20, 28, 32, 44, 52, 68, or 84).

Examples:
- `./plcc-gen -p 84 > APW9328.kicad_mod`
- `./plcc-gen --pins 68 --outfile APW9327.kicad_mod`

## Configuration Options

- `COMPONENT_THROUGHHOLE`: 0 for SMD pads, 1 for through-hole pads
- `COMPONENT_VIA_OUTSIDE`: 0 for vias inside footprint, 1 for vias outside

## Reference

Based on Adapters-Plus APW932x series datasheet: https://www.adapt-plus.com/wp-content/uploads/2023/10/catalogpdf_51ba04f4f3329.pdf
