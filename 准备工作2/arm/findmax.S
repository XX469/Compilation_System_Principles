    .text
    .global	N  
    .global	__aeabi_idiv

    .data
    .align 2
    .type	N, %object
	.size	N, 4

N:
    .word 15

    .section .rodata @ 只读数据区
    .align 2
_str0:  @ 定义字符串
    .ascii "max: %d\012\000"

    .text
    .align 2
    .global find_max
    .type	find_max, %function
find_max:  @ find_max函数
    @ 栈帧调整
    push {fp}
    mov fp,sp 
    sub sp,sp,#32
    str r0, [fp,#-24]   @ *nums
    str r1, [fp,#-28]   @ n
    ldr r2, [fp,#-24]   @ &nums[0]
    ldr r2, [r2]        @ nums[0]
    str r2, [fp,#-16]   @ max
    mov r3, #1          @ i=1
    str r3, [fp,#-12]   @ i
start:  @ 循环分支判断
    ldr r2, [fp,#-12]   @ ld i
    ldr r3, [fp,#-28]   @ ld n
    cmp r2,r3
    beq endloop            @ i=n 跳出循环
loop:
    ldr r2, [fp,#-12]   @ ld i
    lsls r2,r2,#2       @ i<<2
    ldr r3, [fp,#-24]   @ r3=&nums[0] 
    add r3,r3,r2        @ r3=&nums[i]
    ldr r3,[r3]         @ nums[i]
    mov r4,r3           @ curr=nums[i]
    str r4, [fp,#-8]    @ st curr
    ldr r2, [fp,#-16]   @ max
    cmp r4,r2 
    ble else
    mov r2,r4           @ max=curr
    str r2, [fp,#-16]   @ update max
    b increasei
else:
    mov r2,r2           @ max=max
    str r2, [fp,#-16]
increasei:
    ldr r3, [fp,#-12]   @ i
    add r3,r3,#1        @ i++
    str r3, [fp,#-12]   @ st i
    b start
endloop:
    ldr r2, [fp,#-16]   @ ld max
    mov r0,r2           @ r0返回值
    mov sp,fp
    pop {fp}            @栈帧恢复
    bx lr

    .text
    .global main
    .type	main, %function
main:   @ main函数
    push {fp,lr}
    sub sp,sp, #56
    mov fp,sp
    add r0,fp,#8
    str r0,[fp]         @ st &numbers[0]
    mov r3,#0           @ i=0
    str r3,[fp,#4]      @ st i
loopstart:  @ 循环分支判断
    ldr r2,[fp,#4]      @ i
    mov r3,#10          @ 10
    cmp r3,r2
    ble loopend         @ i>=10结束循环
    ldr r2,_bridge      @ r2=&N
    ldr r3, [r2]        @ r3=N
    ldr r2,[fp,#4]      @ r2=i
    mul r3,r2,r3        @ r3=i*N
    add r2,r2,#1        @ r2=i+1
    mov r1,r2
    mov r0,r3
    bl	__aeabi_idiv    @ r0=(i*N)/(i+1)
    mov r3,r0           @ r3=r0=(i*N)/(i+1)
    ldr r2,[fp,#4]      @ i
    orrs r2,r2,r3       @ r2=i|((i*N)/(i+1))
    ldr r3, [fp,#4]     @ ld i
    lsls r3,r3,#2       @ i<<2
    ldr r4, [fp]        @ ld &numbers[0]
    add r4,r4,r3        @ r4 = &numbers[i]
    str r2, [r4]        @ numbers[i]=i|(i*N)
    ldr r3, [fp,#4]     @ i
    add r3,r3,#1        @ i+1
    str r3, [fp,#4]     @ i=i+1
    b loopstart
loopend:
    ldr r0,[fp]         @ r0=&numbers[0]
    mov r1,#10
    bl find_max         @ 调用函数
    mov r1,r0           @ r1=r0=max
    ldr r0,_bridge+4    @ r0=&_str0
    bl printf           @ printf("max: %d\n", max)
    add fp,fp,#56
    mov sp,fp
    mov r0,#0           @ return 0
    pop {fp,pc}

_bridge:
    .word N
    .word _str0


