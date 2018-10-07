from pypy_sha256_test import int_to_bytes, bits_val, BLOCK_BYTES
from zokrates import zokrates, int_to_bits

def int_to_bits(x):
  block = int_to_bytes(x, BLOCK_BYTES)
  right = block[len(block) - 4:]
  return bits_val(right)

def test_ge(a, b, c):
    cmd = "./zokrates compute-witness -i ge_32.out -o ge_32.witness -a \\\n"
    cmd += "%s \\\n" % ' '.join(int_to_bits(a))
    cmd += ' '.join(int_to_bits(b))
    print cmd
    assert(zokrates(cmd) == str(c))

if __name__ == '__main__':
  test_ge(1, 2, 0)
  test_ge(2, 2, 1)
  test_ge(3, 2, 1)
  test_ge(213123, 124123, 1)
  test_ge(124123, 213123, 0)
