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

	ldr r0, =fondoInicioHeight
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

    ldr r0, =fondoSeleccionHeight
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

/**********************************************************************
* Laberinto
***********************************************************************/
.globl laberinto
laberinto:
	push {r4-r11, lr}

    ldr r0, =bgHeight //inicia laberinto de fondo y personaje en el inicio
    mov r1,#0
    mov r2,#0

    bl drawImageWithTransparency

	ldr r0, =laberinHeight //inicia laberinto de fondo y personaje en el inicio
	mov r1,#0
	mov r2,#0

	bl drawImageWithTransparency

	ldr r5, =direccionPersonaje1 //mueve personaje guardado en memoria para pintarlo por primera vez
	ldr r0, [r5]
	mov r1,#58
	mov r2,#0

	bl drawImageWithTransparency

//inicia ciclo laberinto
 ciclo:
    bl KeyboardUpdate
    bl KeyboardGetChar

    cmp r0, #'e'
    beq salir

    bl Caminar
//AQUI VA EL CODIGO QUE MANDA A MOVER PERSONAJE DEPENDIENDO DE (X,Y) Y TODO LO QUE VA DENTRO DEL FUNCIONAMIENTO DEL LABERINTO
//SE ME OCURRIA HACER SUBRUTINAS PARA: MOVER, DISPAROS, CHOQUE, ENEMIGOS
//ASI CREO QUE SERIA MAS ORDENADO Y SI PIERDE SOLO SE VA A LA ETIQUETA SALIR Y YA SE MUEVE EL LR A PC  EN ORDEN O PODEMOS GUARDARLO EN MEMORIA

    bne ciclo

salir:
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
