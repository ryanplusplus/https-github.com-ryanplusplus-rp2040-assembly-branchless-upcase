.syntax unified
.thumb

.global upcase

/*
 * Arguments:
 * - r0 => Pointer to input string
 * - r1 => Pointer to output string
 *
 * Registers used:
 * - r0 => Pointer into input string
 * - r1 => Pointer into output string
 * - r2 => Current character
 * - r3 => Offset for upcase operation (0 or 32)
 * - r4 => Mask register set by comparison with 'z'
 * - r5 => Mask register set by comparison with 'a'
 */
upcase:
  push {r4-r5}

upcase_character:
  ldrb r2, [r0]           // c <- *in
  adds r0, #1             // in++

  movs r4, #0             // initialize r4 and r5 masks
  movs r5, #0

  negs r2, r2             // negate c and compare with 'z' so that carry is set if c < 'z'
  cmp r2, #'z'

  adcs r4, r4             // create a 32-bit mask containing copies of the carry bit
  lsls r4, #31
  asrs r4, #31

  negs r2, r2             // restore value of c

  cmp r2, #'a'            // set carry if c > 'a'

  adcs r5, r5             // create a 32-bit mask containing copies of the carry bit
  lsls r5, #31
  asrs r5, #31

  movs r3, #('a' - 'A')   // start with an offset of 32...
  ands r3, r4             // ...then use r4 and r5 masks to clear to zero if c < 'a' or c > 'z'
  ands r3, r5

  subs r2, r3             // offset c if lowercae

  strb r2, [r1]           // *out = c
  adds r1, #1             // out++

  cmp r2, #0              // if c != \0, keep going
  bne upcase_character

done:
  pop {r4-r5}
  bx lr
