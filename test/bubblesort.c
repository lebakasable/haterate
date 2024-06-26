// \documentclass{article}
// 
// \usepackage{verbatim}
// \newenvironment{code}{\footnotesize\verbatim}{\endverbatim\normalsize}
// 
// \begin{document}
// 
// \section{Bubble Sort in C}
// 
// Bubble Sort is probably the first sorting algorithm everyone is introduced to. Let's first include the necessary header files:
// 
// \begin{code}
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
// \end{code}
// 
// The main operation of Bubble Sort is swapping two values:
// 
// \begin{code}
void swap(int *x, int *y)
{
  int t = *x;
  *x = *y;
  *y = t;
}
// \end{code}
// 
// The easiest way to remember how to implement it is when you assign something to the variable \verb|t| like \verb|int t = *x;| you are saving that thing so on the next line you can override it \verb|*x = *y;|. And after that finish the process by signing the second variable \verb|*y = t;|.
// 
// Alright, now let's implement the Bubble Sort itself:
// 
// \begin{code}
void bubble_sort(int *xs, int xs_size)
{
  for (int i = xs_size - 1; i > 1; --i) {
    for (int j = 0; j < i; ++j) {
      if (xs[j] > xs[j + 1]) {
        swap(&xs[j], &xs[j + 1]);
      }
    }
  }
}
// \end{code}
// 
// Let's check if this Bubble Sort algorithm works correctly. Let's implement a function that can generate \verb|n| random numbers for testing:
// 
// \begin{code}
#define MAX_X_SIZE 100

void generate_n_numbers(int *xs, int n)
{
  for (int i = 0; i < n; ++i) {
    xs[i] = rand() % MAX_X_SIZE;
  }
}
// \end{code}
// 
// We also need to be able to check that the array is sorted. We can do that by iterating the array with a ``window`` of size 2 and checking if the pairs are ordered ascending.
// 
// \pagebreak
// 
// \begin{code}
// 1 2 3 5 4 6
// ^ ^ ascending
// 1 2 3 5 4 6
//   ^ ^ ascending
// 1 2 3 5 4 6
//     ^ ^ ascending
// 1 2 3 5 4 6
//       ^ ^ DECENDING
// \end{code}
// 
// \begin{code}
bool is_sorted(int *xs, int n)
{
  for (int i = 0; i < n - 1; ++i) {
    if (xs[i] > xs[i + 1]) {
      return false;
    }
  }
  return true;
}
// \end{code}
// 
// \end{document}
