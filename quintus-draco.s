
# -----------------------------------------------------------------------------
#
#    Quintus Draco - A dragon fractal for Lovebyte 2023
#    Copyright (C) 2023  Matthias Koch
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

.option norelax
.option rvc

# -----------------------------------------------------------------------------
#  Peripheral IO registers
# -----------------------------------------------------------------------------

  .equ RCU_BASE,     0x40021000
  .equ RCU_APB1EN,        0x01C

  .equ DAC_BASE,     0x40007000
  .equ DAC_CTL,           0x400
  .equ DACC_R12DH,        0x420

# -----------------------------------------------------------------------------
Reset:
# -----------------------------------------------------------------------------

  li x14, RCU_BASE
  li x3,  DAC_BASE

  li x8,  -1
  sw x8,  RCU_APB1EN(x14) # Enable DAC and everything else

  li x15, 0x00010001      # Enable both DAC channels by setting DEN0 and DEN1
  sw x15, DAC_CTL(x3)

# -----------------------------------------------------------------------------
#  Notes on register usage:
#
#   x3: Constant DAC_BASE
#
#   x8: Movement
#  x10: Scratch
#  x14: Current position, x-component
#  x15: Current position, y-component
#
# -----------------------------------------------------------------------------

mainloop:

  bnez x14, 1f        # Move the image every time x hits zero
  addi x8, x8, 9      # Set speed of movement here
1:

  srli x10, x10, 32-5 # Yield a little bit of randomness
  add  x14, x14, x15  # x = x + y + random;
  add  x14, x14, x10

  andi x10, x14, 1    # y = y + ((x & 1) << 11);
  slli x10, x10, 11   # Set size of the dragon fractal here
  add  x15, x15, x10

  srai x14, x14, 1    # x = x >> 1;

  sub  x15, x15, x14  # y = y - x;

  slli x10, x15, 16   # Combine coordinates for updating
  add  x10, x10, x14  # both DAC channels at the same time.
  add  x10, x10, x8   # DAC = (y<<16) + x + movement

  sw x10, DACC_R12DH(x3)
  j mainloop

# -----------------------------------------------------------------------------
# signature: .byte 'M', 'e', 'c', 'r', 'i', 's', 'p', '.'
# -----------------------------------------------------------------------------
