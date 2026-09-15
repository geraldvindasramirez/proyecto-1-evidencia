.global procesar_trama

.section .data
// etiquta
txt_linea:	.ascii "Linea"
.equ len_linea, 6

txt_sep_id:	.ascii "ID:"
.equ len_sep_id, 7

txt_sep_temp:	.ascii "Temp:"
.equ len_sep_temp, 9

txt_sep_alert:	.ascii "Alertas:"
.equ len_sep_alert, 12

txt_grados:	.ascii "C"
.equ len_grados, 2


// textos
txt_sin_alertas: .ascii "Sin_Alertas"
.equ len_sin_alertas, 11

txt_bat_baja: .ascii "Bateria_baja"
.equ len_bat_baja, 13

txt_fuera_rango: .ascii "Fuera_rango"
.equ len_fuera_rango, 15

txt_calibracion: .ascii "Calibracion_requerida"
.equ len_calibracion, 22

txt_salto:	.ascii "\n"

.section .text


procesar_trama:
//usar los registros
stp x19, x20, [sp,#-48]!

stp x21, x22, [sp,#16]

stp x23, x30, [sp,#32]

mov x19,x0 //guarda las lineas

mov x20,x1 //guarda archivo de reporte txt

//validar la trama (5 bytes)
ldr x2, =cantidad_bytes_trama

ldr x2, [x2]

cmp x2, #5

blt trama_invalida

Linea<num>

mov x8, #64

mov x0, x20

ldr x1, =txt_linea

mov x2, #len_linea

svc #0

mov x0, x19

bl escribir_num_ascii


ID:

mov x8, #64

mov x0, x20

ldr x1, =txt_sep_id

mov x2, #len_sep_id

svc #0

// leer bytes de ID
ldr x21, =bytes_trama_decodificados

ldr w2, [x21, #0]

ldr w3, [x21, #1]

lsl w2,w2,#8

orr w22, w2, w3

uxtw x0, w22

bl escribir_num_ascii

Temp:
mov x8, #64

mox x0, x20

ldr x1, =txt_sep_temp

mov x2, #len_sep_temp

svc #0

//leer bytes de temp

ldrb w2, [x21, #2]

ldrb w3, [x21, #3]

lsl w2, w2, #8

orr w22, w2, w3

sxth w22, w22

cmp w22, #0

bge temp_positiva

mov x8, #64

mov x0, x20

sub sp, sp, #16

mov w1, #0x2D  //en ascii

strb w1, [sp]

mov x1, sp

mov x2, #1

svc #0

add sp, sp, #16

neg w22, w22

temp_positiva://dividimos entre 10 para sacar el entero y decimal

mov w1, #10

udiv w2, w22, w1 //w2 entero

msub w3,w2, w22 //w3 desimal

//escribir entero

uxtw x0, w2

nl escribir_num_ascii

//escribir punto desimal

mov x8, #64

mov x0, x20

sub sp, sp, #16

mov w4, #0x2E //"." en ascii

strb w4, [sp]

mov x2, #1

svc #0

add sp, sp, #16

// desimal

uxtw x0, w3

bl escribir_num_ascii

// escribir la "C"

mov x8, #64

mov x0, x20

ldr x1, =txt_grados

mov x2, #len_grados

svc #0

alertas:

mov x8, #64

mov x0, x20

ldr x1, =txt_sep_alert

mov x2, #len_sep_alert

svc #0

ldrb w22, [x21, #4]

ands w2, w22,0x0F  // bits del 0 a 3

bne evaluar_bits

// no alerta

mov x8, #64

mov x0, x20

ldr x1, =txt_sin_alertas

mov x2, #len_sin_alertas

svc #0

b fin_alertas

evaluar_bits:

tst w22, #0x01

beq check_bit1

mov x8, #64

mov x0, x20

ldr x1, =txt_bat_baja

mov x2, #len_bat_baja

svc #0

check_bit1:

tst w22, #0x02

beq check_bit2

mov x8, #64

mov x0, x20

ldr x1, =txt_fallo_sens

mov x2, #len_fallo_sens

svc #0

check_bit2:

tst w22, #0x04

beq check_bit3

mov x8, #64

mov x0, x20

ldr x1, =txt_fuera_rango

mov x2, #len_fuera_rango

svc #0

check_bit3:

tst w22, #0x08

beq_fin_alertas

mov x8, #64

mov x0, x20

ldr x1, =txt_calibracion

mov x2, #len_calibracion

svc #0

fin_alertas:

mov x8, #64

mov x0, x20

ldr x1, =txt_salto

mov x2, #1

svc #0

mov x0, #1

b salir_procesar

trama_invalida:

mov x0, #0

salir_procesar:

ldp x21, x22, [sp, #16]

ldp x23, x30, [sp, #32]

ldp x20, x20, [sp], #48

ret

escribir_num_ascii:
stp x29, 30, [sp, #-32]!

mov x29, sp

add x1, sp, #31

mov x2, #0

mov x3, #10

bucle_conv:

udiv x4, x0, x3

msub x5, x4, x3, x0

add w5, w5, #0x30

sub x1, x1, #1

strb  w5, [x1]

add x2, x2, #1

mov x0, x4

cbnz x0, bucle_conv

mov x8, #64

mov x0, x20

svc #0

ldp x29, x30, [sp], #32

ret
