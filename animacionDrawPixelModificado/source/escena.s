/***********************************************************************************************
*Prelaboratorio 7
*Subrutina que dibuja un circulo vacio o con relleno segun corresponda.
*Ma. Belen Hernandez B. - 14361
*Daniela I. Pocasangre A. - 14162
*Fecha: 5 de octubre del 2015
*REGISTROS
*r0: x0
*r1: y0
*r2: radio
*r3: fill
***********************************************************************************************/

/****************************************************
* DrawCircle
* Se dibuja un circulo con determinado radio
*****************************************************/

.globl DrawCircle
DrawCircle:
	push {r4, r5, r6, r7, r8}

	x0 .req r4
	y0 .req r5
	radius .req r6
	fill .req r7
	x .req r8
	y .req r9
	radiusError .req r10

	push {lr}
	bl EstablecerRegistros
	pop {lr}

	circle:
		cmp fill, #1
		beq Fill

		//sin relleno
		mvn x,x
		add r0, x, x0
		add r1, y, y0

		push {lr}
		bl Dibujando
		pop {lr}
	b fin

	Fill:
	//con relleno
		mvn x,x
		add r2, x, x0
		add r1, y, y0
		mov r3, r1
		mov r0, x0

		push {lr}
		bl DibujandoFill
		pop {lr}

	fin:
		add y, y, #1

		mov r12, #2 //variando esto, mutan los octagonos, pero los circulos no
		sub r11, y, x
		cmp radiusError, #0
		subgt x, x, #1
		mulle r11, r12, y
		mulgt r11, r12, r11
		add r12, r11, #1 //circulos
		add radiusError, radiusError, r12

		cmp y, x
		ble circle

	pop {r4, r5, r6, r7, r8}
	mov pc,lr

/****************************************************
* DrawSquare
* Se dibuja un cuadrado con cierto ancho y alto
*****************************************************/

.globl DrawSquare
DrawSquare:
	push {r4, r5, r6, r7, r8}

	x0 .req r4
	y0 .req r5
	radius .req r6
	fill .req r7
	x .req r8
	y .req r9
	radiusError .req r10

	push {lr}
	bl EstablecerRegistros
	pop {lr}

	Square:
		cmp fill, #1
		beq FillR

		//sin relleno
		mvn x,x
		add r0, x, x0
		add r1, y, y0

		push {lr}
		bl Dibujando
		pop {lr}
	b fin1

	FillR:
	//con relleno
		mvn x,x
		add r2, x, x0
		add r1, y, y0
		mov r3, r1
		mov r0, x0

		push {lr}
		bl DibujandoFill
		pop {lr}

	fin1:
		add y, y, #1

		mov r12, #0 
		//cuadrados cuando tiende a cero, rombos para numeros grandes
		sub r11, y, x
		cmp radiusError, #0
		subgt x, x, #1
		mulle r11, r12, y
		mulgt r11, r12, r11
		//add r12, r11, #1 //circulos
		add r12, r12, #1 //Para octagonos
		add radiusError, radiusError, r12

		cmp y, x
		ble Square

	pop {r4, r5, r6, r7, r8}
	mov pc,lr	

/****************************************************
* DrawRombo
* Se dibuja un rombo con cierta longitud de lado
*****************************************************/

.globl DrawRombo
DrawRombo:
	push {r4, r5, r6, r7, r8}

	x0 .req r4
	y0 .req r5
	radius .req r6
	fill .req r7
	x .req r8
	y .req r9
	radiusError .req r10

	push {lr}
	bl EstablecerRegistros
	pop {lr}

	Rombo:
		cmp fill, #1
		beq FillRo

		//sin relleno
		mvn x,x
		add r0, x, x0
		add r1, y, y0

		push {lr}
		bl Dibujando
		pop {lr}

	b fin2

	FillRo:
	//con relleno
		mvn x,x
		add r2, x, x0
		add r1, y, y0
		mov r3, r1
		mov r0, x0

		push {lr}
		bl DibujandoFill
		pop {lr}

	fin2:
		add y, y, #1

		mov r12, #100
		//cuadrados cuando tiende a cero, rombos para numeros grandes
		sub r11, y, x
		cmp radiusError, #0
		subgt x, x, #1
		mulle r11, r12, y
		mulgt r11, r12, r11
		//add r12, r11, #1 //circulos
		add r12, r12, #1 //Para octagonos
		add radiusError, radiusError, r12

		cmp y, x
		ble Rombo

	pop {r4, r5, r6, r7, r8}
	mov pc,lr
	
/****************************************************
* DrawROctagono
* Se dibuja un octagono
*****************************************************/

.globl DrawOctagono
DrawOctagono:
	push {r4, r5, r6, r7, r8}

	x0 .req r4
	y0 .req r5
	radius .req r6
	fill .req r7
	x .req r8
	y .req r9
	radiusError .req r10

	push {lr}
	bl EstablecerRegistros
	pop {lr}

	Octagono:
		cmp fill, #1
		beq FillOc

		//sin relleno
		mvn x,x
		add r0, x, x0
		add r1, y, y0

		push {lr}
		bl Dibujando
		pop {lr}
	b fin3

	FillOc:
	//con relleno
		mvn x,x
		add r2, x, x0
		add r1, y, y0
		mov r3, r1
		mov r0, x0

		push {lr}
		bl DibujandoFill
		pop {lr}

	fin3:
		add y, y, #1

		mov r12, #2
		//cuadrados cuando tiende a cero, rombos para numeros grandes
		sub r11, y, x
		cmp radiusError, #0
		subgt x, x, #1
		mulle r11, r12, y
		mulgt r11, r12, r11
		//add r12, r11, #1 //circulos
		add r12, r12, #1 //Para octagonos
		add radiusError, radiusError, r12

		cmp y, x
		ble Octagono

	pop {r4, r5, r6, r7, r8}
	mov pc,lr

