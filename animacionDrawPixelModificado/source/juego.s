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
    beq regreso

    teq r0, #'n' //personaje2
    ldreq r0, =p2_1Height
    beq regreso

    teq r0, #'m' //personaje3
    ldreq r0, =p3_1Height

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
	push {lr}

	mov r5, r0 //mueve personaje escogido a r5

	ldr r0, =laberinHeight
	mov r1,#0
	mov r2,#0

	push {r5}
	bl drawImageWithTransparency
	pop {r5}

	mov r0, r5
	mov r1,#0
	mov r2,#0

	bl drawImageWithTransparency

	pop {lr}
	mov pc, lr
