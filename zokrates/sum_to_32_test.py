from pypy_sha256_test import int_to_bytes, bits_val, BLOCK_BYTES
from zokrates import zokrates, int_to_bits

def int_to_bits(x):
  block = int_to_bytes(x, BLOCK_BYTES)
  right = block[len(block) - 4:]
  return bits_val(right)

def test_sums_to(a, b, c):
    cmd = "./zokrates compute-witness -i sum_to_32.out -o sum_to_32.witness -a \\\n"
    cmd += "%s \\\n" % ' '.join(int_to_bits(a))
    cmd += "%s \\\n" % ' '.join(int_to_bits(b))
    cmd += ' '.join(int_to_bits(c))
    print cmd
    return zokrates(cmd)

if __name__ == '__main__':
  assert(test_sums_to(1, 2, 3) == str(1))
  assert(test_sums_to(1, 3, 3) == str(0))
  assert(test_sums_to(213123, 124123, 337246) == str(1))
  assert(test_sums_to(213123, 124123, 337242) == str(0))
