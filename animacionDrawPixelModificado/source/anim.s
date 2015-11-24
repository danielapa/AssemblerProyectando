/**********************************************************************
* Taller de Assembler
* Proyecto 2
* Ma. Belen Hernandez
* Daniela I. Pocasangre A.
* r0 - r3 : Parametros de entrada y salida
* anim.s
**********************************************************************/

.section .text

// *********************************************************************
// Subrutina para iniciar la animacion del personaje.
//     Anima un personaje hasta que se presionen las teclas de flecha
// * No recibe parametros
// * No tiene salidas
// *********************************************************************
.globl jugarLaberinto
jugarLaberinto:

.macro verificar direccion
    mov r0, \direccion 
    bl KeyWasDown
.endm

    push {r4-r11, lr}

    paso_actual .req r4
    x .req r5
    y .req r6
    
    mov paso_actual, #0
    mov x, #65
    mov y, #45
    mov r12, #0

    loopContinue$:

        // -----------------------------
        // dibujar primera imagen
        ldr r0, =direccionPersonaje1
        ldr r0, [r0]
        mov r1, x
        mov r2, y
        bl drawImageWithTransparency
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
        bl DrawBackgroundRectangle

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
        bl DrawBackgroundRectangle

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
        bl DrawBackgroundRectangle

        // sumar 5px a la posicion en y
        add y, #5

        ldr r0, =direccionPersonaje3
        ldr r0, [r0]
        mov r1, x
        mov r2, y
        mov r3, #5
        bl Choque
        cmp r3, #7
        subeq r2, #5
        subeq y, #5
        bl drawImageWithTransparency
        mov r0, x
        mov r1, y
        bl OnObject
        ldr r0, =10000
        bl Wait
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
        bl DrawBackgroundRectangle

        // restar 5px a la posicion en y
        sub y, #5

        ldr r0, =direccionPersonaje3
        ldr r0, [r0]
        mov r1, x
        mov r2, y
        mov r3, #4
        bl Choque
        cmp r3, #6
        addeq r2, #5
        addeq y, #5
        bl drawImageWithTransparency
        mov r0, x
        mov r1, y
        bl OnObject
        ldr r0, =10000
        bl Wait

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
        bl Choque //revisa si el personaje se choco
        cmp r3, #6 //si se sumo 2 a r3 y este era 4, iba a la izquierda
        addeq r1, #5
        addeq x, #5
        push {r3}
        bleq drawImageWithTransparency
        pop {r3}
        cmp r3, #7 //si se sumo 2 a r3 y este era 5, iba a la derecha
        subeq r1, #5
        subeq x, #5
        push {r3}
        bleq drawImageWithTransparency
        pop {r3}
        cmp r3, #4 //izquierda normal
        push {r3}
        bleq drawImageWithTransparency
        pop {r3}
        cmp r3, #5 //derecha normal
        push {r3}
        bleq drawImageWithTransparency
        pop {r3}

        bl Vidas

        mov r0, x
        mov r1, y
        bl OnObject

        // *******************************
        // 5 - retardo
        // *******************************
        ldr r0, =20000
        bl Wait

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
    bl DrawBackgroundRectangle
    


    pop {r4-r11, pc}
    .unreq paso_actual
    .unreq x
    .unreq y

// ************************************************************************
// Subrutina para determinar si se choco el personaje con una pared
// Entradas:
// * r0 direccion del personaje
//     * [r0+0] alto del personaje
//     * [r0+2] ancho del personaje
// * r1 posicion x
// * r2 posicion y
// Salida:
// * r3 contador de lado choque
// ************************************************************************

//FONDO 53150

.globl Choque
Choque:
    push {r0, r1, r2, r4-r11, lr}
    
    ldr r4, =bg //color del fondo, donde debe de estar personaje
    ldrh r4, [r4]

    x           .req r5
    y           .req r6
    height      .req r7
    width       .req r8
    conth       .req r9
    contw       .req r10
        
    ldrh height, [r0]
    add r0, #2
    ldrh width, [r0]

    mov x, r1
    mov y, r2
    mov conth, #0
    mov contw, #0

characterLoopC$:
    add r0, x, contw
    add r1, y, conth

    bl GetBackgroundColor

    ldr r1, =ColorAzul
    ldrh r1, [r1]

    mov r11, r0

    cmp r0, r1
    moveq r1, #1 
    ldreq r4, =bg //color del fondo, donde debe de estar personaje
    ldreqh r11, [r4]     

    cmp r11, r4 //compara color de fondo con azul
    addne r3, #2 //si no es igual, se choco
    addne r12, #1
    popne {r0, r1, r2, r4-r11, pc}

    add contw, #1
    cmp contw, width
    moveq contw, #0
    addeq conth, #1
    cmp conth, height
    popeq {r0, r1, r2, r4-r12, pc} //se ha terminado de revisar y no hay choques
    b characterLoopC$

    .unreq x
    .unreq y
    .unreq height
    .unreq width
    .unreq conth
    .unreq contw      

