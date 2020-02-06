.model small 
.stack 100h
.data
a dw 1
b dw 2
c dw 3
d dw 4
.code
start:
        mov ax, @data
        mov ds, ax
        ;<readABCD>
		mov ax,a
        and ax,b
        mov bx,a
        add bx,c
        cmp ax,bx
        jz Then1
        mov ax,a
        and ax,c
        mov bx,d
        and bx,c
        cmp ax,bx
        jz Then2
        mov ax,b
        or ax,c
        ;<print>
        jmp EndOfIf
Then1:
        mov ax,a
        and ax,d
        ;<print>
        jmp EndOfIf
Then2: 
        mov ax,c
        add ax,b
        add ax,a
        ;<print>
EndOfIf:
	mov al, 0
	mov ah, 4Ch
	int 21h
end start 