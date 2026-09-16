.section .data
.global bytes_trama_decodificados
.global cantidad_bytes_trama


bytes_trama_decodificados:
	.byte 0x01, 0x02, 0xFF, 0x65, 0x05

cantidad_bytes_trama:
	.quad 5

nombre_archivo:
	.asciz "report.txt"

.global txt_linea, len_linea
.global txt_sep_id, len_sep_id
.global txt_sep_temp, len_sep_temp
.global txt_grados, len_grados
.global txt_sep_alert, len_sep_alert
.global txt_sin_alertas, len_sin_alertas
.global txt_bat_baja, len_bat_baja
.global txt_fallo_sens, len_fallo_sens
.global txt_fuera_rango, len_fuera_rango
.global txt_calibracion, len_calibracion
.global txt_salto

txt_linea: .ascii "linea "
len_linea = . - txt_linea

txt_sep_id:	.ascii "ID:"
len_sep_id = . - txt_sep_id

txt_sep_temp:	.ascii "Temp:"
len_sep_temp = . - txt_sep_temp

txt_grados:	.ascii "C:"
len_grados = 	. - txt_grados

txt_sep_alert:	.ascii "Alertas:"
len_sep_alert = . - txt_sep_alert

txt_sin_alertas:	.ascii "Sin_alertas"
len_sin_alertas = . - txt_sin_alertas

txt_bat_baja:	.ascii "Bateria_baja"
len_bat_baja = . - txt_bat_baja

txt_fallo_sens:	.ascii "Fallo_sensor"
len_fallo_sens = . - txt_fallo_sens

txt_fuera_rango: .ascii "Fuera_rango "
len_fuera_ramgo = . - txt_fuera_rango

txt_calibracion: .ascii "Calibracion_requerida "
len_calibracion = . - txt_calibracion

txt_saltos:	.ascii "\n"

.section .text
.global _start

_start:
	mov x8, #56
	mov x0, #-100
	ldr x1, =nombre_archivo
	mov x2, #577
	mov x3, #0644
	svc #0
	
	mov x1, x0
	mov x0, #1

	bl procesar_trama

	mov x8, #93
	mov x0, #0
	svc #0
