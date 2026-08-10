// =========================================================================
// CARCASA SMART SPEAKER: BRUJITA ENTRAÑABLE (RPI ZERO 2 W)
// Integración para Dayton DMA45-4, Neopixels y MAX98357A
// =========================================================================

$fn = 80;

// --- Parámetros de Componentes ---
speaker_d = 45.5;       // Diámetro encastre Dayton DMA45-4
eye_led_d = 37.0;       // Diámetro exterior anillo Neopixel
wall = 3.2;             // Grosor paredes caja acústica

module brujita_base() {
    difference() {
        union() {
            // 1. Cuerpo redondo / Vestido (Cámara acústica)
            translate([0, 0, 40])
                scale([1.1, 1.0, 1.05])
                    sphere(r=45);

            // 2. Cabeza
            translate([0, 0, 90])
                scale([1.15, 1.0, 0.95])
                    sphere(r=35);
        }

        // --- Vaciado Interior (Cálculo volumen ~0.35L) ---
        translate([0, 0, 40])
            scale([1.1 - (wall/45), 1.0 - (wall/45), 1.05 - (wall/45)])
                sphere(r=45 - wall);

        translate([0, 0, 90])
            scale([1.15 - (wall/35), 1.0 - (wall/35), 0.95 - (wall/35)])
                sphere(r=35 - wall);

        // --- Recorte Frontal para Altavoz DMA45-4 ---
        translate([0, -42, 35])
            rotate([90, 0, 0])
                cylinder(d=speaker_d, h=20, center=true);

        // --- Recortes Ojos (Anillos LED + Lentes) ---
        for(side = [-1, 1]) {
            translate([side * 22, -32, 95])
                rotate([80, 0, side * -5])
                    cylinder(d=eye_led_d, h=15, center=true);
        }

        // --- Corte Superior para Tapa / Sombrero ---
        translate([0, 0, 118])
            cylinder(r=40, h=30, center=true);

        // --- Puerto USB-C / Micro-USB en la base ---
        translate([0, 0, 5])
            rotate([90, 0, 0])
                cube([12, 8, 20], center=true);
    }
}

// Ejecutar previsualización
brujita_base();
