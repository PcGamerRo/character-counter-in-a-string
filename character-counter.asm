.model small

.stack 200h

.data
	mesaj1 db 'dati sirul de caractere:  $'
	mesaj2 db 13,10,'dati caracterul:  $'
	caracter db 0
	nrCaractere db 0
	string db 0
	aparitii db 0
	
	F db 13,10,'Caracterul nu apare in sirul dat!',13,10,'$'
	T db 13,10,'Numarul aparitiilor caracterului in sirul dat este egal cu: $'
	
.code
	start:
		mov ax, @data
		mov ds, ax
		
		;citire sir
		mov dx, offset mesaj1
		mov ah, 09h
		int 21h	
		
		read:
			mov ah, 01h
			int 21h
	
			cmp al, 13
			je stop
						
			push ax
			
			sub al, 48
			
			mov bl, al
			mov al, string
			mul cl
			add al, bl
			mov string, al
			
			inc nrCaractere
			jmp read
		
		stop:
		
		;citire caracter
		mov dx, offset mesaj2
		mov ah, 09h
		int 21h
		
		mov ah, 01h
		int 21h
		mov caracter, al
			
		;verificare aparitii
		
		mov cl, nrCaractere
		mov ch, 0
		
		bucla:
			pop ax
			call verificare
		loop bucla
		
		jmp verificareFinala
		
		;verificare aparitii cu procedura
		verificare proc
				cmp caracter, al
				je adevarat
				jmp fals
				
				adevarat:
					inc aparitii
					jmp nextChar
				fals:
					jmp nextChar
			
			nextChar:
			endp
		ret
		
		verificareFinala:
			cmp aparitii, 0
			je nicioAparitie
			jmp ExistaAparitii
		
		nicioAparitie:
			mov dx, offset F
			mov ah, 09h
			int 21h
			
		jmp ending
		
		ExistaAparitii:
			mov dx, offset T
			mov ah, 09h
			int 21h
			
			mov al, aparitii
			mov ah, 0
			
			mov bx, 10
			xor cx, cx
	
			descompuneNr:
				xor dx, dx
				div bx
				inc cx
					
				push dx
					
				cmp ax, 0
				je afiseazaCifre
				jmp descompuneNr
		
			afiseazaCifre:
				pop dx
				add dl, 48
				mov ah, 02h
				int 21h
			loop afiseazaCifre
			
		ending:
			mov ah, 4ch
			int 21h
	end