// **********************************************************************
// Subrutina para determinar si el personaje se choco y pierde una vida
// Entradas:
// * r3 - numero de choque
//
// Salida:
// * no tiene
// **********************************************************************

.globl Vidas
Vidas:
    push {r4-r12, lr}

    mov r7, r12

    cmp r7, #1 //choco
    addeq r12, #1
    moveq r0, #700 //x
    moveq r1, #50  //y
    ldreq r3, =heartFullHeight
    ldreq r2, =heartFullWidth
    ldreq r2, [r2]
    ldreq r3, [r3]
    beq borrar

    cmp r7, #2 //choco
    addeq r12, #1
    moveq r0, #800 //x
    moveq r1, #50  //y
    ldreq r3, =heartFullHeight
    ldreq r2, =heartFullWidth
    ldreq r2, [r2]
    ldreq r3, [r3]
    beq borrar

    cmp r7, #3 //choco
    addeq r12, #1
    moveq r0, #900 //x
    moveq r1, #50  //y
    ldreq r3, =heartFullHeight
    ldreq r2, =heartFullWidth
    ldreq r2, [r2]
    ldreq r3, [r3]    

borrar:
    bleq DrawBackgroundRectangle

    pop {r4-r12, lr}

// **********************************************************************
// Subrutina para determinar si el personaje se encuentra sobre una Llave
// o en la salida
// Entradas:
// * r0 - posicion en x
// * r1 - posicion en y
// Salida:
// * no tiene
// **********************************************************************

.globl OnObject
OnObject:
    .macro revisando xi, yi, xf, yf
    cmp x, \xi
    addge ok, #1
    cmp x, \xf
    addle ok, #1
    cmp y, \yi
    addge ok, #1
    cmp y, \yf
    addle ok, #1
    //De cumplirse las 4 condiciones, ok=4
    .endm

    xi .req r2   //posicion inicial en x
    yi .req r3   //posicion incial en y
    xf .req r4   //posicion final en x
    yf .req r5   //posicion final en y
    x .req r6    //posicion en x del personaje
    y .req r7    //posicion en y del personaje
    ok .req r8   //registro de verificacion
    done .req r9 //registro que determina si termino el juego

    push {r2-r12,lr}

    mov x, r0
    mov y, r1
    add x, #36 //centro en x
    add y, #48 //centro en y
    mov done, #0

    //LLAVE AZUL
    mov ok, #0
    mov xi,#500
    add xi,#54
    mov yi,#300
    add yi,#54
    add xf, xi, #70 
    add yf, yi, #70
    revisando xi, yi, xf, yf

    cmp ok, #4
    ldreq r0, =blueLockHeight
    moveq r1,#199
    moveq r2,#49
    bleq PaintingBGBlue
    addeq done, #1

    //LLAVE VERDE
    mov ok, #0
    mov xi,#400
    add xi,#67 
    mov yi,#632 
    add xf, xi, #70 
    add yf, yi, #70
    revisando xi, yi, xf, yf

    cmp ok, #4
    ldreq r0, =greenLockHeight
    moveq r1,#700
    addeq r1,#83
    moveq r2,#264
    bleq PaintingBGBlue
    addeq done, #1

    //LLAVE ROJA
    mov ok, #0
    mov xi,#800
    add xi,#77 
    mov yi,#200
    add yi,#61
    add xf, xi, #70 
    add yf, yi, #70
    revisando xi, yi, xf, yf
    addeq done, #1

    cmp ok, #4
    ldreq r0, =redLockHeight
    moveq r1,#79
    moveq r2,#400
    addeq r2,#73
    bleq PaintingBGBlue
    

    //LLAVE AMARILLA
    mov ok, #0
    mov xi,#80
    mov yi,#388
    add xf, xi, #70 
    add yf, yi, #70
    revisando xi, yi, xf, yf

    cmp ok, #4
    ldreq r0, =yellowLockHeight
    moveq r1,#900
    addeq r1, #50
    moveq r2,#628
    bleq PaintingBGBlue
    addeq done, #1

    //SALIDA - NO FUNCIONA
    cmp done, #4 //Done=4 cuando los 4 candados fueron abiertos

    ldreq r0, =heartFullHeight
    moveq r1, #500                      //SE DIBUJA UN CUARTO CORAZON COMO PRUEBA
    moveq r2, #50                       //AQUI DEBERIA PINTARSE EL FONDO DEL MAGO
    bleq drawImageWithTransparency    

    pop {r2-r12,pc}

    .unreq xi
    .unreq yi
    .unreq xf
    .unreq yf
    .unreq x
    .unreq y
    .unreq ok

