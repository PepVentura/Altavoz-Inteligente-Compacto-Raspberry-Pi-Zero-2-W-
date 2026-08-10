// =========================================================================
// CARCASA SMART SPEAKER: BRUJITA ENTRAÑABLE (RPI ZERO 2 W)
// Integración para Dayton DMA45-4 (Pecho), Neopixels (Ojos) y Sombrero Tapa
// =========================================================================

$fn = 60;

// --- Parámetros de componentes ---
speaker_d = 45.5;       // Diámetro cono Dayton DMA45-4
eye_led_d = 32.0;       // Diámetro exterior anillo Neopixel
wall = 3.5;             // Grosor paredes anti-resonancia

module brujita_completa() {
    difference() {
        union() {
            // 1. Cuerpo redondo / Vestido
            translate([0, 0, 40])
                scale([1.1, 1.0, 1.05])
                    sphere(r=45);

            // 2. Cabeza base
            translate([0, 0, 95])
                scale([1.15, 1.0, 0.95])
                    sphere(r=35);

            // 3. Mofletes entrañables
            for(side = [-1, 1]) {
                translate([side * 22, -26, 82])
                    sphere(r=14);
            }

            // 4. Salientes / Marcos de los Ojos para los Neopixel
            for(side = [-1, 1]) {
                translate([side * 18, -28, 98])
                    rotate([75, 0, side * -5])
                        cylinder(d=eye_led_d + 8, h=10, center=true);
            }

            // 5. Pelo rizado a los lados
            for(side = [-1, 1]) {
                translate([side * 36, -5, 92]) sphere(r=12);
                translate([side * 38, -15, 82]) sphere(r=10);
            }

            // 6. Nariz pequeña
            translate([0, -35, 90])
                sphere(r=4.5);
                
            // 7. Sombrero de Bruja (Parte fija/Cuello del sombrero)
            translate([0, 0, 120])
                cylinder(r1=38, r2=20, h=15);
        }

        // --- VACIADO INTERIOR (Cámara Acústica + Hueco Cabeza) ---
        translate([0, 0, 40])
            scale([1.1 - (wall/45), 1.0 - (wall/45), 1.05 - (wall/45)])
                sphere(r=45 - wall);

        translate([0, 0, 95])
            scale([1.15 - (wall/35), 1.0 - (wall/35), 0.95 - (wall/35)])
                sphere(r=35 - wall);

        // --- RECORTE FRONTALTAR: Altavoz DMA45-4 ---
        translate([0, -42, 35])
            rotate([90, 0, 0])
                cylinder(d=speaker_d, h=25, center=true);

        // --- RECORTE OJOS: Alojamientos Anillos Neopixel ---
        for(side = [-1, 1]) {
            translate([side * 18, -28, 98])
                rotate([75, 0, side * -5]) {
                    // Hueco para encastre del anillo LED
                    cylinder(d=eye_led_d, h=20, center=true);
                    // Agujero para pasar cables hacia el interior
                    cylinder(d=8, h=50, center=true);
                }
        }

        // --- APERTURA SUPERIOR (Para la tapa/sombrero y meter la Pi) ---
        translate([0, 0, 125])
            cylinder(r=28, h=30, center=true);

        // --- PUERTO USB DE ALIMENTACIÓN (En la parte trasera) ---
        translate([0, 40, 12])
            cube([14, 20, 8], center=true);
    }
}

// Módulo independiente: Sombrero Cónico (Tapa superior)
module sombrero_tapa() {
    translate([0, 0, 128]) {
        difference() {
            union() {
                // Ala del sombrero
                cylinder(r=46, h=3);
                // Copa puntiaguda inclinada
                rotate([-5, 5, 0])
                    cylinder(r1=27.5, r2=2, h=55);
            }
            // Encastre macho para encajar en el cuerpo
            translate([0, 0, -5])
                cylinder(r=27, h=6);
        }
    }
}

// Renderizar cuerpo principal
brujita_completa();

// Renderizar la tapa/sombrero (separado 80mm hacia un lado para ver ambos)
translate([90, 0, -120])
    sombrero_tapa();
