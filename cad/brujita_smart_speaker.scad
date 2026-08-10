// =========================================================================
// CARCASA BRUJITA SMART SPEAKER v3 (Geometría Maciza + Paredes Selladas)
// =========================================================================

$fn = 80;

// Parámetros clave
speaker_d = 45.5;       // Diámetro Dayton DMA45-4
eye_led_d = 32.0;       // Diámetro Neopixel WS2812B
wall = 3.5;             // Grosor pared cámara acústica

// -------------------------------------------------------------------------
// 1. VOLUMEN EXTERIOR SÓLIDO (Sin vaciar)
// -------------------------------------------------------------------------
module exterior_solido() {
    // Base aplanada para impresión
    translate([0, 0, 2])
        cylinder(r=25, h=4, center=true);

    // Cuerpo / Vestido
    translate([0, 0, 40])
        scale([1.1, 1.0, 1.05])
            sphere(r=45);

    // Cabeza
    translate([0, 0, 95])
        scale([1.15, 1.0, 0.95])
            sphere(r=35);

    // Mofletes
    for(side = [-1, 1]) {
        translate([side * 18, -24, 85])
            sphere(r=13);
    }

    // Cuencas / Marcos destacados para los Ojos Neopixel
    for(side = [-1, 1]) {
        translate([side * 18, -25, 96])
            rotate([75, 0, side * -5])
                cylinder(d=eye_led_d + 8, h=12, center=true);
    }

    // Pelo rizado lateral
    for(side = [-1, 1]) {
        translate([side * 34, -5, 92]) sphere(r=11);
        translate([side * 35, -15, 82]) sphere(r=9.5);
    }

    // Nariz pequeña
    translate([0, -34, 89])
        sphere(r=4);

    // Cuello de encastre del sombrero
    translate([0, 0, 118])
        cylinder(r1=36, r2=24, h=12);
}

// -------------------------------------------------------------------------
// 2. CUERPO PRINCIPAL CON RECORES (Diferencia limpia)
// -------------------------------------------------------------------------
module brujita_cuerpo() {
    difference() {
        // Objeto base macizo
        exterior_solido();

        // --- VACIADO CÁMARA INTERIOR ESTANCA ---
        translate([0, 0, 40])
            scale([1.1 - (wall/45), 1.0 - (wall/45), 1.05 - (wall/45)])
                sphere(r=45 - wall);

        translate([0, 0, 95])
            scale([1.15 - (wall/35), 1.0 - (wall/35), 0.95 - (wall/35)])
                sphere(r=35 - wall);

        // Aplanar plano de la base por abajo
        translate([0, 0, -10])
            cube([120, 120, 20], center=true);

        // --- HUECO ALTAVOZ DAYTON DMA45-4 (FRONTAL) ---
        translate([0, -42, 35])
            rotate([90, 0, 0])
                cylinder(d=speaker_d, h=30, center=true);

        // --- ALOJAMIENTOS DE OJOS (CIEGOS CON FONDO) ---
        for(side = [-1, 1]) {
            translate([side * 18, -25, 96])
                rotate([75, 0, side * -5]) {
                    // Cajeado para insertar el anillo Neopixel (Solo 5mm de profundidad)
                    translate([0, 0, 3])
                        cylinder(d=eye_led_d, h=6, center=true);
                    
                    // Pequeño taladro central de 4mm para pasar únicamente los 3 cables (5V, GND, DATA)
                    cylinder(d=4, h=30, center=true);
                }
        }

        // --- BOCA DE ENTRADA SUPERIOR (Acceso a la Pi Zero 2 W) ---
        translate([0, 0, 122])
            cylinder(r=24, h=20, center=true);

        // --- PUERTO USB DE ALIMENTACIÓN (TRASERÍA) ---
        translate([0, 42, 8])
            cube([14, 20, 8], center=true);
    }
}

// -------------------------------------------------------------------------
// 3. TAPA SUPERIOR (Sombrero de Bruja Orgánico)
// -------------------------------------------------------------------------
module sombrero_tapa() {
    difference() {
        union() {
            // Ala con curva/caída suave
            scale([1, 1, 0.28])
                sphere(r=50);

            // Copa del sombrero con leve inclinación/pliegue
            translate([0, 0, 4])
                rotate([-7, 5, 0])
                    cylinder(r1=24, r2=2, h=55);
        }

        // Encastre macho inferior para encajar a presión en el cuello
        translate([0, 0, -18])
            cylinder(r=23.5, h=20);

        // Base plana del sombrero
        translate([0, 0, -20])
            cube([150, 150, 40], center=true);
    }
}

// Visualización en pantalla
brujita_cuerpo();

// Mover sombrero a un lado (X=90mm) para previsualizar/exportar por separado
translate([90, 0, 0])
    sombrero_tapa();
