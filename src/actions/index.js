import {TEST,SEND,PROOF,USER,STAGE,PROOF_TOO} from './types';

export function switchUser(user) {
    return function(dispatch) {
        dispatch({
            type: USER,
            payload: user
        });
    }
}

export function makeProof() {
    return function(dispatch) {
      console.log("Trigger makeProof...");
      let data = 
        `A = Pairing.G1Point(0x1a0ce61d97267d6d5684cd12d08b79e6222a2ce0f3186d3b47e2fa0fdb852342, 0x610c3d9c236e22616a78bf0d8489a26a1f3e473634d88dd18214b32c9d10873);A_p = Pairing.G1Point(0x19d76d470de6ca80835212286e292ac8ecb0056dfafae3bb6b3d0a39e724cb19, 0x275f9218eb8819f5d64745ef1ec6f479e68804384fee54dbea93015ac48a37ec);
        B = Pairing.G2Point([0x176f8251f1fec1000570ed8b942e2c992170712ea9e95cd859e5078f6f812cfa, 0x2547db7dd85996124f9e78dcd8446ec5ac5c986b9bf074334478686ef1863ecd], [0x14a8c2e1e28429028c64fd90b6f21a6af82417d3438aebd6f76756642138ec9d, 0x438cae7eafec15e761e486fc51050048c90c504cba788c9cb2401dfd479984e]);
        B_p = Pairing.G1Point(0xf0afa6a4e9c778624d4f76615626183bf6558178452a53981c8ab15bcc53927, 0x27de02f67186138d74b1a85c893f35b27e54b38ebed45bd4792bc769c08a25b9);
        C = Pairing.G1Point(0x28f46d85cc24895b647db39ac506b8b0bc8cbbc83a07d9bb9c06000f92288fac, 0x115842bd01d697e94d3aaa906731bd8781992437c03dd443bee5ac0c490c1fae);
        C_p = Pairing.G1Point(0xd623c2ff93844212ea330244b696acb1cbe2c7ee9d357ef895a4d2c38c2a986, 0x26f03852fb8429fc8a2679b13ebd07d1fbfbe5ba3a8da0d1753f8663427f4a61);
        H = Pairing.G1Point(0x12eb0ccbb1e0dea1713af139ddfc7ef85c20ff1823cea0ac4c946d422fd1a0a2, 0x3bda0fb6d3279f7234e78707d30d13d9c362dd95e0b0d732b2546d331bce8e6);
        K = Pairing.G1Point(0x231fcee067a2df72d4392f19c6260cb7ab55fe3684b625c7b6499c1d20437e3e, 0x1140d353ecab18fdd3231203b06416d5d4d456c2a6ee17b5ae5d3f38ed02442);`;
      dispatch({
        type: PROOF,
        payload: data
      });
    }
}

export function makeProofToo() {
    return function(dispatch) {
    console.log("Trigger makeProof...");
    let data = 
      `A = Pairing.G1Point(0x23212100692da7890bd60e50c1f70d7fd17ea1924b1d892ec98c9a414d2643fb, 0x2bb05073fd5da4a421b91194a882a68c165edd599808dd2210e0d28d7adc0a0a);
      A_p = Pairing.G1Point(0x1efeb7f60637e1a02ab6c6e56c9f2a62391b1b3b01828681a2eb8ede6e1c934c, 0x2d8b3a6ceca9e1c469c61775182e32fbd4da5faf12c3556ef4478937445acb43);
      B = Pairing.G2Point([0x1d096c9c45ee978859f15ee6105f6667dd1b43be580cc458437c64bdbb9a5e, 0x26fe47a23ab1852fbd8bfb841332c777f07bb3b8287d0a3c9b1ed0858cada8dc], [0x2a6c829b65420bd32a49e522a143736b5c08d25e3c3f1b32b8994b049e14adc9, 0x28fd59e621244d9ad15831fe651ea549c5310c75c1b37fedd74e6bd8f9f3508b]);
      B_p = Pairing.G1Point(0x29df5843ef74ba3f4f943ff5a5a0b1cba036bdba71dcd8caa4ac7037c083bb7, 0x2a5b88dd175ce51fa82734b85ac144245900219615f2662f7c668ac883a96ea2);
      C = Pairing.G1Point(0x1c1c5c72b42683334e0bdaaaa959bef7f795850580692ec8f8c7ce1ddbb61cd8, 0x1b4f5bd4a165203b16e4761e2698bd99cc2b437d32165a3a337ee8a5f05d556);
      C_p = Pairing.G1Point(0xaa8604b95adf310aeee5b33d91dea5ed7c92be44a6849a345980de5c85f35b3, 0x2b8009ba783c6433aba1aa35f1a55b4096ee3a9cad37020dabb950fd30eac3a0);
      H = Pairing.G1Point(0x2962b58b6a552d5844d5c33332dad2aac10e876966d84864ee510d8ff53166fb, 0x309e4794fb1f5fa731afd74040baf399cae18a15dd5128e9912114e98199ced);
      K = Pairing.G1Point(0x844d46061e9b7f48680869d811ad53b54c2f306fd10861d25118550eda2502c, 0x2da8701c62974fc92ea0d40ac77ee44aac07105302d6aea7c127bba7a33e46b9);`;
      dispatch({
        type: PROOF_TOO,
        payload: data
      });
    }
}

export function moveStage(stage) {
    console.log("Trigger moveStage...", stage)
    return function(dispatch) {
        dispatch({
            type: STAGE,
            payload: stage
        });
    }
}