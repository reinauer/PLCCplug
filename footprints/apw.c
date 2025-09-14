/* KiCAD footprint generator for APW9328 PLCC plugs.
 * And maybe other stuff in the future.
 * GPL-2
 * (C) 2021-2025 Stefan Reinauer <stefan.reinauer@coreboot.org>
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>
#include <float.h>

// Component pins will be set at runtime
static int component_pins = 0;

// Configuration options (will be set at runtime)
static int component_throughhole = 1;  // Default: double-sided pads (throughhole with vias)
static int component_via_outside = 1;  // Default: vias on the outside

// Component configuration structure
typedef struct {
	char *name;
	int pins_x;
	int pins_y;
	double pitch;
	double a;
	double b;
	double c;
	double d;
	double pad_width;
} component_config_t;

// From the datasheet:

#define ADAPTPLUS
#undef  WINSLOW
static component_config_t configs[] = {
#ifdef ADAPTPLUS
	{"APW9322",  5,  5, 1.27, 15.00,  8.70, 15.00,  8.70, 0.9}, // 20 pins
	{"APW9323",  7,  7, 1.27, 17.40, 11.15, 17.40, 11.15, 0.9}, // 28 pins
	{"APW9324",  7,  9, 1.27, 17.40, 11.15, 19.90, 13.60, 0.9}, // 32 pins
	{"APW9325", 11, 11, 1.27, 22.50, 16.40, 22.50, 16.40, 0.9}, // 44 pins
	{"APW9326", 13, 13, 1.27, 25.10, 18.90, 25.10, 18.90, 0.9}, // 52 pins
	{"APW9327", 17, 17, 1.27, 30.10, 23.90, 30.10, 23.90, 0.9}, // 68 pins
	{"APW9328", 21, 21, 1.27, 36.60, 27.50, 36.60, 27.50, 0.9}, // 84 pins
#endif
#ifdef WINSLOW
	{"W9322",  5,  5, 1.27, 15.00,  8.70, 15.00,  8.70, 0.9}, // 20 pins
	{"W9323",  7,  7, 1.27, 17.40, 11.15, 17.40, 11.15, 0.9}, // 28 pins
	{"W9324",  7,  9, 1.27, 17.40, 11.02, 19.90, 13.60, 0.9}, // 32 pins
	{"W9325", 11, 11, 1.27, 22.50, 16.40, 22.50, 16.40, 0.9}, // 44 pins
	{"W9326", 13, 13, 1.27, 25.10, 18.90, 25.10, 18.90, 0.9}, // 52 pins
	{"W9327", 17, 17, 1.27, 30.10, 23.90, 30.10, 23.90, 0.9}, // 68 pins
	{"W9328", 21, 21, 1.27, 35.20, 28.90, 35.20, 28.90, 0.9}, // 84 pins
#endif
};

static component_config_t *current_config = NULL;

static component_config_t* get_config_for_pins(int pins)
{
	int pin_counts[] = {20, 28, 32, 44, 52, 68, 84};
	for (int i = 0; i < 7; i++) {
		if (pin_counts[i] == pins) {
			return &configs[i];
		}
	}
	return NULL;
}

#define COMPONENT_PINS component_pins
#define COMPONENT_NAME current_config->name
#define COMPONENT_PINS_X current_config->pins_x
#define COMPONENT_PINS_Y current_config->pins_y
#define COMPONENT_PITCH current_config->pitch
#define COMPONENT_A current_config->a
#define COMPONENT_B current_config->b
#define COMPONENT_C current_config->c
#define COMPONENT_D current_config->d
#define COMPONENT_PAD_WIDTH current_config->pad_width

// Configuration macros (now use runtime variables)
#define COMPONENT_THROUGHHOLE component_throughhole
#define COMPONENT_VIA_OUTSIDE component_via_outside

// Pin numbering:
//
//           1 ->
//    +------*------\`
//    |             |
//    |             |
//    |             |
//    |             |
//    |             |
//    +-------------+
//
// 84pin:
//   75 .. 84 1 .. 11 (top)
//   12 .. 32 (right)
//   33 .. 53 (bottom)
//   54 .. 74 (left)

static void kicad_mod_header(void)
{
	printf ("(footprint \"%s\" (version 20210228) (generator pcbnew) (layer \"F.Cu\")\n"
		"  (tedit 60690F97)\n"
  		"  (descr \"PLCC plug, %d pins, surface mount\")\n"
		"  (tags \"plcc smt\")\n"
		"  (autoplace_cost180 1)\n"
  		"  (attr smd)\n", COMPONENT_NAME, COMPONENT_PINS);
}

static void kicad_mod_timestamp(void)
{
	/* A lot of files I worked with had a zero timestamp, although
	 * my copy of KiCAD 6.0rc1 added timestamps for some pads. Not
	 * sure what these are actually good for. Let's assume zero is
	 * sufficient */
	printf ("(tstamp 00000000-0000-0000-0000-000000000000)");
}