// *****************************************************************************************
// Subrutina para pintar un espacio de color de un  objeto
// Entradas:
// * r0 direccion del personaje
//     * [r0+0] alto del personaje
//     * [r0+2] ancho del personaje
//     * [r0+4] primer pixel del personaje
// * r1 posicion x
// * r2 posicion y
// Salida:
// * no tiene
// *****************************************************************************************

.globl PaintingBG
PaintingBG:
    addr        .req r4
    x           .req r5
    y           .req r6
    height      .req r7
    width       .req r8
    conth       .req r9
    contw       .req r10
    
    push {r4,r5,r6,r7,r8,r9,r10,r11, r12, lr}
    
    mov addr, r0
    mov x, r1
    mov y, r2
    mov conth, #0
    mov contw, #0

    ldrh height, [addr]
    add addr,#2
    ldrh width, [addr]
    add addr,#2
    
BGLoop$:
    ldrh r2, [addr]

    ldrh r11, =0     // validar transparencia
    cmp r2, r11

    addne r0, x, contw
    addne r1, y, conth

    blne StoreColour

    add contw, #1
    cmp contw, width
    moveq contw, #0
    addeq conth, #1
    cmp conth, height
    popeq {r4,r5,r6,r7,r8,r9,r10,r11, r12, pc}
    add addr, #2
    b BGLoop$
    
    .unreq addr
    .unreq x
    .unreq y
    .unreq height
    .unreq width
    .unreq conth
    .unreq contw

// *****************************************************************************************
// Subrutina para pintar un espacio de color del fondo
// Entradas:
// * r0 direccion del personaje
//     * [r0+0] alto del personaje
//     * [r0+2] ancho del personaje
//     * [r0+4] primer pixel del personaje
// * r1 posicion x
// * r2 posicion y
// Salida:
// * no tiene
// *****************************************************************************************

.globl PaintingBGBlue
PaintingBGBlue:
    addr        .req r4
    x           .req r5
    y           .req r6
    height      .req r7
    width       .req r8
    conth       .req r9
    contw       .req r10
    
    push {r4,r5,r6,r7,r8,r9,r10,r11, r12, lr}
    
    mov addr, r0
    mov x, r1
    mov y, r2
    mov conth, #0
    mov contw, #0

    ldrh height, [addr]
    add addr,#2
    ldrh width, [addr]
    add addr,#2
    
BGLoopB$:
    ldr r2, =bg //color del fondo, donde debe de estar personaje
    ldrh r2, [r2]

    add r0, x, contw
    add r1, y, conth

    bl StoreColour

    add contw, #1
    cmp contw, width
    moveq contw, #0
    addeq conth, #1
    cmp conth, height
    popeq {r4,r5,r6,r7,r8,r9,r10,r11, r12, pc}
    add addr, #2
    b BGLoopB$
    
    .unreq addr
    .unreq x
    .unreq y
    .unreq height
    .unreq width
    .unreq conth
    .unreq contw

// ******************************************
// Subrutina para dibujar un rectangulo con el
//    color del fondo
// Entradas:
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
.globl drawImageWithTransparency
drawImageWithTransparency:
    
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
.globl GetBackgroundColor
GetBackgroundColor:
    push {r3, r4-r12, lr}
    
    mov r2, r0 //posicion en x
    mov r3, r1 //posicion en y

    ldr r5, =nivel1

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
// Subrutina para colocar color en fondo
// en una posicion x,y
// Entradas
// * r0 posicion x
// * r1 posicion y
// * r2 color
// Salida:
// * no tiene
// * (x + (y * ancho)) * tamanio pixel
// ******************************************
.globl StoreColour
StoreColour:
    push {r3, r4-r12, lr}
    
    mov r10, r2 //color a set
    mov r2, r0 //posicion en x
    mov r3, r1 //posicion en y

    ldr r5, =nivel1

    pixel .req r5

    ldr r6, =1024
    mov r7, #2
    mul r4, r3, r6 //y * ancho
    add r3, r2, r4 //x + (y * ancho)
    mul r2, r3, r7 //*2

    strh r10, [pixel, r2] //coloca color fondo

    pop {r3, r4-r12, pc}

    .unreq pixel

// ******************************************
// Subrutina para dibujar una imagen. 
//    Utiliza DrawPixel y SetForeColour
//    Asume color transparente como 1
// Entradas
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
    
    push {r4,r5,r6,r7,r8,r9,r10,r12, lr}
    
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
    popeq {r4,r5,r6,r7,r8,r9,r10,r12,pc}
    add addr, #2
    b characterLoopBlack$
    
    .unreq addr
    .unreq x
    .unreq y
    .unreq height
    .unreq width
    .unreq conth
    .unreq contw

.section .data
.align 2

.globl ColorAzul
    ColorAzul: .hword 53151

.globl LlaveRoja
    LlaveRoja: .word 0

.globl LlaveAzul
    LlaveAzul: .word 0

.globl LlaveAma
    LlaveAma: .word 0

.globl LlaveVert
    LlaveVert: .word 0
