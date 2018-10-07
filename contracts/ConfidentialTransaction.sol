pragma solidity ^0.4.24;

import "./verifier.sol";

contract ConfidentialTransaction is Verifier {
  mapping (address => bytes32) public balanceHashes;

  /// FIXME: CompilerError: Stack too deep, try removing local variables.
  function transfer(
    address _to,
    bytes32 hashValue,
    bytes32 hashSenderBalanceAfter,
    bytes32 hashReceiverBalanceAfter,
    uint[2][2] a,
    uint[2][2] a_p,
    uint[2][2][2] b,
    uint[2][2] b_p,
    uint[2][2] c,
    uint[2][2] c_p,
    uint[2][2] h,
    uint[2][2] k
  )
  public
  {
    bytes32 hashSenderBalanceBefore = balanceHashes[msg.sender];
    bytes32 hashReceiverBalanceBefore = balanceHashes[_to];

    bool senderProofIsCorrect = verifyTransaction(
      true,
      hashSenderBalanceBefore,
      hashSenderBalanceAfter,
      hashValue,
      a[0],
      a_p[0],
      b[0],
      b_p[0],
      c[0],
      c_p[0],
      h[0],
      k[0]
    );

    bool receiverProofIsCorrect = verifyTransaction(
      false,
      hashReceiverBalanceBefore,
      hashReceiverBalanceAfter,
      hashValue,
      a[1],
      a_p[1],
      b[1],
      b_p[1],
      c[1],
      c_p[1],
      h[1],
      k[1]
    );

    if(senderProofIsCorrect && receiverProofIsCorrect) {
      balanceHashes[msg.sender] = hashSenderBalanceAfter;
      balanceHashes[_to] = hashReceiverBalanceAfter;
    }
  }

  function verifyTransaction(
    bool isSender,
    bytes32 hashBalanceBefore,
    bytes32 hashBalanceAfter,
    bytes32 hashValue,
    uint[2] a,
    uint[2] a_p,
    uint[2][2] b,
    uint[2] b_p,
    uint[2] c,
    uint[2] c_p,
    uint[2] h,
    uint[2] k
  )
  internal
  returns(bool)
  {
    return verifyTx(
      a,
      a_p,
      b,
      b_p,
      c,
      c_p,
      h,
      k,
      // public input values
      sliceInputValues(hashBalanceBefore, hashBalanceAfter, hashValue, isSender)
    );
  }

  /// @dev Slice bytes32 inputs to uint256[8] each due to ZoKrates compiler limitations
  /// FIXME: correctly slice bytes to uint32[8]
  function sliceInputValues(
    bytes32 hashBalanceBefore,
    bytes32 hashBalanceAfter,
    bytes32 hashValue,
    bool isSender
  )
  internal
  returns(uint256[26] out)
  {
    out[0] = uint256(hashBalanceBefore);
    out[1] = uint256(hashBalanceBefore);
    out[2] = uint256(hashBalanceBefore);
    out[3] = uint256(hashBalanceBefore);
    out[4] = uint256(hashBalanceBefore);
    out[5] = uint256(hashBalanceBefore);
    out[6] = uint256(hashBalanceBefore);
    out[7] = uint256(hashBalanceBefore);

    out[8] = uint256(hashBalanceAfter);
    out[9] = uint256(hashBalanceAfter);
    out[10] = uint256(hashBalanceAfter);
    out[11] = uint256(hashBalanceAfter);
    out[12] = uint256(hashBalanceAfter);
    out[13] = uint256(hashBalanceAfter);
    out[14] = uint256(hashBalanceAfter);
    out[15] = uint256(hashBalanceAfter);

    out[16] = uint256(hashValue);
    out[17] = uint256(hashValue);
    out[18] = uint256(hashValue);
    out[19] = uint256(hashValue);
    out[20] = uint256(hashValue);
    out[21] = uint256(hashValue);
    out[22] = uint256(hashValue);
    out[23] = uint256(hashValue);

    out[24] = isSender ? 1 : 0;
    out[25] = 1;
  }
}
