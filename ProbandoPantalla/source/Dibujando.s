/******************************************************************
*Taller de Assembler
*Laboratorio 10
*Seccion 30
*Ma. Belen Hernandez - 14362
*Daniela Pocasangre - 14162
*Fecha: 10/11/2015
*Uso de registros:
*r0 - r3: Parametros de entrada y salida de subrutinas
*r6: Contiene direccion de width de imagenes
*r7: Posicion en x
*r9: Posicion en Y
*r10: Almacena resultado de operaciones
*r11: Contiene ancho para inicializar x
*r12: Almacena resultado de operaciones
********************************************************************/

.globl drawImagen
drawImagen: 
	pop {r12}
	push {r4,r5,r6,r7,r8,r9,r10,r11,lr}
	mov r4, r0 //posicion x
	mov r5, r1 //posicion y
	mov r6, r2 //alto
	mov r7, r3 //ancho
	mov r8, r12

	mov r2,r4

	contadorBytes .req r9
	matriz .req r10
	color .req r11
	y .req r6

	mov contadorBytes, #0 //Contador que cuenta la cantidad de bytes dibujados
	//Ciclo que dibuja filas
	dibujarAncho:
		x .req r12
		mov x, r7 //Inicializamos el contador 'x' con el ancho de la imagen
		push{r2}
		dibujarAlto:
			mov matriz, r8 //Obtenemos la direccion de la matriz con los colores
			ldrh color, [matriz,contadorBytes] //Leemos dato de matriz. Dato = direccionBaseFoto + bytesDibujados
			mov r0, color
			bl SetForeColour
			mov r0, r4 //x
			mov r1, r5 //y
			bl DrawPixel
			add r4, #1
			add contadorBytes, #2
			sub x,#1

			teq x, #0
			bne dibujarAlto
		pop{r2}
		//Decrementamos el contador del alto de la imagen
		sub y, #1
		add r5, #1
		mov r4, r2
		teq y,#0
		bne dibujarAncho
	pop {r4,r5,r6,r7,r8,r9,r10,r11,lr}
	mov pc, lr

	.unreq x
	.unreq y
	.unreq contadorBytes
	.unreq matriz
	.unreq color
