# ethsf_confer

zkSNARKS On-chain Confidential Transactions with Smart Contracts

## Description

We deploy zkSNARKS verifier in a token composable smart contract to obfuscate user balances and transaction values for all transactions conducted within the contract.

### Balance Tracker and Token Support

Only the hashed balances are stored in the smart contract so each account balance is only known to its owner and transaction value is only exposed to the participating parties. Users may deposit any tokens into and withdraw from the smart contract so this will work for any ERC20/ERC721 tokens.

```solidity
// tokenId => (token contract => balance)
// before
// mapping(uint256 => mapping(address => uint256)) erc20Balances;
// after
mapping(uint256 => mapping(address => bytes32)) erc20BalanceHashes;
```

### Transfer Function

To initiate a transfer, say between Alice to Bob, Alice would need to create a proof based on her current balance, transfer value, and updated balance (private inputs) with hashes of these three values (public inputs.) Bob would, in turn, create a proof based on his current balance, transfer value, and updated balance (private inputs) with the hash of these three values (public inputs.)

1. Private
   1. Alice: aliceBalanceBefore, aliceBalanceAfter, transferValue
   2. Bob: bobBalanceBefore, bobBalanceAfter, transferValue
2. Public
   1. transferValueHash
   2. aliceBalanceBeforeHash, aliceBalanceAfterHash
   3. bobBalanceBeforeHash, bobBalanceAfterHash

Since only hashes are stored on chain, nobody would have knowledge about Alice and Bob's balances before or after a transaction, nor would anyone has knowledge on the transaction value between Alice and Bob. On the other hand, both Alice and Bob knows the transaction value but neither of them would know each other's balance either.

```solidity
// verifyTx(...proof parameters..., public inputs: [balanceBeforeHash, balanceAfterHash, transferValueHash, isSenderFlag])

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
        ) {
  bytes32 hashSenderBalanceBefore = balanceHashes[msg.sender];
  bytes32 hashReceiverBalanceBefore = balanceHashes[_to];

  bool senderProofIsCorrect = verifyTx(
    a[0],
    a_p[0],
    b[0],
    b_p[0],
    c[0],
    c_p[0],
    h[0],
    k[0],
    // public input values
    [hashSenderBalanceBefore, hashSenderBalanceAfter, hashValue, 1]
  );

  bool receiverProofIsCorrect = verifyTx(
    a[1],
    a_p[1],
    b[1],
    b_p[1],
    c[1],
    c_p[1],
    h[1],
    k[1],
    // public input values
    [hashReceiverBalanceBefore, hashReceiverBalanceAfter, hashValue, 0]
  );

  if(senderProofIsCorrect && receiverProofIsCorrect) {
    balanceHashes[msg.sender] = hashSenderBalanceAfter;
    balanceHashes[_to] = hashReceiverBalanceAfter;
  }
}
```

## Caveats and Future Work

### Deposit and Withdrawal Snooping

Because Alice and Bob would initially deposit tokens into the smart contracts publicly, if Alice and Bob have not yet transacted within the smart contract, one can easily calculate their balances. However, each person can easily generate blinding transfers among their own accounts to dilute this information.

### Multi-token anonymity

So far our code has been focused on single asset but as we explained in the previous section, it is easy to extend to multi-asset using token composable standard. One challenge is that in the reference token composable implementation, the balances for each account is a mapping between token indices and corresponding balances. This unnecessarily leaks the information on which token accounts are transacting within the contract. We can mitigate this problem by committing every user's balance details in a sparse merkle tree where each leaf is indexed to an onboarded token. In this way, only the transacting parties will know which specific tokens were used in the transactions.

### Preimage Attack

The current implementation hashes the balance and transfer value directly, which can be easily enumerated to find preimages of common hashes. This can be mitigated by introducing an one-time blinding factor that only Alice and Bob know to add on top of their transfer value, and separate personal blinding factor for balance confidentiality.

### Confidential Exchange (Dark Pool)

It is easy to extend the `transfer` function to `exchange` function because the contract uses composable token standard to hold multiple tokens and we simply need to update multiple sets of balances atomically. Alternatively, one can mint a ERC721 token within the contract by packaging the offering token. This ERC721 token can be transparently traded using open exchange protocol (e.g. 0x) without exposing its content to the public. Note the buyer needs to know the package details in order to create proof for unboxing. This can be down between two parties off-chain either directly or using a proxy re-encryption schema (e.g. NuCypher.)

## Credits and Challenges

### zkSNARK and Confidential Transaction

