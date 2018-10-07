from subprocess import CalledProcessError

from pypy_sha256_test import int_to_bytes, bits_val, H_bytes, BLOCK_BYTES
from zokrates import zokrates, int_to_bits, bytes_to_uint

def test_confidentx(bb, ba, v, isSender):
  hbb = H_bytes(int_to_bytes(bb, BLOCK_BYTES))
  hba = H_bytes(int_to_bytes(ba, BLOCK_BYTES))
  hv = H_bytes(int_to_bytes(v, BLOCK_BYTES))

  cmd = "./zokrates compute-witness -i confidentx.out -o confidentx.witness -a \\\n"
  cmd += "%s \\\n" % ' '.join(int_to_bits(bb))
  cmd += "%s \\\n" % ' '.join(int_to_bits(ba))
  cmd += "%s \\\n" % ' '.join(int_to_bits(v))
  cmd += "%s \\\n" % bytes_to_uint(hbb)
  cmd += "%s \\\n" % bytes_to_uint(hba)
  cmd += "%s \\\n" % bytes_to_uint(hv)
  cmd += str(1 if isSender else 0)
  print cmd
  zokrates(cmd)

if __name__ == '__main__':
  test_confidentx(1, 0, 1, True)
  test_confidentx(10, 11, 1, False)
  try:
    test_confidentx(4, -2, 6, True)
  except (CalledProcessError):
    pass
  try:
    test_confidentx(4, 6, 1, True)
  except (CalledProcessError):
    pass
  try:
    test_confidentx(1, 0, 1, False)
  except (CalledProcessError):
    pass
