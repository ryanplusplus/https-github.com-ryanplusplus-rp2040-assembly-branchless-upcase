/*
 * Prints "Hello, World! <count value>" in a tight loop
 *
 * Registers used:
 * - r0 => First parameter to printf
 * - r1 => Second parameter to printf
 * - r7 => Counter
 */

.thumb_func
.global main

main:
  bl stdio_init_all
  ldr r4, =instr
  ldr r3, =outstr
loop:
  ldrb r5, [r4]
  add r4, #1
  cmp r5, #'z'
  bgt cont
  cmp r5, #'a'
  blt cont
upcase:
  sub r5, #('a' - 'A')
cont:
  strb r5, [r3]
  add r3, #1
  cmp r5, #0
  bne loop

loop2:
  ldr r0, =outstr
  bl printf
  b loop2

.data
instr:
.asciz "Hello, World!\n"
outstr:
.fill 255, 1, 0
