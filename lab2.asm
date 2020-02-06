.model small 
.stack 100h
.data
a dw ?
b dw ?
c dw ?
d dw ?

bim db "Bad input$"
.code
symtonum proc
	xor bx,bx
cb:	mov ah, 01h
	int 21h
	cmp al,13
	jz ce
	cmp al,10
	jz ce
	cmp al,8
	jnz nd
	mov ax,bx
	mov bx,10
	xor dx,dx
	div bx
	mov bx,ax
	mov ah, 02h
	mov dl, 32
	int 21h
	mov dl, 8  
	int 21h
	jmp cb
nd:	cmp al,48
	jb bi
	cmp al,57
	ja bi
num:sub al,'0'
	mov cl,al
	mov ch,0
	mov ax,bx
	mov bx,10
	mul bx
	xor dx,dx
	add ax,cx
	mov bx,ax
	jmp cb
ce:	ret
bi:	lea dx,bim
	mov ah,09h
	int 21h
	mov al,0
	mov ah,4Ch
	int 21h
symtonum endp

numtosym proc
	mov ax,bx
	push 0
c1b:mov bx,10
	xor dx,dx
	div bx
	add dl,'0'
	push dx
	cmp ax,0
	jz c1e
	jmp c1b
c1e:mov ah,02h
c2b:pop dx
	cmp dl,0
	jz c2e
	int 21h
	jmp c2b
c2e:ret
numtosym endp

start:
	mov ax,@data
	mov ds,ax
	call symtonum
	mov a,bx
	call symtonum
	mov b,bx
	call symtonum
	mov c,bx
	call symtonum
	mov d,bx
	mov ax,a
	add ax,c
	mov bx,b
	xor bx,d
	cmp ax,bx
	jnz else1
	mov bx,a
	or bx,b
	or bx,c
	add bx,d
	call numtosym
else1:
	mov ax,a
	add ax,c
	mov bx,b
	and bx,d
	cmp ax,bx
	jnz else2
	mov bx,a
	xor bx,d
	mov ax,c
	xor ax,d
	add bx,ax
	call numtosym
else2:
	mov bx,a
	add bx,d
	mov ax,b
	or ax,c
	and bx,ax
	call numtosym
	mov al,0
	mov ah, 4Ch
	int 21h
end start 