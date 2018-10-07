from pypy_sha256_test import int_to_bytes, bits_val, H_bytes, bytes_to_words, BLOCK_BYTES
from zokrates import zokrates, int_to_bits, bytes_to_uint


def test_sha256(x):
  block = int_to_bytes(x, BLOCK_BYTES)
  hash = H_bytes(block)

  cmd = "./zokrates compute-witness -i sha256verify_libsnark_32.out -o sha256verify_libsnark_32.witness -a \\\n"
  cmd += "%s \\\n" % ' '.join(int_to_bits(x))
  cmd += ' '.join([str(x) for x in bytes_to_words(hash)])
  #cmd += str(bytes_to_uint(hash))
  print cmd
  zokrates(cmd)

if __name__ == '__main__':
  test_sha256(1)
  test_sha256(4)
  test_sha256(234)
  test_sha256(234234)
  test_sha256(213123123)
