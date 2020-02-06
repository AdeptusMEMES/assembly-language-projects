.model small 
.stack 100h
.data

n dw ?
i dw ?
j dw ?
k dw ?
arr db 100 dup(?)

.code

symtonum proc
	push bx
	push cx
	push dx
	xor bx,bx
cb:	mov ah, 01h
	int 21h
	cmp al,32
	jz ce
	cmp al,13
	jz ce
	cmp al,10
	jz ce
	sub al,'0'
	mov cl,al
	mov ch,0
	mov ax,bx
	mov bx,10
	mul bx
	xor dx,dx
	add ax,cx
	mov bx,ax
	jmp cb
ce:
	mov ax,bx
	pop dx
	pop cx
	pop bx
	ret
symtonum endp

input proc
	mov i,0
ciib:
	mov ax,n
	cmp i,ax
	jz ciie
	mov j,0
cjib:
	mov ax,n
	cmp j,ax
	jz cjie
	mov ax,i
	mul n
	mov si,ax
	add si,j
	call symtonum
	mov arr[si],al
	inc j
	jmp cjib
cjie:
	inc i
	jmp ciib
ciie:
	ret
input endp

numtosym proc
	push ax
	push bx
	push cx
	push dx
	push 0
	mov bx,10
c1b:
	xor dx,dx
	div bx
	add dl,'0'
	push dx
	cmp ax,0
	jz c1e
	jmp c1b
c1e:
	mov ah,02h
c2b:	
	pop dx
	cmp dl,0
	jz c2e
	int 21h
	jmp c2b
c2e:
	pop dx
	pop cx
	pop bx
	pop ax
	ret
numtosym endp

output proc
	mov i,0	
ciob:
	mov ax,n
	cmp i,ax
	jz cioe
	mov j,0
cjob:
	mov ax,n
	cmp j,ax
	jz cjoe
	mov ax,i
	mul n
	mov si,ax
	add si,j
	mov al,arr[si]
	mov ah,0
	call numtosym
	mov ah,02h
	mov dl,32
	int 21h
	inc j
	jmp cjob
cjoe:
	mov ah,02h
	mov dl,10
	int 21h
	inc i
	jmp ciob
cioe:
	ret
output endp

initial proc
	mov ax,i
	mul n
	mov si,ax
	add si,j
	mov cl,arr[si]
	mov ax,i
	mul n
	mov si,ax
	add si,k
	mov bl,arr[si]
	mov ax,k
	mul n
	mov si,ax
	add si,j
	mov bh,arr[si]
	add bl,bh
	mov ax,i
	mul n
	mov si,ax
	add si,j
	cmp cl,bl
	ja min2
	mov arr[si],cl
	jmp min1
min2:
	mov arr[si],bl
min1:
	ret
initial endp

start:
	mov ax,@data
	mov ds,ax
	call symtonum
	mov n,ax
	call input
	mov k,0
ckab:
	mov ax,n
	cmp k,ax
	jz ckae
	mov i,0
ciab:
	mov ax,n
	cmp i,ax
	jz ciae
	mov j,0
cjab:
	mov ax,n
	cmp j,ax
	jz cjae
	call initial
	inc j
	jmp cjab
cjae:
	inc i
	jmp ciab
ciae:
	inc k
	jmp ckab
ckae:
	call output
	mov al,0
	mov ah, 4Ch
	int 21h
end start