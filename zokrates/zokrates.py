from subprocess import check_output, PIPE
from pypy_sha256_test import int_to_bytes, bits_val, BLOCK_BYTES

def zokrates(cmd):
  output = check_output(cmd.split('\\s+'), shell = True)
  return output[len(output) - 2]

def int_to_bits(x):
  block = int_to_bytes(x, BLOCK_BYTES)
  right = block[len(block) - 4:]
  return bits_val(right)
