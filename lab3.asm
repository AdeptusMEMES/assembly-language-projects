.model small
.stack 100h
.data
a dw ?
b dw ?
c dw ?
d dw ?

bim db "Bad input$"
zdm db "Zero division$"
nstr db 6 dup(?)

.code
validation proc
cmp al,'-'
	jnz pos
	cmp si,0
	jz cni
pos:cmp al,48
	jb bi
	cmp al,57
	ja bi
cni:ret
bi:	lea dx,bim
	mov ah,09h
	int 21h
	mov al,0
	mov ah,4Ch
	int 21h
validation endp

symtonum proc
	push bx
	push cx
	push dx
	mov si, 0
cb:	
	mov ah, 01h
	int 21h
	cmp al, 13
	jz ce
	cmp al, 10
	jz ce
	cmp al, 8
	jnz nd
	cmp si, 0
	jz ndec
	dec si
ndec:
	mov nstr[si], 0
	mov ah, 02h
	mov dl, 32
	int 21h
	mov dl, 8  
	int 21h
	jmp cb
nd:	call validation
	mov nstr[si],al
	inc si
	jmp cb
ce:	mov nstr[si],0
	mov si,0
	xor ax,ax
c2b:mov cl, nstr[si]
	mov ch,0
	cmp cl,0
	jz c2e
	cmp cl,48
	jb next
	sub cl,48
	mov dx,10
	mul dx
	add ax, cx
next:
	inc si
	jmp c2b
c2e:cmp nstr[0],'-'
	jnz pos1
	neg ax
pos1:
	pop dx
	pop cx
	pop bx
	ret
symtonum endp

numtosym proc
	push ax
	push bx
	push cx
	push dx
	push 0
	cmp ax,0
	jge c3b
	neg ax
	mov bx,ax
	mov dl,'-'
	mov ah,02h
	int 21h
	mov ax,bx
c3b:mov bx,10
	xor dx,dx
	div bx
	add dl,'0'
	push dx
	cmp ax,0
	jz c3e
	jmp c3b
c3e:mov ah,02h
c4b:pop dx
	cmp dl,0
	jz c4e
	int 21h
	jmp c4b
c4e:pop dx
	pop cx
	pop bx
	pop ax
	ret
numtosym endp

zerocheck proc
	cmp cx,0
	jz zero
	ret
zero:
	lea dx,zdm
	mov ah,09h
	int 21h
	mov al,0
	mov ah,4Ch
	int 21h
zerocheck endp

start:
	mov ax,@data
	mov ds,ax
	call symtonum
	mov a,ax
	call symtonum
	mov b,ax
	call symtonum
	mov c,ax
	call symtonum
	mov d,ax
	sub ax,c
	mov bx,b
	add bx,a
	cmp ax,bx
	jnz else1
	mov ax,a
	mov cx,b
	imul cx
	mov bx,ax

	mov ax,c
	cwd
	mov cx,d
	call zerocheck
	idiv cx
	add dx,d
	mov ax,dx
	cwd
	call zerocheck
	idiv cx
	mov ax,c
	sub ax,dx
	cwd
	call zerocheck
	idiv cx

	add ax,bx
	call numtosym
	jmp endofif
else1:
	mov cx,b
	mov ax,a
	cwd
	call zerocheck
	idiv cx
	add dx,b
	mov ax,dx
	cwd
	call zerocheck
	idiv cx
	mov ax,c
	add ax,d
	cmp ax,dx
	jnz else2

	mov cx,d
	mov ax,c
	cwd
	call zerocheck
	idiv cx
	add dx,d
	mov ax,dx
	cwd
	call zerocheck
	idiv cx
	mov cx,dx

	mov bx,b
	add bx,a

	mov ax,bx
	cwd
	call zerocheck
	idiv cx
	add dx,cx
	mov ax,dx
	cwd
	call zerocheck
	idiv cx
	mov ax,bx
	sub ax,dx
	cwd
	call zerocheck
	idiv cx
	call numtosym
	jmp endofif
else2:
	mov ax,a
	add ax,d
	mov bx,b
	add bx,c
	sub ax,bx
	call numtosym
endofif:
	mov al,0
	mov ah, 4Ch
	int 21h
end start 