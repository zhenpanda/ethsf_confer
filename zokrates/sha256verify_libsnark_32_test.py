from pypy_sha256_test import int_to_bytes, bits_val, H_bytes, BLOCK_BYTES
from zokrates import zokrates, int_to_bits

def int_to_bits(x):
  block = int_to_bytes(x, BLOCK_BYTES)
  right = block[len(block) - 4:]
  return bits_val(right)

def test_sha256(x):
  block = int_to_bytes(x, BLOCK_BYTES)
  hash = H_bytes(block)
  # print ' '.join(bits_val(hash))

  cmd = "./zokrates compute-witness -i sha256verify_libsnark_32.out -o sha256verify_libsnark_32.witness -a \\\n"
  cmd += "%s \\\n" % ' '.join(int_to_bits(x))
  cmd += ' '.join(bits_val(hash))
  print cmd
  zokrates(cmd)

if __name__ == '__main__':
  test_sha256(1)
  test_sha256(4)
  test_sha256(234)
  test_sha256(234234)
  test_sha256(213123123)
