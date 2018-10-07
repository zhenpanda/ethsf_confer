import sys
from subprocess import CalledProcessError

from pypy_sha256_test import int_to_bytes, bits_val, H_bytes, bytes_to_words, BLOCK_BYTES
from zokrates import zokrates, int_to_bits, bytes_to_uint

if __name__ == '__main__':
  isSender = 1 if sys.argv[1] == '1' else 0
  bb = int(sys.argv[2])
  v = int(sys.argv[3])
  ba = bb - v if isSender else bb + v
  hbb = H_bytes(int_to_bytes(bb, BLOCK_BYTES))
  hba = H_bytes(int_to_bytes(ba, BLOCK_BYTES))
  hv = H_bytes(int_to_bytes(v, BLOCK_BYTES))

  cmd = ""
  cmd += "%s \\\n" % ' '.join(int_to_bits(bb))
  cmd += "%s \\\n" % ' '.join(int_to_bits(ba))
  cmd += "%s \\\n" % ' '.join(int_to_bits(v))
  cmd += "%s \\\n" % ' '.join([str(x) for x in bytes_to_words(hbb)])
  cmd += "%s \\\n" % ' '.join([str(x) for x in bytes_to_words(hba)])
  cmd += "%s \\\n" % ' '.join([str(x) for x in bytes_to_words(hv)])
  cmd += str(1 if isSender else 0)
  print cmd
