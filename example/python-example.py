from __future__ import print_function
import functools
import sys
from random import random
from operator import add

if __name__ == "__main__":
    """
        Usage: pi [partitions]
    """
    partitions = int(sys.argv[1]) if len(sys.argv) > 1 else 2
    n = 100000 * partition

    def f():
        x = random() * 2 - 1
        y = random() * 2 - 1
        return 1 if x ** 2 + y ** 2 <= 1 else 0

    count = functools.reduce(add, [f() for _ in range(1,n+1)])
    print("Pi is roughly %f" % (4.0 * count / n))