/****************************************************
* DrawRectangle
* Se dibuja un rectangulo con cierto ancho y alto
*****************************************************/

.globl DrawRectangle
DrawRectangle:
	push {r4, r5, r6, r7, r8,lr}
	mov r4, r0 //ancho
	mov r5, r1 //alto
	mov r6, r2 //x
	mov r7, r3 //y
	add r5,r7 //se suma el alto a y para pintar el cuadrado en el punto x,y

	pintar:	
		mov r0,r6 //x0
		add r8,r4,r6 //suma ancho con x
		mov r2,r8 //x1
		mov r1,r7 //y0
		mov r3,r7 //y1
		bl DrawLine
		add r7,#1
		cmp r5,r7 //compara alto con r7 para determinar si se deja de pintar o no
		bne pintar

	pop {r4, r5, r6, r7, r8,pc}

/****************************************************
* DrawTriangle
* Se dibuja un triangulo con cierto ancho y alto
*****************************************************/

.globl DrawTriangle
DrawTriangle:
	push {r4, r5, r6, r7, r8,lr}
	mov r4, r0 //ancho
	mov r5, r1 //alto
	mov r6, r2 //x
	mov r7, r3 //y
	add r5,r7 //se suma el alto a y para pintar el cuadrado en el punto x,y

	push {lr}
	mov r0,r4 //ancho
	mov r1,#2
	bl Division
	pop {lr}

	mov r11,r0 //mitad del ancho
	mov r10,#1 //contador
	pintarT:	
		add r8,r6,r11 //suma x con mitad del ancho
		add r9, r8, r10 //suma+contador
		sub r12, r8, r10 //suma-contador
		mov r0, r12 //x0
		mov r2, r9 //x1
		mov r1,r7 //y0
		mov r3,r7 //y1
		bl DrawLine
		add r10,#1 //suma contador
		add r7,#1 //suma posicion en y para comparar
		cmp r5,r7 //compara alto con r7 para determinar si se deja de pintar o no
		bne pintarT

	pop {r4, r5, r6, r7, r8,pc}

/********************************************************************************************************
* EstablecerRegistros
* Utilizado para colocar los datos que se mandan del main en registros para operar con ellos
*********************************************************************************************************/
EstablecerRegistros: 
	mov r4, r0
	mov r5, r1
	mov r6, r2
	mov r7, r3

	mov x, radius
	mov y, #0
	mov r11, #1
	sub r11, r11, x
	mov radiusError, r11
	mov pc, lr

/******************************************************************************
* Dibujando
* Se emplea para dibujar una figura que no esta rellena de color
*******************************************************************************/
Dibujando:
	x0 .req r4
	y0 .req r5
	radius .req r6
	fill .req r7
	x .req r8
	y .req r9
	radiusError .req r10

	push {lr}
		bl DrawPixel
		add r0, y, x0
		add r1, x, y0
		bl DrawPixel
		//x negativa
		mvn x, x
		add r0, x, x0
		add r1, y, y0
		bl DrawPixel
		//x positiva
		//y negativa
		mvn x,x
		mvn y,y
		add r0, y, x0
		add r1, x, y0
		bl DrawPixel
		//x negativa
		mvn x,x
		add r0, x, x0
		add r1, y, y0
		bl DrawPixel
		add r0, y, x0
		add r1, x, y0
		bl DrawPixel
		//x positiva
		mvn x, x
		add r0, x, x0
		add r1, y, y0
		bl DrawPixel
		//x negativa
		//y positiva
		mvn x, x
		mvn y, y
		add r0, y, x0
		add r1, x, y0
		bl DrawPixel
	pop {lr}
	mov pc, lr

/******************************************************************************
* Dibujando
* Subrutina para dibujar una figura que se encuentra rellena de color
*******************************************************************************/
DibujandoFill:
	x0 .req r4
	y0 .req r5
	radius .req r6
	fill .req r7
	x .req r8
	y .req r9
	radiusError .req r10

	push {lr}
		bl DrawLine
		add r2, y, x0
		add r1, x, y0
		mov r3, r1
		mov r0, x0
		bl DrawLine
		//x negativa
		mvn x, x
		add r2, x, x0
		add r1, y, y0
		mov r3, r1
		mov r0, x0
		bl DrawLine
		//x positiva
		//y negativa
		mvn x,x
		mvn y,y
		add r2, y, x0
		add r1, x, y0
		mov r3, r1
		mov r0, x0
		bl DrawLine
		//x negativa
		mvn x,x
		add r2, x, x0
		add r1, y, y0
		mov r3, r1
		mov r0, x0
		bl DrawLine
		add r2, y, x0
		add r1, x, y0
		mov r3, r1
		mov r0, x0
		bl DrawLine
		//x positiva
		mvn x, x
		add r2, x, x0
		add r1, y, y0
		mov r3, r1
		mov r0, x0
		bl DrawLine
		//x negativa
		//y positiva
		mvn x, x
		mvn y, y
		add r2, y, x0
		add r1, x, y0
		mov r3, r1
		mov r0, x0
		bl DrawLine
	pop {lr}
	mov pc, lr
