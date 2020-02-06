.model small
.stack 100h
.data

i dw ?
j dw ?
k dw ?

s db 101 dup(?)

.code

input proc
	push ax
	push bx
	push cx
	push dx
	xor si,si
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
	mov ah, 02h
	mov dl, 32
	int 21h
	mov dl, 8  
	int 21h
	jmp cb
nd:
	mov s[si],al
	inc si
	jmp cb
ce:
	mov s[si],'$'
	xor si,si

	pop dx
	pop cx
	pop bx
	pop ax
	ret
input endp

insertsort proc
	mov i,1
cb1:
	mov si,i
	cmp s[si],'$'
	jz ce1
	mov ah,s[si]
	mov bx,i
	dec bx
	mov j,bx
cb2:
	cmp j,0
	jl ce2
	mov si,j
	cmp s[si],ah
	jbe ce2
	mov bx,j
	inc bx
	mov k,bx
	mov si,j
	mov al,s[si]
	mov si,k
	mov s[si],al
	dec j
	jmp cb2
ce2:
	mov bx,j
	inc bx
	mov k,bx
	mov si,k
	mov s[si],ah
	inc i
	jmp cb1
ce1:
	ret
insertsort endp

start:
	mov ax,@data
	mov ds,ax
	call input

	call insertsort

	lea dx,s
	mov ah,09h
	int 21h
	
	mov al,0
	mov ah, 4Ch
	int 21h
end start 