@ *************************************************************
@ Autor: Martin L. Guzman
@ Fecha: 30/07/2015
@Subrutina que realiza una division entre 2 numeros (A/B)
@Parametros:
@  r0: numero 1 (A)
@  r1: numero 2 (B)
@Retorna:
@  r0: resultado
@  r1: residuo
@ *************************************************************

.globl Division
Division:
    push {lr}

    @ reiniciamos los valores de los registros donde iran los resultados
    mov r2, #0
    mov r3, r0 @asignamos el residuo como A
    
    inicio_div:
        cmp r3,r1
        blt fin_div     @terminar ya que B es mas grande que el residuo
        sub r3,r3,r1    @residuo = residuo-B 
        add r2,r2,#1    @resultado = resultado+1
        b inicio_div
    fin_div:

    mov r0, r2 //resultado
    mov r1, r3 //residuo

    pop {pc}