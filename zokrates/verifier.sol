// This file is MIT Licensed.
//
// Copyright 2017 Christian Reitwiessner
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

pragma solidity ^0.4.14;
library Pairing {
    struct G1Point {
        uint X;
        uint Y;
    }
    // Encoding of field elements is: X[0] * z + X[1]
    struct G2Point {
        uint[2] X;
        uint[2] Y;
    }
    /// @return the generator of G1
    function P1() pure internal returns (G1Point) {
        return G1Point(1, 2);
    }
    /// @return the generator of G2
    function P2() pure internal returns (G2Point) {
        return G2Point(
            [11559732032986387107991004021392285783925812861821192530917403151452391805634,
             10857046999023057135944570762232829481370756359578518086990519993285655852781],
            [4082367875863433681332203403145435568316851327593401208105741076214120093531,
             8495653923123431417604973247489272438418190587263600148770280649306958101930]
        );
    }
    /// @return the negation of p, i.e. p.addition(p.negate()) should be zero.
    function negate(G1Point p) pure internal returns (G1Point) {
        // The prime q in the base field F_q for G1
        uint q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
        if (p.X == 0 && p.Y == 0)
            return G1Point(0, 0);
        return G1Point(p.X, q - (p.Y % q));
    }
    /// @return the sum of two points of G1
    function addition(G1Point p1, G1Point p2) internal returns (G1Point r) {
        uint[4] memory input;
        input[0] = p1.X;
        input[1] = p1.Y;
        input[2] = p2.X;
        input[3] = p2.Y;
        bool success;
        assembly {
            success := call(sub(gas, 2000), 6, 0, input, 0xc0, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require(success);
    }
    /// @return the product of a point on G1 and a scalar, i.e.
    /// p == p.scalar_mul(1) and p.addition(p) == p.scalar_mul(2) for all points p.
    function scalar_mul(G1Point p, uint s) internal returns (G1Point r) {
        uint[3] memory input;
        input[0] = p.X;
        input[1] = p.Y;
        input[2] = s;
        bool success;
        assembly {
            success := call(sub(gas, 2000), 7, 0, input, 0x80, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require (success);
    }
    /// @return the result of computing the pairing check
    /// e(p1[0], p2[0]) *  .... * e(p1[n], p2[n]) == 1
    /// For example pairing([P1(), P1().negate()], [P2(), P2()]) should
    /// return true.
    function pairing(G1Point[] p1, G2Point[] p2) internal returns (bool) {
        require(p1.length == p2.length);
        uint elements = p1.length;
        uint inputSize = elements * 6;
        uint[] memory input = new uint[](inputSize);
        for (uint i = 0; i < elements; i++)
        {
            input[i * 6 + 0] = p1[i].X;
            input[i * 6 + 1] = p1[i].Y;
            input[i * 6 + 2] = p2[i].X[0];
            input[i * 6 + 3] = p2[i].X[1];
            input[i * 6 + 4] = p2[i].Y[0];
            input[i * 6 + 5] = p2[i].Y[1];
        }
        uint[1] memory out;
        bool success;
        assembly {
            success := call(sub(gas, 2000), 8, 0, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require(success);
        return out[0] != 0;
    }
    /// Convenience method for a pairing check for two pairs.
    function pairingProd2(G1Point a1, G2Point a2, G1Point b1, G2Point b2) internal returns (bool) {
        G1Point[] memory p1 = new G1Point[](2);
        G2Point[] memory p2 = new G2Point[](2);
        p1[0] = a1;
        p1[1] = b1;
        p2[0] = a2;
        p2[1] = b2;
        return pairing(p1, p2);
    }
    /// Convenience method for a pairing check for three pairs.
    function pairingProd3(
            G1Point a1, G2Point a2,
            G1Point b1, G2Point b2,
            G1Point c1, G2Point c2
    ) internal returns (bool) {
        G1Point[] memory p1 = new G1Point[](3);
        G2Point[] memory p2 = new G2Point[](3);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        return pairing(p1, p2);
    }
    /// Convenience method for a pairing check for four pairs.
    function pairingProd4(
            G1Point a1, G2Point a2,
            G1Point b1, G2Point b2,
            G1Point c1, G2Point c2,
            G1Point d1, G2Point d2
    ) internal returns (bool) {
        G1Point[] memory p1 = new G1Point[](4);
        G2Point[] memory p2 = new G2Point[](4);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p1[3] = d1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        p2[3] = d2;
        return pairing(p1, p2);
    }
}
contract Verifier {
    using Pairing for *;
    struct VerifyingKey {
        Pairing.G2Point A;
        Pairing.G1Point B;
        Pairing.G2Point C;
        Pairing.G2Point gamma;
        Pairing.G1Point gammaBeta1;
        Pairing.G2Point gammaBeta2;
        Pairing.G2Point Z;
        Pairing.G1Point[] IC;
    }
    struct Proof {
        Pairing.G1Point A;
        Pairing.G1Point A_p;
        Pairing.G2Point B;
        Pairing.G1Point B_p;
        Pairing.G1Point C;
        Pairing.G1Point C_p;
        Pairing.G1Point K;
        Pairing.G1Point H;
    }
    function verifyingKey() pure internal returns (VerifyingKey vk) {
        vk.A = Pairing.G2Point([0x1e45c91ea78584c721f16964081ed1da2636278bc2342be89e59f836b2e8c4bb, 0x21e491d65f0c71c925678ad5333b724729473e2de1dd8b8b2775deb90d3e9bc4], [0xef347abb19d702bd61d90f12605cb2dd53a3487b9f45ef1be99a79a055afec9, 0x25c4386a19da7eee52dfe554c9e9aefc43f6fdbd2ad2062ba953b0a38b9f55ac]);
        vk.B = Pairing.G1Point(0x2d3c2a05380f7cbae3d38521dbeefda84ac21ceba4997e43964d59a407c63a23, 0x198e1d3d1f43a6bcf71c97de19c2b141259f2c680810330214419b324c556911);
        vk.C = Pairing.G2Point([0x2cfcad6221b0a25a3cc733eadaed07bbd0a03d846b64f6486132ec9a0b8c6265, 0x2feeedbd9bcb565b911b942fe2288511e2a4b89b219d71105f4487c6369e3c15], [0x2d7dcd52bd70d0a661cd82493a0af28b0208e1e2f1b23547a77318f0585545b1, 0x2176e93110bc6073b46fcb61a92de7fa63190c6f0e059ab8b20849e9edc1dcd2]);
        vk.gamma = Pairing.G2Point([0x1837e0d0544de75d71349e3dee21f71856d107b53fdef3f75ab2618dc5ae81ec, 0x2c43be16e4224e4b0563635400992f5eeed67a96f939b9e2e124d3be3156d59a], [0x2dfa669ea317672eb1aaaa0f73b47acb03d9e026f5f79904dd876abdba6c6778, 0x1b424b7a12ddbfb968747db9b4315fe93d14e4e55343703353eb22c8c8042ab3]);
        vk.gammaBeta1 = Pairing.G1Point(0x14de141e10e0c83a7f92f931d4d906c7366317d9286e910c55920c3b62b6988b, 0x1ca8abd15bef662f5675a9423fdac27d45e7eb4d396ea18ee10a2378ef616f27);
        vk.gammaBeta2 = Pairing.G2Point([0x167bce2035a4635c759562097de1066f4ff3faada74fcbde9cb9ecdcea715126, 0x2b0c492d2094c1ad91c56cc2210f4294fb3533777f2b3d4551f06f3f2aaa605e], [0x22a7b67472ce7b139432628b24fe812d0388d8b9a709f1e7aa61b7efb1d3b4f2, 0x1e88c344118e998e48b8955dbdefe258e78c346ef6c259193913d2c0b5dcb773]);
        vk.Z = Pairing.G2Point([0x327fc6523d56051789f9cf1b615591ca91c7bac9052f9559ac4f7c462ac7ab9, 0x614aae0eb36265ed9c8047b7cde6bc8c360b906bc43b6669a687d79164e4ace], [0xc106fa4ec79aa3f4d1230cb23c9a1321d8637a09851a5c816d35ce2301ca37d, 0x30455f5326cf9ccfd4cccca7091eaa0959bf5d5d826f89b8436b4449923c2e69]);
        vk.IC = new Pairing.G1Point[](27);
        vk.IC[0] = Pairing.G1Point(0x2211d73a9b9f46f56cb06dcdf3c55086d7024f9178e9ea480a4d05e8d7ae612, 0x152d48fc82edde3e1bbac757f191c3d34d768ee2813477fe2789102e8b8e0344);
        vk.IC[1] = Pairing.G1Point(0xfa62599823a562fb48d07134bd27f86c66d1d16d228629b930c3f4169b344f0, 0x201f52a2665c08cc5b2e7eb2a2128b4f92f01a0add3b78588fc25db00efe5767);
        vk.IC[2] = Pairing.G1Point(0x643178f3fd6d25d26bf97ce307134e5279c15ba80757828db78d460b98b03c2, 0x2b14a9585f93710c6c43bf7fab8b127947b9b9f3be2b8835e06c706e8d2a0282);
        vk.IC[3] = Pairing.G1Point(0xfc857d8635ba90a2b715850afc029235568877f1f358254a50c794020315048, 0x18767312fd83ebf24386c837671fde3879e163d700ffe40915cb08ef9a3235ad);
        vk.IC[4] = Pairing.G1Point(0x2018576716d46e67ba31b7d3145771eb251ad52f5ab505fd9c2a253939c58fdb, 0x27114b88da17236d69665c93938bacc3844166597ce4048c418a933605e7714a);
        vk.IC[5] = Pairing.G1Point(0xf74c96aaf96cb09e3b613091d6e29ff88c00f5c09232eb836a4b1b67ff779e7, 0x1aea52e11469682027c2881c4166382902e8d9fdc5755158b1e78bf31f8b1e27);
        vk.IC[6] = Pairing.G1Point(0x50f725944f66bcd4d62568a09223c20e8104e71fe595f9dfea52559d79cb513, 0x8c387ab0e1f94d325c14a9e168f5936bbbf518c43d78634b4b557b56652bab6);
        vk.IC[7] = Pairing.G1Point(0x43b241452a19c9d0de919c11e13f46c24723099d8cf9ccbb84e5eb70a527736, 0x1cc813140baaae506c6dfe5911e20604dc6a7e84ee8c500603a4cfceac6da246);
        vk.IC[8] = Pairing.G1Point(0xe6ca19a3136c1dcda55e64229cfa180a0a64efa1e608de219ca86cf69d22215, 0x215cf4e5ac925056ec32a937b1011e67cac89317b61c3f3abecead9a30875525);
        vk.IC[9] = Pairing.G1Point(0x738e3859a3ed5c0f691e82471c9f4f5e1be24d7fe3d7ea4075b2e8a0aaef721, 0x2f72d802ccf6c20aba949ff77e301dbd3944688f6ac996177af69b7defd79877);
        vk.IC[10] = Pairing.G1Point(0xa0ec7b4035ae0e15aa437203c1769496c3ef7c80e9148003ce811e38c4de803, 0x100e71d4c6c1ec7942245c30bd80bb69b44f21f2b045501678bf9498d9a3a539);
        vk.IC[11] = Pairing.G1Point(0x159bb8c0af369a4571f31261e5c780ef895d858d1374d5301c2a9d362b8db9fb, 0x29be8db5b696320a5f7b5d9ca90b29262e4ec74eff92c191d53f788ea5c9e986);
        vk.IC[12] = Pairing.G1Point(0x896531cb2878ecd524058b7b5ae5e8064035fd20366b25c4d279eb715c1a374, 0x18e87e44effba2864fd4efc7ea7195ae288792defc9de969a41bfda43cf1bd42);
        vk.IC[13] = Pairing.G1Point(0x28d343179eb8b97da06567d249695ff73ee841cc979d572126478fdb45f25302, 0x2d4ee13ea8a03da6c27dba3fc8dfe6c3a60baccd8a32e2acb9671e569e74d01f);
        vk.IC[14] = Pairing.G1Point(0x1d9a87abae52a00e11df407ff46fa91843c972e22c38a58d37e4989ad64c1346, 0x4f8827f64051a9e87b550540f58a80e1eac6ca0a7bee4832aeeb55088040b59);
        vk.IC[15] = Pairing.G1Point(0xf160b02b47ba1f4740e498c2f566b08ee2143c88bc9a1301996a2d4cdc0dd36, 0x15c6acaccfa1eeb3e0a7864b03bde7fb3e2486774b9b48c968603157f05afaa2);
        vk.IC[16] = Pairing.G1Point(0x113e9bf28d4a2f546625fe918a60437c37494ca8edc91f2416e846deda377400, 0x1e2b2b072d092695f297333906b1cd78ad61b57b92cae38a49f6912789d96d97);
        vk.IC[17] = Pairing.G1Point(0x235bdb564bd4da228f8451cc514eac874cfc43a9d50a127b442c856b8078de08, 0xde867757cf2dc0391444d8689e2214db0db2a99324d3a63a8ae87264c0625bd);
        vk.IC[18] = Pairing.G1Point(0xe4b36d434883a3624c92106e6acaab98ed6a9bb972dcd702ca5cc3ed04ac714, 0xd32a75ae89a933db83fd6afbe2c6acf982894ec4d917943cabd6d3a837cef35);
        vk.IC[19] = Pairing.G1Point(0x1619f430f4338e675f28f5d235082adeced25be4741bdc6a8a55052012e045e, 0x155f8b68f7c07f952dff20679a1c653dff1ffe62da76fcb0085a44c91b4dcbf7);
        vk.IC[20] = Pairing.G1Point(0x18d32c0b7643282ae0001a10d513c36984ff50fbb5925a68ffaf53d1942b52e4, 0xccf343b8b133f1b917bde9c0bc2fc5f58c9a56d9c6d9730b21edc98963a2001);
        vk.IC[21] = Pairing.G1Point(0x31ecd1d1f6d21b7feeb4b1defd60f6dc88ec7b5b37bea98290a162f16a653a5, 0xfea5712759d7b053bd9ad27b4dc35dc2078005946149df16ec5ac5771f2ae33);
        vk.IC[22] = Pairing.G1Point(0xf4bcc027e115b771a30df8e851d3e3076e819c30e0d9272ff18ecd3d5ed4a1, 0x2efe246d911c7738da338549b059ede356dfd7f7dc2536dd53d1d175f2a01b5d);
        vk.IC[23] = Pairing.G1Point(0x293cb6a9143892b4acc02222c910717e63d1c64976a1655e0ad61a1424c310c7, 0x2767ae6614b24003655247def0fda9eac42309ebf9e7d9ee26f8869cb71b51a1);
        vk.IC[24] = Pairing.G1Point(0x151e527d620be66263f0c71274668e4c1788c7506517e01f847ad5fca2ce2f47, 0xf02f38da34b982ea2b7bc9be6db179c2e953522bba9560d6eb4612daecf0663);
        vk.IC[25] = Pairing.G1Point(0x19a608fcc8d3ea70c17c57be31ea66eb866511f714856601d5f3bc55f01ef265, 0x2df1b919882d62f9cadacfa064de88881da0a61173fb7e40b5c3281c8c718ee6);
        vk.IC[26] = Pairing.G1Point(0x2fd20eb698995d49fe8aa61cab89e78720d75047d263ee02c677c29433a83cea, 0x2b333d4b85153ab99b5989a2486ca017ad62b9f769082a75cb1e72e8f7d160f2);
    }
    function verify(uint[] input, Proof proof) internal returns (uint) {
        VerifyingKey memory vk = verifyingKey();
        require(input.length + 1 == vk.IC.length);
        // Compute the linear combination vk_x
        Pairing.G1Point memory vk_x = Pairing.G1Point(0, 0);
        for (uint i = 0; i < input.length; i++)
            vk_x = Pairing.addition(vk_x, Pairing.scalar_mul(vk.IC[i + 1], input[i]));
        vk_x = Pairing.addition(vk_x, vk.IC[0]);
        if (!Pairing.pairingProd2(proof.A, vk.A, Pairing.negate(proof.A_p), Pairing.P2())) return 1;
        if (!Pairing.pairingProd2(vk.B, proof.B, Pairing.negate(proof.B_p), Pairing.P2())) return 2;
        if (!Pairing.pairingProd2(proof.C, vk.C, Pairing.negate(proof.C_p), Pairing.P2())) return 3;
        if (!Pairing.pairingProd3(
            proof.K, vk.gamma,
            Pairing.negate(Pairing.addition(vk_x, Pairing.addition(proof.A, proof.C))), vk.gammaBeta2,
            Pairing.negate(vk.gammaBeta1), proof.B
        )) return 4;
        if (!Pairing.pairingProd3(
                Pairing.addition(vk_x, proof.A), proof.B,
                Pairing.negate(proof.H), vk.Z,
                Pairing.negate(proof.C), Pairing.P2()
        )) return 5;
        return 0;
    }
    event Verified(string s);
    function verifyTx(
            uint[2] a,
            uint[2] a_p,
            uint[2][2] b,
            uint[2] b_p,
            uint[2] c,
            uint[2] c_p,
            uint[2] h,
            uint[2] k,
            uint[26] input
        ) public returns (bool r) {
        Proof memory proof;
        proof.A = Pairing.G1Point(a[0], a[1]);
        proof.A_p = Pairing.G1Point(a_p[0], a_p[1]);
        proof.B = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
        proof.B_p = Pairing.G1Point(b_p[0], b_p[1]);
        proof.C = Pairing.G1Point(c[0], c[1]);
        proof.C_p = Pairing.G1Point(c_p[0], c_p[1]);
        proof.H = Pairing.G1Point(h[0], h[1]);
        proof.K = Pairing.G1Point(k[0], k[1]);
        uint[] memory inputValues = new uint[](input.length);
        for(uint i = 0; i < input.length; i++){
            inputValues[i] = input[i];
        }
        if (verify(inputValues, proof) == 0) {
            emit Verified("Transaction successfully verified.");
            return true;
        } else {
            return false;
        }
    }
}