static void kicad_mod_texts(double height)
{
	double font_height=1;
	double offset=(height / 2) + font_height;

	printf("  (fp_text reference \"IC2\" (at 0 %.3f -180) (layer \"F.SilkS\")\n"
		"    (effects (font (size %.3f %.3f) (thickness 0.15)))\n",
		-offset, font_height, font_height);
	printf("    ");
	kicad_mod_timestamp();
	printf("\n  )\n");


	printf("  (fp_text value \"%s\" (at 0 %.3f -180) (layer \"F.Fab\")\n"
		"    (effects (font (size %.3f %.3f) (thickness 0.15)))\n",
		COMPONENT_NAME, offset + .5, font_height, font_height);
	printf("    ");
	kicad_mod_timestamp();
	printf("\n  )\n");

	printf("  (fp_text user \"${REFERENCE}\" (at 0 0.525 -180) (layer \"F.Fab\")\n"
		"    (effects (font (size %.3f %.3f) (thickness 0.15)))\n",
		font_height, font_height);
	printf("    ");
	kicad_mod_timestamp();
	printf("\n  )\n");
}

static void kicad_mod_silkscreen(char *silkscreen)
{
	double ox, oy, top_height;
	ox = COMPONENT_A / 2;
	oy = COMPONENT_C / 2;
	top_height = -oy;

	//     x1/y1  x2/y2
	//	+------+
	//      |      |
	//      |      |
	//	+------+
	//     x4/y4  x3/y3

	double x1,x2,x3,x4;
	double y1,y2,y3,y4;

	//x1 = -18.15; y1 = -17.625;
	//x2 = 18.15; y2 = -17.625;
	x1 = -18.5; y1 = -18.5;
	x2 = 18.5; y2 = -18.5;
	x3 = 18.5; y3 = 18.5;
	x4 = -18.5; y4 = 18.5;

  	// right line
	printf("  (fp_line (start %.3f %.3f) (end %.3f %.3f) (layer \"%s\") (width 0.12) (tstamp 00000000-0000-0000-0000-000000000000))\n", x2, y2 + 1, x3, y3, silkscreen);
	// left line
	printf("  (fp_line (start %.3f %.3f) (end %.3f %.3f) (layer \"%s\") (width 0.12) (tstamp 00000000-0000-0000-0000-000000000000))\n", x4, y4, x1, y1, silkscreen);
  	// bottom line
	printf("  (fp_line (start %.3f %.3f) (end %.3f %.3f) (layer \"%s\") (width 0.12) (tstamp 00000000-0000-0000-0000-000000000000))\n", x3, y3, x4, y4, silkscreen);

  // \ <--
	printf("  (fp_line (start %.3f %.3f) (end %.3f %.3f) (layer \"%s\") (width 0.12) (tstamp 00000000-0000-0000-0000-000000000000))\n", x2-1,y2,x2,y2+1, silkscreen);
  // top line left of 1
	printf("  (fp_line (start %.3f %.3f) (end %.3f %.3f) (layer \"%s\") (width 0.12) (tstamp 00000000-0000-0000-0000-000000000000))\n", x1, y1, -1.0, y1, silkscreen);
  // top line right of 1
	printf("  (fp_line (start %.3f %.3f) (end %.3f %.3f) (layer \"%s\") (width 0.12) (tstamp 00000000-0000-0000-0000-000000000000))\n", 1.0, y1, x2-1, y2, silkscreen);
#if 1
	// FIXME This needs to be done dynamically

  // right horiz edge top
	printf("  (fp_line (start 13.675 -14.8) (end 14.175 -14.8) (layer \"%s\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n", silkscreen);

  // \ <--
	printf("  (fp_line (start 14.175 -14.8) (end 15.325 -13.65) (layer \"%s\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n", silkscreen);
  // left horiz edge top
	printf("  (fp_line (start -13.675 -14.8) (end -15.325 -14.8) (layer \"%s\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n", silkscreen);
  // right vert edge top
	printf("  (fp_line (start 15.325 -13.65) (end 15.325 -13.15) (layer \"%s\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n", silkscreen);
  // right vert line bottom
	printf("  (fp_line (start 15.325 15.85) (end 15.325 14.2) (layer \"%s\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n", silkscreen);
  // left hor line bottom
	printf("  (fp_line (start -13.675 15.85) (end -15.325 15.85) (layer \"%s\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n", silkscreen);
  // left vert line bottom
	printf("  (fp_line (start -15.325 15.85) (end -15.325 14.2) (layer \"%s\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n", silkscreen);
  // left vert line top
	printf("  (fp_line (start -15.325 -14.8) (end -15.325 -13.15) (layer \"%s\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n", silkscreen);
  // right vert line bottom
	printf("  (fp_line (start 13.675 15.85) (end 15.325 15.85) (layer \"%s\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n", silkscreen);
#endif
}


