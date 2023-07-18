;Lucas Zappani Siqueira
;GRR20202599

.cseg
.org 0x0000				; Configura a fun��o start no endere�o de mem�ria em 0x0000
	jmp  start

.org 0x0008				; Configura a fun��o PCINT1_ISR para o endere�o de mem�ria 0x0008
	jmp  PCINT1_ISR


.org 0x0100				; Configura o resto do c�digo para o endere�o de mem�ria 0x0100
start:
	ldi r16, 0xFF		; Carrega o valor 0b11111111 no r16
	out DDRB, r16		; Habilita todas os pinos de sa�da do PORTB
	ldi r16, 3			; Carrega o valor 3 em r16
	out PORTC, r16		; Habilita os dois primeiros pinos do PORTC
	ldi r16, 2			; Carrega o valor 2 em r16
	sts PCICR, r16		; Seleciona as sa�das para interrup��o em PCINT8 - 14
	ldi r16, 3			; Carrega o valor 3 em r16
	sts PCMSK1, r16		;Seleciona as sa�das para interrup��es PCINT8 e PCINT9 
	sei					; Habilita as interrup��es globais

ldi r17, 0				; Carrega o valor 0 em r17
ldi r20, 0x10			; Carrega o valor 0b00010000 em r20
; Fun��o que conta de 0 a 99 em BCD progressivamente
cresc:
	out PORTB, r17		; Manda o valor em r17 para a sa�da do PORTB
	call delay			; Chama a fun��o delay
	inc r17				; Incrementa 1 em r17
	ldi r16, 0x0F		; Carrega o valor 0b00001111 em r16
	and r16, r17		; Fun��es l�gica AND entre os valores dos registradores r16 e r17
	cpi r16, 0x0A		; Compara se o valor em r16 � igual a 0b00001010
	brne PCINT1_ISR		; Se o valor n�o for igual, volta para a fun��o PCINT1_ISR para verificar se houve interrup��o
	ldi r16, 0xF0		; Carrega o valor 0b11110000
	and r17, r16		; Fun��es l�gica AND entre os valores dos registradores r17 e r16
	add r17, r20		; Adiciona o valor de r20 em r17
	mov r16, r17		; Move o valor de r17 para r16
	cpi r16, 0xA0		; Compara se o valor em r16 � igual a 0b10100000
	brne PCINT1_ISR		; Se o valor n�o for igual, volta para a fun��o PCINT1_ISR para verificar se houve interrup��o
	ldi r16, 0x0F		; Carrega o valor 0b00001111
	and r17, r16		; Fun��es l�gica AND entre os valores dos registradores r17 e r16
    rjmp PCINT1_ISR		; Pula para a fun��o PCINT1_ISR

; Fun��o que conta de 0 a 99 em BCD regressivamente
decresc:
	 out PORTB, r17		; Manda o valor em r17 para a sa�da do PORTB
     call delay			; Chama a fun��o delay
     dec r17			; decrementa 1 em r17
     ldi r16, 0x0F		; Carrega o valor 0b00001111 em r16
     and r16, r17		; Fun��es l�gica AND entre os valores dos registradores r16 e r17
     cpi r16, 0X0F		; Compara se o valor em r16 � igual a 0b00001111
     brne PCINT1_ISR	; Se o valor n�o for igual, volta para a fun��o PCINT1_ISR para verificar se houve interrup��o
     ldi r16, 0XF9		; Carrega o valor 0b11111001
     and r17, r16		; Fun��es l�gica AND entre os valores dos registradores r17 e r16
     mov r16, r17		; Move o valor de r17 para r16
     cpi r16, 0xF9		; Compara se o valor em r16 � igual a 0b11111010
     brne PCINT1_ISR	; Se o valor n�o for igual, volta para a fun��o PCINT1_ISR para verificar se houve interrup��o
     ldi r16, 0x99		; Carrega o valor 0b00001111 em r16
     and r17, r16		; Fun��es l�gica AND entre os valores dos registradores r17 e r16
     rjmp PCINT1_ISR	; Pula para a fun��o PCINT1_ISR

; Fun��o delay
delay:
	ldi r25, 100
	ldi r26, 100
	ldi r27, 30
	delay_1:
		dec r25
		brne delay_1
		ldi r25, 100
		dec r26
		brne delay_1
		ldi r26, 100
		dec r27
		brne delay_1
		ret

; Fun��o de interrup��o
PCINT1_ISR:
	in  r19, PINC		; Verifica se o PINC tem valor 1 ou 0 e carrega em r19
	sbrs r19, 0			; Se o valor for 0, faz a instru��o abaixo
	rjmp decresc		; Pula para a fun��o decresc
	sbrs r19, 1			; Se o valor em r19 for 1, faz a instru��o abaixo
	ldi r17, 0			; Carrega o valor 0 em r17
	rjmp cresc			; Pula para a fun��o cresc 
	
	
