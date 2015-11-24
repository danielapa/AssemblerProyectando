
/*************************************************************************************************************************** 
 *                                                  COMENTANDO PARA PROBAR SI ESTA COSA SIRVEEE
 *                                                  *******************************************
 **********************************************
 **************************************************
 **********************************************
 *************************************************************************************
 * KSNKLAL;DAL;FDKZSFGAS;L
 ******************************
 ****************************
 ********************************************
 *HOLIIIIIIIIIIIIIIIIIIIISSSSSS*
 *
 **********************
 * ASDLFLSKDMF;LSDF**
 *
 *******************************
 *BLAJ*******************
 ****************************************
 **********************************************************************************************************************************
 *
 */


 
/**********************************************************************
* Taller de Assembler
* Proyecto 2
* Ma. Belen Hernandez
* Daniela I. Pocasangre A.
* 
* juego.s
**********************************************************************/

/**********************************************************************
* Inicio del juego
***********************************************************************/
.globl juego
juego:
	push {lr}

	ldr r0, =pantallaInicioHeight 
	mov r1,#0
	mov r2,#0

	bl drawImageWithTransparency

drawingBG:
	bl KeyboardUpdate
    bl KeyboardGetChar

    teq r0, #'s' //revisa si se inicia el juego
    bne drawingBG

    bleq escogiendo //si se presiona s, empieza el juego

	pop {lr}
	mov pc, lr

/**********************************************************************
* Escogiendo personaje
***********************************************************************/
.globl escogiendo
escogiendo:
	push {lr}

    ldr r0, =pantallaSeleccionHeight
    mov r1,#0
    mov r2,#0
    bl drawImageWithTransparency

again:
	bl KeyboardUpdate //se revisa que personaje es escogido
    bl KeyboardGetChar

    teq r0, #'b' //personaje1 - verde
    ldreq r0, =p1_1Height
    ldreq r5, =direccionPersonaje1 //guarda en memoria los sprites del personaje
    streq r0, [r5]
    ldreq r0, =p1_2Height
    ldreq r5, =direccionPersonaje2
    streq r0, [r5]
    ldreq r0, =p1_3Height
    ldreq r5, =direccionPersonaje3
    streq r0, [r5]  
    ldreq r0, =p1_1Width
    ldreq r5, =direccionPersonaje4
    streq r0, [r5]                 
    beq regreso

    teq r0, #'n' //personaje2 - azul
    ldreq r0, =p2_1Height
    ldreq r5, =direccionPersonaje1 //guarda en memoria los sprites del personaje
    streq r0, [r5]
    ldreq r0, =p2_2Height
    ldreq r5, =direccionPersonaje2
    streq r0, [r5]
    ldreq r0, =p2_3Height
    ldreq r5, =direccionPersonaje3
    streq r0, [r5]  
    ldreq r0, =p2_1Width
    ldreq r5, =direccionPersonaje4
    streq r0, [r5]       
    beq regreso

    teq r0, #'m' //personaje3 - rosado
    ldreq r0, =p3_1Height
    ldreq r5, =direccionPersonaje1 //guarda en memoria los sprites del personaje
    streq r0, [r5]
    ldreq r0, =p3_2Height
    ldreq r5, =direccionPersonaje2
    streq r0, [r5]
    ldreq r0, =p3_3Height
    ldreq r5, =direccionPersonaje3
    streq r0, [r5] 
    ldreq r0, =p3_1Width
    ldreq r5, =direccionPersonaje4
    streq r0, [r5]      
    bne again

regreso:
	bl laberinto //si se escogio personaje, se va al laberinto
	pop {lr}
	mov pc, lr

//**********************************************************************
// * Laberinto
//***********************************************************************/
.globl laberinto
laberinto:
	push {r4-r11, lr}

    /*ldr r0, =bgHeight //inicia laberinto de fondo y personaje en el inicio
    mov r1,#0
    mov r2,#0

    bl drawImageWithTransparency*/

	ldr r0, =nivel1Height //inicia laberinto de fondo y personaje en el inicio
	mov r1,#0
	mov r2,#0

	bl drawImageWithTransparency

    //****************
    // * BLOQUES
    //****************

    ldr r0, =blueLockHeight
    mov r1,#199
    mov r2,#49
    bl PaintingBG

	ldr r0, =blueLockHeight
	mov r1,#199
	mov r2,#49
	bl drawImageWithTransparency

    ldr r0, =redLockHeight
    mov r1,#79
    mov r2,#400
    add r2,#73
    bl PaintingBG

    ldr r0, =redLockHeight
    mov r1,#79
    mov r2,#400
    add r2,#73
    bl drawImageWithTransparency

    ldr r0, =greenLockHeight
    mov r1,#700
    add r1,#83
    mov r2,#264
    bl PaintingBG

    ldr r0, =greenLockHeight
    mov r1,#700
    add r1,#83
    mov r2,#264
    bl drawImageWithTransparency

    ldr r0, =yellowLockHeight
    mov r1,#900
    add r1, #50
    mov r2,#628
    bl PaintingBG

    ldr r0, =yellowLockHeight
    mov r1,#900
    add r1, #50
    mov r2,#628
    bl drawImageWithTransparency

    //****************
    // * LLAVES
    //****************

    ldr r0, =blueKeyHeight
    mov r1,#500
    add r1,#54
    mov r2,#300
    add r2,#54
    bl drawImageWithTransparency

    ldr r0, =redKeyHeight
    mov r1,#800
    add r1,#77
    mov r2,#200
    add r2,#61
    bl drawImageWithTransparency

    ldr r0, =greenKeyHeight
    mov r1,#400
    add r1,#67
    mov r2,#632
    bl drawImageWithTransparency

    ldr r0, =yellowKeyHeight
    mov r1,#80
    mov r2,#388
    bl drawImageWithTransparency

    //****************
    // * VIDAS
    //****************

    ldr r0, =heartEmptyHeight
    mov r1, #700
    mov r2, #50
    bl PaintingBG

    ldr r0, =heartFullHeight
    mov r1, #700
    mov r2, #50
    bl drawImageWithTransparency

    ldr r0, =heartEmptyHeight
    mov r1, #800
    mov r2, #50
    bl PaintingBG

    ldr r0, =heartFullHeight
    mov r1, #800
    mov r2, #50
    bl drawImageWithTransparency

    ldr r0, =heartEmptyHeight
    mov r1, #900
    mov r2, #50
    bl PaintingBG

    ldr r0, =heartFullHeight
    mov r1, #900
    mov r2, #50
    bl drawImageWithTransparency          

//inicia ciclo laberinto

    bl jugarLaberinto
//AQUI VA EL CODIGO QUE MANDA A MOVER PERSONAJE DEPENDIENDO DE (X,Y) Y TODO LO QUE VA DENTRO DEL FUNCIONAMIENTO DEL LABERINTO
//SE ME OCURRIA HACER SUBRUTINAS PARA: MOVER, DISPAROS, CHOQUE, ENEMIGOS

	pop {r4-r11, lr}
	mov pc, lr

.section .data
.align 2

.globl direccionPersonaje1
    direccionPersonaje1: .word 0
.globl direccionPersonaje2
    direccionPersonaje2: .word 0
.globl direccionPersonaje3
    direccionPersonaje3: .word 0
.globl direccionPersonaje4
    direccionPersonaje4: .word 0
