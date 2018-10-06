#!/usr/bin/env python
##
# @author     This file is part of libsnark, developed by SCIPR Lab
#             and contributors (see AUTHORS).
# @copyright  MIT license (see LICENSE file)

import random
import pypy_sha256 # PyPy's implementation of SHA256 compression function; see copyright and authorship notice within.

BLOCK_LEN = 512
BLOCK_BYTES = BLOCK_LEN // 8
HASH_LEN = 256
HASH_BYTES = HASH_LEN // 8

def int_to_bytes(value, length):
    result = []

    for i in range(0, length):
        result.append(value >> (i * 8) & 0xff)

    result.reverse()

    return result

def gen_random_bytes(n):
    # return [random.randint(0, 255) for i in xrange(n)]
    return [0 for i in xrange(n)]

def words_to_bytes(arr):
    return sum(([x >> 24, (x >> 16) & 0xff, (x >> 8) & 0xff, x & 0xff] for x in arr), [])

def bytes_to_words(arr):
    l = len(arr)
    assert l % 4 == 0
    return [(arr[i*4 + 3] << 24) + (arr[i*4+2] << 16) + (arr[i*4+1] << 8) + arr[i*4] for i in xrange(l//4)]

def bits_val(s):
    binfmt = '{0:032b}'
    s = bytes_to_words(s)
    return ''.join(binfmt.format(x) for x in s)

def H_bytes(x):
    assert len(x) == BLOCK_BYTES
    state = pypy_sha256.sha_init()
    state['data'] = words_to_bytes(bytes_to_words(x))
    pypy_sha256.sha_transform(state)
    return words_to_bytes(bytes_to_words(words_to_bytes(state['digest'])))

def generate_sha256_gadget_tests(s):
    block = int_to_bytes(s, BLOCK_BYTES)
    left = block[:HASH_BYTES]
    right = block[HASH_BYTES:]
    # left = gen_random_bytes(HASH_BYTES)
    # right = gen_random_bytes(HASH_BYTES)
    # right[HASH_BYTES - 1] = 1
    hash = H_bytes(left + right)

    print "%s \\" % ' '.join(bits_val(left))
    print "%s \\" % ' '.join(bits_val(right))
    print ' '.join(bits_val(hash))

if __name__ == '__main__':
    random.seed(0) # for reproducibility
    print "0"
    generate_sha256_gadget_tests(0)
    print "1"
    generate_sha256_gadget_tests(1)
