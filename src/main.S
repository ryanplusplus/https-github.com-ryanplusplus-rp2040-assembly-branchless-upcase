/*
 * Prints "Hello, World! <count value>" in a tight loop
 *
 * Registers used:
 * - r0 => Argument to printf
 * - r1 => Offset for upcase operation (0 or 32)
 * - r2 => Unused
 * - r3 => Pointer into input
 * - r4 => Pointer into output
 * - r5 => Current character
 * - r6 => Mask register set by comparison with 'z'
 * - r7 => Mask register set by comparison with 'a'
 */

.syntax unified

.thumb_func
.global main

main:
  bl stdio_init_all
  ldr r4, =instr
  ldr r3, =outstr
loop:
  ldrb r5, [r4]           // c <- *in
  adds r4, #1             // in++

  movs r6, #0             // initialize r6 and r7 masks
  movs r7, #0

  negs r5, r5             // negate c and compare with 'z' so that carry is set if c < 'z'
  cmp r5, #'z'

  adcs r6, r6             // create a 32-bit mask containing copies of the carry bit
  lsls r6, #31
  asrs r6, #31

  negs r5, r5             // restore value of c

  cmp r5, #'a'            // set carry if c > 'a'

  adcs r7, r7             // create a 32-bit mask containing copies of the carry bit
  lsls r7, #31
  asrs r7, #31

upcase:
  movs r1, #('a' - 'A')   // start with an offset of 32...
  ands r1, r6             // ...then use r6 and r7 masks to clear to zero if c < 'a' or c > 'z'
  ands r1, r7

  subs r5, r1             // offset c if lowercae

  strb r5, [r3]           // *out = c
  adds r3, #1             // out++

  cmp r5, #0              // if c != \0, keep going
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
