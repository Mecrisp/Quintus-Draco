
#include <stdio.h>
#include <stdint.h>

// ----------------------------------------------------------------------------
//   Dragon curve
// ----------------------------------------------------------------------------

/*
  How to use:

  clang -O3 -Wall -W -pedantic -fno-strict-aliasing dragon.c -o dragon && ./dragon > Dragon.txt
  gnuplot
  plot "Dragon.txt" using 1:2 with dots
*/

int main()
{
  int32_t x = 1; // Start values are not critical,
  int32_t y = 0; // but at least one must be non-zero.
  int32_t random = 0;

  for (int p1 = 0; p1 < 100000; p1++) {

    printf("%i %i %i\n", x, y, random);

    random = random + x;

    x = x + y + (random & 1);  // Yield a little bit of randomness
    y = y + ((x & 1) << 11);   // Shift amount controls size of the dragon
    x = x >> 1;
    y = y - x;

  }
  return(0);
}