The idea of this implementation was introduced in [Introduction to zk-SNARKs with examples
](https://media.consensys.net/introduction-to-zksnarks-with-examples-3283b554fc3b). However, as [zkSNARKs: Driver's Ed.](https://github.com/jstoxrocky/zksnarks_example) points out, the zkSNARKS verification program provided is in psuedo-code and there is no common or easy-to-access resources how one would deploy this in practice. While the article helpfully laid out an example using [ZoKrates](https://github.com/JacobEberhardt/ZoKrates), it did not go as far as implementing the confidential transaction itself.

### ERC-998 Token Composable

We also took inspiration from [ERC-998](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-998.md) the **Composable Non-Fungible Token Standard**, where a TopDown composable tokens can receive, hold and transfer ERC20/ERC721 tokens. This concept allowed us to extend confidential transactions from tokens with built-in confidentiality to all tokens in the wild.

### ZoKrates: the Good, the Bad and the Ugly

We ran into a lot of issues when using **ZoKrates** since its API is constantly evolving and the high-level DSL, which compiles to R1CS constraints, has no documentation. In particular, **ZoKrates** only recently intergrated [sha256](https://github.com/JacobEberhardt/ZoKrates/pull/72) implementation from [libsnark](https://github.com/scipr-lab/libsnark) and it only exposes the `sha256libsnark` function with 512 bit level inputs and 256 outputs. However, it does not yet has support for types in the DSL, and all variables are defined as `field` which stores values as a 256 bit big integer internally. This unfornautely translates into `uint256` in Solidity when ZoKrates generates the verifier. ZoKrates DSL also does not have bitwise operator yet thus it is very difficult to pack and unpack between bits and bytes. While we can do this with simulated bitwise operations using arithematics, the compiler quickly runs into issues with too many nested statements or stack overflow. We reached a compromise by using storing 32bits integers in each `field/uint256` and effectively blows up the public input size (and gas) by a factor of 8. Fortunately, both [improved type system](https://github.com/JacobEberhardt/ZoKrates/issues/124) and [improved libsnark integration](https://github.com/JacobEberhardt/ZoKrates/issues/19) are being actively looked at.

Due to unintended large size of public inputs, we also ran into stack too deep compilation error in Solidity. We expect this problem to go away by itself once ZoKrates implements the above mentioned features. It is also possible to improve ZoKrates' code generation to break generated Solidity functions into smaller pieces.

## Source Code and How to Run

The source code live under a few branches:

- **master**: all the frontend code which simulates wallet interfaces for Alice and Bob during a transfer
- **zokrates**: zkSNARK programs and **complete test coverage** for confidential transactions using ZoKrates including utility zkSNARK programs such as bitwise `SUMS_TO`, `GREATER_THAN` and `SHA256VERIFY_LIBSNARK`.
- **rust-backend**: a docker based proof generator to be used to compute witness and generate proof by sender and receiver

### Backend

- build docker image `docker build -t zokrates .`
- start docker container with api server `docker run -ti -p 8000:8000 zokrates /home/zokrates/ZoKrates/zokrates/setup.sh`
- proof can be generated by `http://127.0.0.1:8000/generate-proof-with-witness/<isSender 1 or 0> <balance before> <transfer value>`

After a few seconds, you should see something like this:

```
A = Pairing.G1Point(0x1a0ce61d97267d6d5684cd12d08b79e6222a2ce0f3186d3b47e2fa0fdb852342, 0x610c3d9c236e22616a78bf0d8489a26a1f3e473634d88dd18214b32c9d10873);
A_p = Pairing.G1Point(0x19d76d470de6ca80835212286e292ac8ecb0056dfafae3bb6b3d0a39e724cb19, 0x275f9218eb8819f5d64745ef1ec6f479e68804384fee54dbea93015ac48a37ec);
B = Pairing.G2Point([0x176f8251f1fec1000570ed8b942e2c992170712ea9e95cd859e5078f6f812cfa, 0x2547db7dd85996124f9e78dcd8446ec5ac5c986b9bf074334478686ef1863ecd], [0x14a8c2e1e28429028c64fd90b6f21a6af82417d3438aebd6f76756642138ec9d, 0x438cae7eafec15e761e486fc51050048c90c504cba788c9cb2401dfd479984e]);
B_p = Pairing.G1Point(0xf0afa6a4e9c778624d4f76615626183bf6558178452a53981c8ab15bcc53927, 0x27de02f67186138d74b1a85c893f35b27e54b38ebed45bd4792bc769c08a25b9);
C = Pairing.G1Point(0x28f46d85cc24895b647db39ac506b8b0bc8cbbc83a07d9bb9c06000f92288fac, 0x115842bd01d697e94d3aaa906731bd8781992437c03dd443bee5ac0c490c1fae);
C_p = Pairing.G1Point(0xd623c2ff93844212ea330244b696acb1cbe2c7ee9d357ef895a4d2c38c2a986, 0x26f03852fb8429fc8a2679b13ebd07d1fbfbe5ba3a8da0d1753f8663427f4a61);
H = Pairing.G1Point(0x12eb0ccbb1e0dea1713af139ddfc7ef85c20ff1823cea0ac4c946d422fd1a0a2, 0x3bda0fb6d3279f7234e78707d30d13d9c362dd95e0b0d732b2546d331bce8e6);
K = Pairing.G1Point(0x231fcee067a2df72d4392f19c6260cb7ab55fe3684b625c7b6499c1d20437e3e, 0x1140d353ecab18fdd3231203b06416d5d4d456c2a6ee17b5ae5d3f38ed02442);
```

Note every account is meant to run its own prover to ensure that private inputs remain private. This requires the compiled proof program, and its proving and verification key to be published. A trusted 3rd party would need to perform the setup and discard the toxic waste properly. Again due to the current limitation of ZoKrates, our proof uses up to 90k variables and constraints and the proof program takes 30MB. Therefore, we chose not to commit the compiled version of our proof program.

### Frontend

`yarn` and `yarn start` will start the dev server which communicates with the backend to generate proof based on the frontend inputs.

## Roadmap

- [x] zkSNARK that proves sender balance change validity
- [x] ZKSNARK that proves receiver balance change validity
- [ ] Solidity contract that
  - [x] handles transfer for a single asset
  - [ ] handles multi-asset transfer
  - [ ] handles asset deposit and withdrawal
- [ ] Blinding factor for
  - [ ] transaction value
  - [ ] account balance
- [ ] WebAssembly based prover
