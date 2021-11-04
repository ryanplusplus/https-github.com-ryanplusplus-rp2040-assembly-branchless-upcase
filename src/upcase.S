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
 * - r4 => Mask register for comparison result
 */
upcase:
  push {r4}

upcase_next:
  ldrb r2, [r0]           // c <- *in
  adds r0, #1             // in++

  movs r3, #('a' - 'A')   // start with an offset of 32

check_end:
  movs r4, #0             // initialize comparison result mask

  negs r2, r2             // negate c and compare with 'z' so that carry is set if c < 'z'
  cmp r2, #'z'

  adcs r4, r4             // create a 32-bit mask containing copies of the carry bit
  lsls r4, #31
  asrs r4, #31

  ands r3, r4             // use the mask to clear (if > 'z') or retain offset

  negs r2, r2             // restore value of c

check_start:
  movs r4, #0             // initialize comparison result mask

  cmp r2, #'a'            // set carry if c > 'a'

  adcs r4, r4             // create a 32-bit mask containing copies of the carry bit
  lsls r4, #31
  asrs r4, #31

  ands r3, r4             // use the mask to clear (if < 'a') or retain offset

apply_offset:
  subs r2, r3             // apply offset to c

store_result:
  strb r2, [r1]           // *out = c
  adds r1, #1             // out++

  cmp r2, #0              // if c != \0, keep going
  bne upcase_next

done:
  pop {r4}
  bx lr
