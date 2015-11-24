/**********************************************************************
* Taller de Assembler
* Proyecto 2
* Ma. Belen Hernandez
* Daniela I. Pocasangre A.
* r0 - r3 : Parametros de entrada y salida
* anim.s
**********************************************************************/

.section .text

.globl jugarBoss
jugarBoss:

.macro verificar direccion
    mov r0, \direccion 
    bl KeyWasDown
.endm

    push {r4-r11, lr}

    paso_actual .req r4
    x .req r5
    y .req r6
    
    mov paso_actual, #0
    mov x, #208
    mov y, #600
    add y, #14

    loopContinue$:

        // -----------------------------
        // dibujar primera imagen
        ldr r0, =direccionPersonaje1
        ldr r0, [r0]
        mov r1, x
        mov r2, y
        bl drawImageWithTransparency2
        // -----------------------------

        // *******************************
        // 1 - revisar teclas
        // *******************************
        Revision:
            bl KeyboardUpdate
            bl KeyboardGetChar

            // -----------------------------
            // revisar teclas de flechas (si estan presionadas)
            //  para mover continuamente
            // -----------------------------
            cmp r0, #'e'
            beq finAnimacion //si se presiona esc, se sale del juego
            verificar #79 
            cmp r0, #0
            bne moverPersonajeDer
            verificar #80
            cmp r0, #0
            bne moverPersonajeIzq
            verificar #81
            cmp r0, #0
            bne moverPersonajeDown
            verificar #82
            cmp r0, #0
            bne moverPersonajeUp

            b Revision

    moverPersonajeDer:

        // borrar 5px de ancho
        mov r0, x
        mov r1, y
        mov r2, #5
        ldr r3, =direccionPersonaje1
        ldr r3, [r3]
        ldrh r3,[r3]
        bl DrawBackgroundRectangle2

        // sumar 5px a la posicion en x
        add x, #5
        mov r3, #5
        b continuarAnimacion$

    moverPersonajeIzq:
        
        // borrar 5px de ancho
        ldr r0, =direccionPersonaje4
        ldr r0, [r0]
        ldrh r0, [r0]
        add r0, x, r0
        sub r0, #5
        mov r1, y
        mov r2, #5
        ldr r3, =direccionPersonaje1
        ldr r3, [r3]
        ldrh r3,[r3]
        bl DrawBackgroundRectangle2

        // sumar 5px a la posicion en x
        sub x, #5
        mov r3, #4
        b continuarAnimacion$

    moverPersonajeDown:

        // borrar 5px de alto
        mov r0, x
        mov r1, y
        ldr r2, =direccionPersonaje4
        ldr r2, [r2]
        ldrh r2,[r2]
        mov r3, #5
        bl DrawBackgroundRectangle2

        // sumar 5px a la posicion en y
        add y, #5

        ldr r0, =direccionPersonaje3
        ldr r0, [r0]
        mov r1, x
        mov r2, y
        mov r3, #5
       /*bl Choque
        cmp r3, #7
        subeq r2, #5
        subeq y, #5
        bl drawImageWithTransparency2
        mov r0, x
        mov r1, y
        bl OnObject
        cmp r0, #1
        beq finAnimacion*/

        ldr r0, =10000
        //bl Wait
        b Revision

    moverPersonajeUp:
        // borrar 5px de alto
        mov r0, x
        ldr r1, =direccionPersonaje1
        ldr r1, [r1]
        ldrh r1, [r1]
        add r1, y, r1
        sub r1, #5
        ldr r2, =direccionPersonaje4
        ldr r2, [r2]
        ldrh r2,[r2]
        mov r3, #5
        bl DrawBackgroundRectangle2

        // restar 5px a la posicion en y
        sub y, #5

        ldr r0, =direccionPersonaje3
        ldr r0, [r0]
        mov r1, x
        mov r2, y
        mov r3, #4
        /*bl Choque
        cmp r3, #6
        addeq r2, #5
        addeq y, #5
        bl drawImageWithTransparency2
        mov r0, x
        mov r1, y
        bl OnObject
        cmp r0, #1
        beq finAnimacion*/

        ldr r0, =10000
        //bl Wait

        b Revision


    continuarAnimacion$:

        // *******************************
        // 3 - actualizar paso
        // *******************************
        add paso_actual, #1
        cmp paso_actual, #3
        moveq paso_actual, #0

        // *******************************
        // 4 - actualizar al personaje
        // *******************************
        cmp paso_actual, #0
        ldreq r0,=direccionPersonaje1
        ldreq r0, [r0]
        cmp paso_actual, #1
        ldreq r0,=direccionPersonaje2
        ldreq r0, [r0]
        cmp paso_actual, #2
        ldreq r0,=direccionPersonaje3
        ldreq r0, [r0]
        mov r1, x
        mov r2, y
        /*bl Choque //revisa si el personaje se choco
        cmp r3, #6 //si se sumo 2 a r3 y este era 4, iba a la izquierda
        addeq r1, #5
        addeq x, #5
        push {r3}
        bleq drawImageWithTransparency2
        pop {r3}
        cmp r3, #7 //si se sumo 2 a r3 y este era 5, iba a la derecha
        subeq r1, #5
        subeq x, #5
        push {r3}
        bleq drawImageWithTransparency2
        pop {r3}
        cmp r3, #4 //izquierda normal
        push {r3}
        bleq drawImageWithTransparency2
        pop {r3}
        cmp r3, #5 //derecha normal
        bleq drawImageWithTransparency2

        bl Vidas

        mov r0, x
        mov r1, y
        bl OnObject
        cmp r0, #1
        beq finAnimacion


        bl RevisarPush*/

        // *******************************
        // 5 - retardo
        // *******************************
        bl Buzz

        // *******************************

        b loopContinue$

    finAnimacion:

    // *******************************
    // 1 - borrar al personaje
    // *******************************
    mov r0, x
    mov r1, y
    ldr r2, =direccionPersonaje4
    ldr r2, [r2]
    ldrh r2,[r2]
    ldr r3, =direccionPersonaje1
    ldr r3, [r3]
    ldrh r3,[r3]
    bl DrawBackgroundRectangle2
    
    /*mov r12, #0
    ldr r11, =CantVidas
    str r12, [r11]*/

    pop {r4-r11, pc}
    .unreq paso_actual
    .unreq x
    .unreq y


    // ******************************************