/* Draw CrtYd */
// FIXME front layer only
static void kicad_mod_courtyard(void)
{
	double ox, oy;
	ox = COMPONENT_A / 2;
	oy = COMPONENT_C / 2;
	printf(
  	"  (fp_line (start %.3f %.3f) (end %.3f %.3f) (layer \"F.CrtYd\") (width 0.05) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  	"  (fp_line (start %.3f %.3f) (end %.3f %.3f) (layer \"F.CrtYd\") (width 0.05) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  	"  (fp_line (start %.3f %.3f) (end %.3f %.3f) (layer \"F.CrtYd\") (width 0.05) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  	"  (fp_line (start %.3f %.3f) (end %.3f %.3f) (layer \"F.CrtYd\") (width 0.05) (tstamp 00000000-0000-0000-0000-000000000000))\n",
  	-ox, -oy,  ox, -oy,
  	-ox,  oy, -ox, -oy,
  	 ox,  oy, -ox,  oy,
  	 ox, -oy,  ox,  oy);
}

/* Draw Fab layer */
// FIXME front layer only
static void kicad_mod_fabrication(void)
{
	printf(
  "  (fp_line (start -18 -17.475) (end 17 -17.475) (layer \"F.Fab\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  "  (fp_line (start 18 18.525) (end -18 18.525) (layer \"F.Fab\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  "  (fp_line (start 18 -16.475) (end 18 18.525) (layer \"F.Fab\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  "  (fp_line (start -18 18.525) (end -18 -17.475) (layer \"F.Fab\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  "  (fp_line (start 17 -17.475) (end 18 -16.475) (layer \"F.Fab\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  "  (fp_line (start -16.73 -16.205) (end 16.73 -16.205) (layer \"F.Fab\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  "  (fp_line (start -16.73 17.255) (end -16.73 -16.205) (layer \"F.Fab\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  "  (fp_line (start 15.175 15.7) (end -15.175 15.7) (layer \"F.Fab\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  "  (fp_line (start -15.175 15.7) (end -15.175 -14.65) (layer \"F.Fab\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  "  (fp_line (start -15.175 -14.65) (end 14.175 -14.65) (layer \"F.Fab\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  "  (fp_line (start 15.175 -13.65) (end 15.175 15.7) (layer \"F.Fab\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  "  (fp_line (start 16.73 17.255) (end -16.73 17.255) (layer \"F.Fab\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  "  (fp_line (start 0 -16.475) (end -0.5 -17.475) (layer \"F.Fab\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  "  (fp_line (start 0.5 -17.475) (end 0 -16.475) (layer \"F.Fab\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  "  (fp_line (start 16.73 -16.205) (end 16.73 17.255) (layer \"F.Fab\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  "  (fp_line (start 14.175 -14.65) (end 15.175 -13.65) (layer \"F.Fab\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n");
}

/* 3d component selection */
// TODO create real 3d model for the plugs
static void kicad_mod_model(void)
{
	printf ("(model \"${KISYS3DMOD}/Package_LCC.3dshapes/PLCC-%d_SMD-Socket.wrl\"\n"
		"    (offset (xyz 0 0 0))\n"
		"    (scale (xyz 1 1 1))\n"
		"    (rotate (xyz 0 0 0))\n"
		"  )\n", COMPONENT_PINS);
}

static void kicad_mod_footer(void)
{
	printf(")\n");
}

// APW 9328 - 84pin --
//   A    B    C    D
//  36.6 27.5 36.6 27.6
static void pad(int n, double px, double py, double sx, double sy, int th)
{
	if (th) {
		/* Calculate drill hole offset for throughole pads */
		double ox, oy;
		if (sx > sy) {
			if (px < 0) {
				ox=(sx/4); oy=0;
			} else {
				ox=-(sx/4); oy=0;
			}
		} else {
			if (py < 0) {
				ox=0; oy=(sy/4);
			} else {
				ox=0; oy=-(sy/4);
			}
		}
		if (COMPONENT_VIA_OUTSIDE == 0) {
			ox *= -1;
			oy *= -1;
		}
		printf ("  (pad \"%d\" thru_hole rect (at %.3f %.3f) (locked) (size %.3f %.3f) ",
				n, px-ox, py-oy, sx, sy);
		printf ("(drill 0.3 (offset %.3f %.3f)) ", ox, oy);
		printf ("(layers \"*.Cu\" \"*.Mask\") ");
	} else {
		printf ("  (pad \"%d\" smd rect (at %.3f %.3f) (locked) (size %.3f %.3f) ",
			n, px, py, sx, sy);
		printf ("(layers \"F.Cu\" \"F.Paste\" \"F.Mask\") ");
	}
	printf ("(tstamp 00000000-0000-0000-0000-000000000000)");
	printf (")\n");
}

static void kicad_mod_pads(int throughhole)
{
	int i;

	double pitch = COMPONENT_PITCH;

	double a = COMPONENT_A;
	double b = COMPONENT_B;
	double c = COMPONENT_C;
	double d = COMPONENT_D;

	double pad_width = COMPONENT_PAD_WIDTH;
	double pad_length = (c - d) / 2;

	double pins_x = COMPONENT_PINS_X;
	double pins_y = COMPONENT_PINS_Y;
	double pins_width = pins_x * pitch;
	double pins_height = pins_y * pitch;

	double px, py, sx, sy;

	int cp[10];
	cp[0] = 1;
	cp[1] = cp[0] + (COMPONENT_PINS_X / 2);
	cp[2] = cp[1] + 1;
	cp[3] = cp[2] + (COMPONENT_PINS_Y - 1);
	cp[4] = cp[3] + 1;
	cp[5] = cp[4] + (COMPONENT_PINS_X - 1);
	cp[6] = cp[5] + 1;
	cp[7] = cp[6] + (COMPONENT_PINS_X - 1);
	cp[8] = cp[7] + 1;
	cp[9] = COMPONENT_PINS;

	// top 1
	sx = pad_width; sy = pad_length;
	px = 0;
	py = -(c-pad_length)/2;
	for (i=cp[0]; i<= cp[1]; i++) {
		pad(i, px, py, sx, sy, throughhole);
		px += pitch;
	}

	// right
	sx = pad_length; sy = pad_width;
	px = (a-pad_length)/2;
	py = -(pins_height- pitch)/2;
	for (i=cp[2]; i<= cp[3]; i++) {
		pad(i, px, py, sx, sy, throughhole);
		py += pitch;
	}

	// bottom
	sx = pad_width; sy = pad_length;
	px = (pins_width-pitch)/2;
	py = (c-pad_length) /2;
	for (i=cp[4]; i<= cp[5]; i++) {
		pad(i, px, py, sx, sy, throughhole);
		px -= pitch;
	}

	// left
	sx = pad_length; sy = pad_width;
	px = -(a-pad_length)/2;
	py = (pins_height-pitch) /2;
	for (i=cp[6]; i<= cp[7]; i++) {
		pad(i, px, py, sx, sy, throughhole);
		py -= pitch;
	}

	// top2
	sx = pad_width; sy = pad_length;
	px = -(pins_width-pitch)/2;
	py = -(c-pad_length)/2;
	for (i=cp[8]; i<= cp[9]; i++) {
		pad(i, px, py, sx, sy, throughhole);
		px += pitch;
	}
}

static void print_usage(const char *prog_name)
{
	printf("Usage: %s -p|--pins PINS [-o|--outfile FILE] [--double-sided] [--via-outside]\n", prog_name);
	printf("Generate KiCAD footprints for APW932x PLCC plugs\n\n");
	printf("Options:\n");
	printf("  -p, --pins PINS        Number of pins (20, 28, 32, 44, 52, 68, 84)\n");
	printf("  -o, --outfile FILE     Output file (default: stdout)\n");
	printf("  -d, --double-sided     Use double-sided pads with vias (default: enabled)\n");
	printf("  -s, --single-sided     Use single-sided SMD pads only\n");
	printf("  -v, --via-outside      Place vias outside the footprint (default: enabled)\n");
	printf("  --via-inside           Place vias inside the footprint\n");
	printf("  -h, --help            Show this help message\n");
}

int main(int argc, char *argv[])
{
	int opt;
	char *outfile = NULL;
	FILE *output = stdout;
	int pins_specified = 0;

	static struct option long_options[] = {
		{"pins", required_argument, 0, 'p'},
		{"outfile", required_argument, 0, 'o'},
		{"double-sided", no_argument, 0, 'd'},
		{"single-sided", no_argument, 0, 's'},
		{"via-outside", no_argument, 0, 'v'},
		{"via-inside", no_argument, 0, 'V'},
		{"help", no_argument, 0, 'h'},
		{0, 0, 0, 0}
	};

	while ((opt = getopt_long(argc, argv, "p:o:dsvVh", long_options, NULL)) != -1) {
		switch (opt) {
		case 'p':
			component_pins = atoi(optarg);
			current_config = get_config_for_pins(component_pins);
			if (!current_config) {
				fprintf(stderr, "Error: Unsupported pin count %d\n", component_pins);
				fprintf(stderr, "Supported pin counts: 20, 28, 32, 44, 52, 68, 84\n");
				return 1;
			}
			pins_specified = 1;
			break;
		case 'o':
			outfile = optarg;
			break;
		case 'd':
			component_throughhole = 1;
			break;
		case 's':
			component_throughhole = 0;
			break;
		case 'v':
			component_via_outside = 1;
			break;
		case 'V':
			component_via_outside = 0;
			break;
		case 'h':
			print_usage(argv[0]);
			return 0;
		default:
			print_usage(argv[0]);
			return 1;
		}
	}

	if (!pins_specified) {
		fprintf(stderr, "Error: --pins option is required\n");
		print_usage(argv[0]);
		return 1;
	}

	if (outfile) {
		output = fopen(outfile, "w");
		if (!output) {
			perror("Error opening output file");
			return 1;
		}
	}

	// Redirect printf to the output file
	FILE *old_stdout = stdout;
	stdout = output;

	kicad_mod_header();
	kicad_mod_texts(COMPONENT_A);
	kicad_mod_silkscreen("F.SilkS");
	kicad_mod_silkscreen("B.SilkS");
	kicad_mod_courtyard();
	kicad_mod_fabrication();
	kicad_mod_pads(COMPONENT_THROUGHHOLE);
	kicad_mod_model();
	kicad_mod_footer();

	// Restore stdout
	stdout = old_stdout;

	if (outfile && output != stdout) {
		fclose(output);
	}

	return 0;
}

