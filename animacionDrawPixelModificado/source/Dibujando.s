/******************************************************************
*Taller de Assembler
*Laboratorio 6
*Seccion 30
*Ma. Belen Hernandez - 14362
*Daniela Pocasangre - 14162
*Fecha: 30/09/2015
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

		mov r9,r1 //posicion y
		mov r1,r2 //y - largo imagen
		mov r2,r3 //x - ancho imagen
		mov r11,r3 //se guarda en r11 el ancho para inicializar x cada vez que se dibuja una linea
		mov r7,r0 //posicion x
		pop {r10}

		fbInfoAddr .req r4

		//fbAddr contiene la direccion del frame buffer
		//Se lee la direccion del frame buffer de la tabla Frame Buffer Info
		fbAddr .req r3
		ldr fbAddr,[fbInfoAddr,#32]

		//Utilizado para dibujar en pantalla la imagen en cualquier posicion
		//((ancho * y + x) * 2
		push {r9}
		push {r2}
		push {r7}
		mov r2, #1024
		mul r8, r2, r9
		add r8, r7
		mov r9, #2
		mul r12, r8, r9
		add fbAddr,r12
		pop {r7}
		pop {r2}
		pop {r9}
		
		colour .req r0
		y .req r1

		push {r8}
		push {r9}
		push {r10}
		//alto - punto y ---- si este es 6, entonces esta al final (768 - y) * 2. Es 6 por ser multiplo de 5 * 2
		mov r10,#768
		sub r8, r10, r9
		mov r9,#2
		mul r10, r8, r9
		cmp r10,#6
		pop {r10}
		pop {r9}
		pop {r8}
		moveq pc, lr
		
		//Inicializamos el contador 'y' con el alto de la imagen

		addrPixel .req r5
		countByte .req r6
		mov countByte,#0 	//Contador que cuenta la cantidad de bytes dibujados
		
		//Ciclo que dibuja filas
		drawRow$:
			x .req r2
			
			//Inicializamos el contador 'x' con el ancho de la imagen
			mov x,r11
			push {r9,r12}
			drawPixel$:
				mov addrPixel,r10				//Obtenemos la direccion de la matriz con los colores
				ldrh colour,[addrPixel,countByte]	//Leemos dato de matriz. Dato = direccionBaseFoto + bytesDibujados
				sub r12, countByte, #1
				ldrh r9,[addrPixel,r12]
				cmp colour, r9
				beq saltar
				cmp colour, #0x0
				strneh colour,[fbAddr]				//Almacenamos en el frameBuffer.
saltar:			add fbAddr,#2 						//Incrementamos el frame buffer para dibujar el siguiente pixel.
				add countByte,#2 					//Incrementamos los bytes dibujados en dos (ya dibujamos 2 bytes)
				sub x,#1 							//Decrementamos el contador del ancho de la imagen
			
				//Revisamos si ya dibujamos toda la fila
				teq x,#0
				bne drawPixel$
			pop {r9,r12}
			//Calculamos la direccion del frameBuffer para dibujar la siguiente linea
			//Direccion siguiente linea = (Ancho de la pantalla - ancho de la imagen) * Bytes/pixel 
			push {r7}
			push {r12}
			mov r12, #1024
			sub r7,r12,r11 //1024-ancho
			mov r12, #2
			mul r8,r7,r12
			add fbAddr,r8	//Le sumamos al frameBuffer la cantidad calculada para bajar de linea
			pop {r12}
			pop {r7}
			//Decrementamos el contador del alto de la imagen
			sub y,#1 

			push {r8}
			push {r9}
			push {r10}
			//alto - punto y ---- si este es 6, entonces esta al final (768 - y) * 2 ya que y es multiplo de 5
			mov r10,#768
			sub r8, r10, r9
			mov r9,#2
			mul r10, r8, r9
			cmp r10,#6
			pop {r10}
			pop {r9}
			pop {r8}
			movlt pc, lr
			//Revisamos si ya dibujamos toda la imagen.
			teq y,#0
			bne drawRow$

	mov pc, lr

	.unreq fbAddr
	.unreq fbInfoAddr
	.unreq colour
	.unreq y
	.unreq addrPixel
	.unreq x
	.unreq countByte