// Subrutina para obtener el color del fondo
// en una posicion x,y
//    Asume color transparente como 1
// Entradas
// * r0 posicion x
// * r1 posicion y
// Salida:
// * salida el color en r0
// * (x + (y * ancho)) * tamanio pixel
// ******************************************
.globl GetBackgroundColor2
GetBackgroundColor2:
    push {r3, r4-r12, lr}
    
    mov r2, r0 //posicion en x
    mov r3, r1 //posicion en y

    ldr r5, =fondoHechicero

    pixel .req r5

    ldr r6, =1024
    mov r7, #2
    mul r4, r3, r6 //y * ancho
    add r3, r2, r4 //x + (y * ancho)
    mul r2, r3, r7 //*2

    ldrh r0, [pixel, r2] //obtiene color fondo

    //ldr r0, =0xF800

    pop {r3, r4-r12, pc}

    .unreq pixel

    // ******************************************
// Subrutina para dibujar un rectangulo con el
//    color del fondo
// Entradas:
//  * r0: x0
//  * r1: y0
//  * r2: ancho
//  * r3: alto
// ******************************************

.globl DrawBackgroundRectangle2
DrawBackgroundRectangle2:
    
    px .req r4
    py .req r5
    width  .req r6
    height .req r7
    x .req r8
    y .req r9

    push {r4-r9,r12,lr}
    
    mov px, r0
    mov py, r1
    mov width, r2
    mov height, r3

    mov x, #0
    mov y, #0

    loopLine$:
        add r0, px, x
        add r1, py, y
        bl GetBackgroundColor2
        bl SetForeColour

        add r0, px, x
        add r1, py, y
        bl DrawPixel
        
        add x, #1
        cmp x, width
        moveq x, #0
        addeq y, #1
        cmp y, height
        bne loopLine$
    pop {r4-r9,r12,pc}
    .unreq px
    .unreq py
    .unreq width
    .unreq height
    .unreq x
    .unreq y


// ******************************************
// Subrutina para dibujar una imagen. 
//    Utiliza DrawPixel y SetForeColour
//    Asume color transparente como 1
// Entradas:
// * r0 direccion del personaje
//     * [r0+0] alto del personaje
//     * [r0+2] ancho del personaje
//     * [r0+4] primer pixel del personaje
// * r1 posicion x
// * r2 posicion y
// * no tiene salidas
// ******************************************
.globl drawImageWithTransparency2
drawImageWithTransparency2:
    
    addr        .req r4
    x           .req r5
    y           .req r6
    height      .req r7
    width       .req r8
    conth       .req r9
    contw       .req r10
    
    push {r4,r5,r6,r7,r8,r9,r10,r12,lr}
    
    mov addr, r0
    mov x, r1
    mov y, r2
    mov conth, #0
    mov contw, #0

    ldrh height, [addr]
    add addr,#2
    ldrh width, [addr]
    add addr,#2
    
characterLoop$:
    ldrh r0, [addr]
    ldrh r1, =0     // validar transparencia
    cmp r0,r1
    addeq r0, x, contw  // calcular posicion x,y
    addeq r1, y, conth
    bleq GetBackgroundColor2
    bl SetForeColour
    
    add r0, x, contw
    add r1, y, conth
    bl DrawPixel
    add contw, #1
    cmp contw, width
    moveq contw, #0
    addeq conth, #1
    cmp conth, height
    popeq {r4,r5,r6,r7,r8,r9,r10,r12,pc}
    add addr, #2
    b characterLoop$
    
    .unreq addr
    .unreq x
    .unreq y
    .unreq height
    .unreq width
    .unreq conth
    .unreq contw

