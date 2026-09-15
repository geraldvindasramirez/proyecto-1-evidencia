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
