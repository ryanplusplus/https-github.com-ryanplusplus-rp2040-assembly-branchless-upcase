.syntax unified
.thumb

.global main

.thumb_func
main:
  bl stdio_init_all
  ldr r0, =instr
  ldr r1, =outstr
  bl upcase

loop:
  ldr r0, =outstr
  bl printf
  b loop

.data

instr:
.asciz "Hello, World!\n"

outstr:
.fill 255, 1, 0
