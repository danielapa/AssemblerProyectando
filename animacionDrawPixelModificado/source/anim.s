
.section .text



// ******************************************
// Subrutina para iniciar la animacion del personaje.
//     Anima un personaje hasta que se presione la tecla "Q" o "q"
// * No recibe parametros
// * No tiene salidas
// ******************************************
.globl Animacion
Animacion:
    push {lr, r4-r11}

    paso_actual .req r4
    x .req r5
    y .req r6
    
    mov paso_actual, #0
    mov x, #200
    mov y, #200

    // -----------------------------
    // dibujar primera imagen
    ldr r0, =p1_1Height
    mov r1, x
    mov r2, y
    bl drawImageWithTransparency
    // -----------------------------
    


    loopContinue$:

        // *******************************
        // 1 - revisar teclas
        // *******************************
        bl KeyboardUpdate
        bl KeyboardGetChar

        // -----------------------------
        // revisar tecla para salir (q, Q, f, F)
        // -----------------------------
        teq r0,#'q'
        teqne r0,#'Q'
        teqne r0,#'f'
        teqne r0,#'F'
        beq finAnimacion
        
        // -----------------------------
        // revisar tecla para moverse
        // -----------------------------
        teq r0,#'m'
        teqne r0,#'M'
        beq moverPersonaje

        // -----------------------------
        // revisar tecla l (si esta presionada)
        //  para mover continuamente
        // -----------------------------
        mov r0, #15 //(tecla l o L)
        bl KeyWasDown
        cmp r0, #0
        bne moverPersonaje


        b continuarAnimacion$

    moverPersonaje:
        // borrar 5px de ancho
        mov r0, x
        mov r1, y
        mov r2, #5
        ldr r3, =p1_1Height
        ldrh r3,[r3]
        bl DrawBackgroundRectangle

        // sumar 5px a la posicion en x
        add x, #5
        b continuarAnimacion$



    continuarAnimacion$:
        // *******************************
        // 2 - borrar al personaje
        // *******************************
        // ESTE PASO YA NO ES NECESARIO YA QUE LE
        // CAEMOS ENCIMA AL PERSONAJE
        

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
        ldreq r0,=p1_1Height
        cmp paso_actual, #1
        ldreq r0,=p1_2Height
        cmp paso_actual, #2
        ldreq r0,=p1_3Height
        mov r1, x
        mov r2, y
        bl drawImageWithTransparency


        // *******************************
        // 5 - retardo
        // *******************************
        ldr r0, =50000
        bl Wait

        // *******************************

        b loopContinue$

    finAnimacion:

    // *******************************
    // 1 - borrar al personaje
    // *******************************
    mov r0, x
    mov r1, y
    ldr r2, =p1_1Width
    ldrh r2,[r2]
    ldr r3, =p1_1Height
    ldrh r3,[r3]
    bl DrawBackgroundRectangle
    


    pop {pc, r4-r11}
    .unreq paso_actual
    .unreq x
    .unreq y



// ******************************************
// Subrutina para dibujar un rectangulo con el
//    color del fondo
//  * r0: x0
//  * r1: y0
//  * r2: ancho
//  * r3: alto
// ******************************************
.globl DrawBackgroundRectangle
DrawBackgroundRectangle:
    
    px .req r4
    py .req r5
    width  .req r6
    height .req r7
    x .req r8
    y .req r9

    push {r4-r9,lr}
    
    mov px, r0
    mov py, r1
    mov width, r2
    mov height, r3

    mov x, #0
    mov y, #0

    loopLine$:
        add r0, px, x
        add r1, py, y
        bl GetBackgroundColor
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
    pop {r4-r9,pc}
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
// * r0 direccion del personaje
//     * [r0+0] alto del personaje
//     * [r0+2] ancho del personaje
//     * [r0+4] primer pixel del personaje
// * r1 posicion x
// * r2 posicion y
// * no tiene salidas
// ******************************************
.globl drawImageWithTransparency
drawImageWithTransparency:
    
    addr        .req r4
    x           .req r5
    y           .req r6
    height      .req r7
    width       .req r8
    conth       .req r9
    contw       .req r10
    
    push {r4,r5,r6,r7,r8,r9,r10,lr}
    
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
    bleq GetBackgroundColor
    bl SetForeColour
    
    add r0, x, contw
    add r1, y, conth
    bl DrawPixel
    add contw, #1
    cmp contw, width
    moveq contw, #0
    addeq conth, #1
    cmp conth, height
    popeq {r4,r5,r6,r7,r8,r9,r10,pc}
    add addr, #2
    b characterLoop$
    
    .unreq addr
    .unreq x
    .unreq y
    .unreq height
    .unreq width
    .unreq conth
    .unreq contw



// ******************************************
// Subrutina para obtener el color del fondo
// en una posicion x,y
//    Asume color transparente como 1
// * r0 posicion x
// * r1 posicion y
// * salida el color en r0
// ******************************************
.globl GetBackgroundColor
GetBackgroundColor:
    push {lr}
    
    mov r2,r0 //posicion en x
    mov r3,r1 //posicion en y

    ldr r0,=fondo


    //ldr r0, =0xF800
    pop {pc}



// ******************************************
// Subrutina para dibujar una imagen. 
//    Utiliza DrawPixel y SetForeColour
//    Asume color transparente como 1
// * r0 direccion del personaje
//     * [r0+0] alto del personaje
//     * [r0+2] ancho del personaje
//     * [r0+4] primer pixel del personaje
// * r1 posicion x
// * r2 posicion y
// * no tiene salidas
// ******************************************
.globl removeImageWithBlack
removeImageWithBlack:
    
    addr        .req r4
    x           .req r5
    y           .req r6
    height      .req r7
    width       .req r8
    conth       .req r9
    contw       .req r10
    
    push {r4,r5,r6,r7,r8,r9,r10,lr}
    
    mov addr, r0
    mov x, r1
    mov y, r2
    mov conth, #0
    mov contw, #0

    ldrh height, [addr]
    add addr,#2
    ldrh width, [addr]
    add addr,#2
    
characterLoopBlack$:
    ldrh r0, [addr]
    ldrh r1, =1     // validar transparencia
    ldrh r0, =0     // color de fondo
    cmp r0,r1
    beq noDrawBlack$
    bl SetForeColour
    
    add r0, x, contw
    add r1, y, conth
    bl DrawPixel
noDrawBlack$:
    add contw, #1
    cmp contw, width
    moveq contw, #0
    addeq conth, #1
    cmp conth, height
    popeq {r4,r5,r6,r7,r8,r9,r10,pc}
    add addr, #2
    b characterLoopBlack$
    
    .unreq addr
    .unreq x
    .unreq y
    .unreq height
    .unreq width
    .unreq conth
    .unreq contw