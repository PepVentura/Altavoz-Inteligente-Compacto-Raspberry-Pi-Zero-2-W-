// =========================================================================
// CARCASA BRUJITA SMART SPEAKER v2 (Optimizado para impresión 3D)
// =========================================================================

$fn = 80;

// Parámetros
speaker_d = 45.5;       // Diámetro Dayton DMA45-4
eye_led_d = 32.0;       // Anillo Neopixel
wall = 3.5;             // Grosor paredes

module brujita_cuerpo() {
    difference() {
        union() {
            // Base plana para asentar en la cama de impresión
            translate([0, 0, 2])
                cylinder(r=25, h=4, center=true);

            // Cuerpo / Vestido (Cámara acústica)
            translate([0, 0, 40])
                scale([1.1, 1.0, 1.05])
                    sphere(r=45);

            // Cabeza
            translate([0, 0, 95])
                scale([1.15, 1.0, 0.95])
                    sphere(r=35);

            // Mofletes
            for(side = [-1, 1]) {
                translate([side * 20, -26, 84])
                    sphere(r=13);
            }

            // Cuencas Ojos (Marcos Neopixel cerrados)
            for(side = [-1, 1]) {
                translate([side * 18, -25, 96])
                    rotate([75, 0, side * -5])
                        cylinder(d=eye_led_d + 6, h=10, center=true);
            }

            // Pelo rizado
            for(side = [-1, 1]) {
                translate([side * 35, -5, 92]) sphere(r=11);
                translate([side * 36, -15, 82]) sphere(r=9.5);
            }

            // Nariz
            translate([0, -34, 89])
                sphere(r=4);

            // Cuello de encastre del sombrero
            translate([0, 0, 120])
                cylinder(r1=36, r2=22, h=12);
        }

        // --- VACIADO INTERIOR (Cámara acústica estanca) ---
        translate([0, 0, 40])
            scale([1.1 - (wall/45), 1.0 - (wall/45), 1.05 - (wall/45)])
                sphere(r=45 - wall);

        translate([0, 0, 95])
            scale([1.15 - (wall/35), 1.0 - (wall/35), 0.95 - (wall/35)])
                sphere(r=35 - wall);

        // Aplanar la base por dentro
        translate([0, 0, -10])
            cube([100, 100, 20], center=true);

        // --- RECORTE FRONTALTAR: Altavoz DMA45-4 ---
        translate([0, -42, 35])
            rotate([90, 0, 0])
                cylinder(d=speaker_d, h=25, center=true);

        // --- RECORTE OJOS: Alojamiento ciego con paso de cables ---
        for(side = [-1, 1]) {
            translate([side * 18, -26, 96])
                rotate([75, 0, side * -5]) {
                    // Hueco Neopixel (Solo 6mm de fondo para no perforar la cara)
                    translate([0, 0, 2])
                        cylinder(d=eye_led_d, h=6, center=true);
                    // Paso de cables hacia la Pi (Agujero de 5mm)
                    cylinder(d=5, h=30, center=true);
                }
        }

        // --- APERTURA SUPERIOR (Tapa) ---
        translate([0, 0, 125])
            cylinder(r=26, h=25, center=true);

        // --- PUERTO USB DE ALIMENTACIÓN ---
        translate([0, 42, 8])
            cube([14, 20, 8], center=true);
    }
}

// Tapa Sombrero con pliegue orgánico
module sombrero_tapa() {
    translate([0, 0, 0]) {
        difference() {
            union() {
                // Ala con caída suave
                scale([1, 1, 0.25])
                    sphere(r=52);

                // Copa curva
                translate([0, 0, 5])
                    rotate([-8, 6, 0])
                        cylinder(r1=25.5, r2=2, h=58);
            }

            // Encastre macho inferior
            translate([0, 0, -15])
                cylinder(r=25, h=20);

            // Aplanar la parte inferior del ala
            translate([0, 0, -25])
                cube([150, 150, 40], center=true);
        }
    }
}

// Visualización en OpenSCAD
brujita_cuerpo();

// Mover sombrero a un lado para exportar STL por separado
translate([100, 0, 0])
    sombrero_tapa();
