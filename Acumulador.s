
/* -----------------------------------------------
* UNIVERSIDAD DEL VALLE DE GUATEMALA 
* Org de computadoras y Assembler
* Ciclo 1 - 2022
* Gonzalo Santizo
* Jose Daniel Gomez
* Melanie Maldonado
 ----------------------------------------------- */


@ ---------------------------------------
@	Data Section
@ ---------------------------------------
	 .data
	 .balign 4	
Intro: 	 .asciz  "Raspberry Pi wiringPi blink test\n"
ErrMsg:	 .asciz	"Wrong data closing now...\n"
pin1:	 .int	1
pin2:	 .int	2
pin3:	 .int	3
pin4:	 .int	4
pin5:	 .int	5
pin6:	 .int	6
pin7:	 .int	7
pin8:	 .int	8

i:	 	 .int	0
delayMs: .int	200
OUTPUT	 =	1
	
@ ---------------------------------------
@	Code Section
@ ---------------------------------------
	
	.text
	.global main
	.extern printf
	.extern wiringPiSetup
	.extern delay
	.extern digitalWrite
	.extern pinMode
	
main:   push 	{ip, lr}	@ push return address + dummy register
				@ for alignment

	bl	wiringPiSetup			// Inicializar libreria wiringpi
	mov	r1,#-1					// -1 representa un codigo de error
	cmp	r0, r1					// verifica si se retorno cod error en r0
	bne	init					// NO error, entonces iniciar programa
	ldr	r0, =ErrMsg				// SI error, 
	bl	printf					// imprimir mensaje y
	b	done					// salir del programa

@  pinMode(pin, OUTPUT)		;
init:
	ldr	r0, = pin1				// coloca el #pin wiringpi a r0
	ldr	r0, [r0]
	mov	r1, #OUTPUT				// lo configura como salida, r1 = 1
	bl	pinMode					// llama funcion wiringpi para configurar

@   for ( i=0; i<10; i++ ) { 	
	ldr	r4, =i					// carga valor de contador en 8
	ldr	r4, [r4]
	mov	r5, #8
forLoop:						// inicio de ciclo 
	cmp	r4, r5
	bgt	done					// si el ciclo se ha completado 8 veces
								// entonces termina programa
@	digitalWrite(pin, 1) ;		
	ldr	r0, =pin1				// carga direccion de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #1
	bl 	digitalWrite			// escribe 1 en pin para activar puerto GPIO
	
@       delay(200)		 ;
	ldr	r0, =delayMs
	ldr	r0, [r0]
	bl	delay

@       digitalWrite(pin, 0) 	;
	ldr	r0, =pin				// carga direccion de pin
	ldr	r0, [r0]				// operaciones anteriores borraron valor de pin en r0
	mov	r1, #0
	bl 	digitalWrite			// escribe 0 en pin para desactivar puerto GPIO

@       delay(200)		 ;
	ldr	r0, =delayMs
	ldr	r0, [r0]
	bl	delay

	add	r4, #1					// incrementa contador
	b	forLoop					// repite ciclo
	
done:	
        pop 	{ip, pc}	@ pop return address into pc
