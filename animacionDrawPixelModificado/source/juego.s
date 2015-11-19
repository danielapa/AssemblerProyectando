/**********************************************************************
* juego.s
* Proyecto 2
* Ma. Belen Hernandez
* Daniela I. Pocasangre A.
* 
**********************************************************************/

/**********************************************************************
* Inicio del juego
***********************************************************************/
.globl juego
juego:
	push {lr}

drawingBG:
	ldr r0, =fondoHeight
	mov r1,#0
	mov r2,#0

	bl drawImageWithTransparency

	bl KeyboardUpdate
    bl KeyboardGetChar

    teq r0, #'s' //revisa si se inicia el juego
    bne drawingBG

    bleq escogiendo

	pop {lr}
	mov pc, lr

/**********************************************************************
* Escogiendo personaje
***********************************************************************/
.globl escogiendo
escogiendo:
	push {lr}

again:
	bl KeyboardUpdate
    bl KeyboardGetChar

    teq r0, #'b' //personaje1
    ldreq r0, =p1_1Height
    ldreq r5, =direccionPersonaje1
    streq r0, [r5]
    ldreq r0, =p1_2Height
    ldreq r5, =direccionPersonaje2
    streq r0, [r5]
    ldreq r0, =p1_3Height
    ldreq r5, =direccionPersonaje3
    streq r0, [r5]            
    beq regreso

    teq r0, #'n' //personaje2
    ldreq r0, =p2_1Height
    ldreq r5, =direccionPersonaje1
    streq r0, [r5]
    ldreq r0, =p2_2Height
    ldreq r5, =direccionPersonaje2
    streq r0, [r5]
    ldreq r0, =p2_3Height
    ldreq r5, =direccionPersonaje3
    streq r0, [r5]       
    beq regreso

    teq r0, #'m' //personaje3
    ldreq r0, =p3_1Height
    ldreq r5, =direccionPersonaje1
    streq r0, [r5]
    ldreq r0, =p3_2Height
    ldreq r5, =direccionPersonaje2
    streq r0, [r5]
    ldreq r0, =p3_3Height
    ldreq r5, =direccionPersonaje3
    streq r0, [r5]     
    bne again

regreso:
	bl laberinto
	pop {lr}
	mov pc, lr

/**********************************************************************
* Laberinto
***********************************************************************/
.globl laberinto
laberinto:
	push {r4-r11, lr}

	ldr r0, =laberinHeight
	mov r1,#0
	mov r2,#0

	bl drawImageWithTransparency

	ldr r5, =direccionPersonaje1 //mueve personaje pos 1 escogido guardado en memoria para pintarlo
	ldr r0, [r5]
	mov r1,#0
	mov r2,#0

	bl drawImageWithTransparency

	ldr r5, =direccionPersonaje2 //mueve personaje pos 2 escogido guardado en memoria para pintarlo
	ldr r0, [r5]
	mov r1,#0
	mov r2,#0

	bl drawImageWithTransparency

	ldr r5, =direccionPersonaje3 //mueve personaje pos 3 escogido guardado en memoria para pintarlo
	ldr r0, [r5]
	mov r1,#0
	mov r2,#0

	bl drawImageWithTransparency	

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
