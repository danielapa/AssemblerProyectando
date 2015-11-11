/**********************************************************************************************************************************
*	Taller de assembler
*	Ejercicio 5
*	Daniela I. Pocasangre A.
*	Carnet 14162
*	Fecha: 3/11/2015
*	En este programa se realiza la implementacion de comandos en la terminal utilizando en el teclado utilizando raspberry pi.
*
*	Uso registros:
*	r0-r3 - Parametros de entrada y salida subrutinas
*	
**********************************************************************************************************************************/

/*
* .globl is a directive to our assembler, that tells it to export this symbol
* to the elf file. Convention dictates that the symbol _start is used for the 
* entry point, so this all has the net effect of setting the entry point here.
* Ultimately, this is useless as the elf itself is not used in the final 
* result, and so the entry point really doesn't matter, but it aids clarity,
* allows simulators to run the elf, and also stops us getting a linker warning
* about having no entry point. 
*/
.section .init
.globl _start
_start:

/*
* Branch to the actual main code.
*/
b main

/*
* This command tells the assembler to put this code with the rest.
*/
.section .text

/*
* main is what we shall call our main operating system method. It never 
* returns, and takes no parameters.
* C++ Signature: void main(void)
*/
main:

/*
* Set the stack point to 0x8000.
*/
	mov sp,#0x8000

/* 
* Setup the screen.
*/

	mov r0,#1024
	mov r1,#768
	mov r2,#16
	bl InitialiseFrameBuffer

/* 
* Check for a failed frame buffer.
*/
	teq r0,#0
	bne noError$
		
	mov r0,#16
	mov r1,#1
	bl SetGpioFunction

	mov r0,#16
	mov r1,#0
	bl SetGpio

	error$:
		b error$

	noError$:

	fbInfoAddr .req r4
	mov fbInfoAddr,r0

/*
* Let our drawing method know where we are drawing to.
*/
	push {r4}
	bl SetGraphicsAddress
	bl UsbInitialise
	pop {r4}
	
	push {r4}
	ldr r6,=fondoWidth //x - ancho imagen
	ldrh r6,[r6] 

	ldr r7,=fondoHeight //y - alto imagen
	ldrh r7,[r7]

	ldr r10,=fondo //carga la direccion del fondo

	mov r0, #0
	mov r1, #0
	mov r2, r7 //y - alto imagen
	mov r3, r6 //x - ancho imagen
	push {r10} //localidad en donde se encuentra matriz de imagen
	bl drawImagen

	ldr r6,=personaje_ancho //x - ancho imagen
	ldrh r6,[r6] 

	ldr r7,=personaje_alto //y - alto imagen
	ldrh r7,[r7]

	ldr r10,=Vert1

	mov r0, #512 //posicion x
	mov r1, #384 //posicion y
	mov r2, r7 //y - alto imagen
	mov r3, r6 //x - ancho imagen
	push {r10} //localidad en donde se encuentra matriz de imagen
	bl drawImagen

	pop {r4}
/*
* Let our drawing method know where we are drawing to.
*/

	mov r8, #512
	mov r11, #0

loopContinue$:
	push {r4}
	bl KeyboardUpdate
	bl KeyboardGetChar
	pop {r4}

	teq r0,#0
	beq loopContinue$

	cmp r0, #'a' //si se presiona a, el personaje camina en el mismo lugar
	bleq Caminar

	cmp r0, #'e'
	beq Ciclo

	b loopContinue$

Ciclo:
	bl Fondo
	cmp r11, #0
	bleq Dibujo1
	cmp r11, #1
	bleq Dibujo2
	cmp r11, #2
	bleq Dibujo3
	cmp r11, #3
	bleq Dibujo4

	push {r4, r8}
	bl KeyboardUpdate
	bl KeyboardGetChar
	pop {r4, r8}

	cmp r11, #3
	addne r11, #1
	moveq r11, #0

	teq r0,#0
	beq Ciclo

	cmp r0, #'m'
	addeq r8, #20

	cmp r0, #'n'
	subeq r8, #20

	cmp r0, #'f'
	beq Reiniciar
	b Ciclo

Caminar:
	push {lr}
	bleq Dibujo1
	bleq Dibujo2
	bleq Dibujo3
	bleq Dibujo4
	pop {lr}
	mov pc, lr

Fondo:
	push {r4, r8, r11, lr}
	ldr r6,=fondoWidth //x - ancho imagen
	ldrh r6,[r6] 

	ldr r7,=fondoHeight //y - alto imagen
	ldrh r7,[r7]

	ldr r10,=fondo //carga la direccion del fondo

	mov r0, #0
	mov r1, #0
	mov r2, r7 //y - alto imagen
	mov r3, r6 //x - ancho imagen
	push {r10} //localidad en donde se encuentra matriz de imagen
	bl drawImagen
	pop {r4, r8, r11, lr}
	mov pc, lr

Dibujo1:
	push {r4, r8, r11, lr}

	bl Fondo

	ldr r6,=personaje_ancho //x - ancho imagen
	ldrh r6,[r6] 

	ldr r7,=personaje_alto //y - alto imagen
	ldrh r7,[r7]

	ldr r10,=Vert1

	mov r0, r8 //posicion x
	mov r1, #384 //posicion y
	mov r2, r7 //y - alto imagen
	mov r3, r6 //x - ancho imagen
	push {r10} //localidad en donde se encuentra matriz de imagen
	bl drawImagen

	pop {r4, r8, r11, lr}
	mov pc, lr

Dibujo2:
	push {r4, r8, r11, lr}
	bl Fondo

	ldr r6,=personaje_ancho //x - ancho imagen
	ldrh r6,[r6] 

	ldr r7,=personaje_alto //y - alto imagen
	ldrh r7,[r7]

	ldr r10,=Vert2

	mov r0, r8 //posicion x
	mov r1, #384 //posicion y
	mov r2, r7 //y - alto imagen
	mov r3, r6 //x - ancho imagen
	push {r10} //localidad en donde se encuentra matriz de imagen
	bl drawImagen
	
	pop {r4, r8, r11, lr}
	mov pc, lr

Dibujo3:
	push {r4, r8, r11, lr}
	bl Fondo

	ldr r6,=personaje_ancho //x - ancho imagen
	ldrh r6,[r6] 

	ldr r7,=personaje_alto //y - alto imagen
	ldrh r7,[r7]


	ldr r10,=Vert3

	mov r0, r8 //posicion x
	mov r1, #384 //posicion y
	mov r2, r7 //y - alto imagen
	mov r3, r6 //x - ancho imagen
	push {r10} //localidad en donde se encuentra matriz de imagen
	bl drawImagen
	
	pop {r4, r8, r11, lr}
	mov pc, lr	

Dibujo4:
	push {r4, r8, r11, lr}
	bl Fondo
	
	ldr r6,=personaje_ancho //x - ancho imagen
	ldrh r6,[r6] 

	ldr r7,=personaje_alto //y - alto imagen
	ldrh r7,[r7]

	ldr r10,=Vert4

	mov r0, r8 //posicion x
	mov r1, #384 //posicion y
	mov r2, r7 //y - alto imagen
	mov r3, r6 //x - ancho imagen
	push {r10} //localidad en donde se encuentra matriz de imagen
	bl drawImagen
	
	pop {r4, r8, r11, lr}
	mov pc, lr	

Reiniciar:
	mov r8, #512
	mov r11, #0
	bl Dibujo1
	b loopContinue$
