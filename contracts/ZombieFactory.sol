// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "./Ownable.sol";
import "./lib/SafeMath.sol";

contract ZombieFactory is VRFConsumerBase {
    uint8 dnaDigits = 16;
    uint256 dnaModulus = 10**dnaDigits;
    uint256 cooldownTime = 1 days;

    // bytes32 public keyHash;
    // uint256 public fee;
    // uint256 public randomResult;

    event NewZombie(uint256 zombieId, string name, uint256 dna);

    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;

    struct Zombie {
        string name;
        uint256 dna;
        uint32 level;
        uint32 readyTime;
        uint16 winCount;
        uint16 lossCount;
    }

    Zombie[] public zombies;

    mapping(uint256 => address) public zombieToOwner;
    mapping(address => uint256) ownerZombieCount;

    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomResult;

    constructor()
        VRFConsumerBase(
            0x2bce784e69d2Ff36c71edcB9F88358dB0DfB55b4,
            0x326C977E6efc84E512bB9C30f76E30c160eD06FB
        )
    {
        keyHash = 0x0476f9a745b61ea5c0ab224d3a6e4c99f0b02fce4da01143a4f70aa80ae76e8a;
        fee = 0.1 * 10**18;
    }

    function _createZombie(string memory _name, uint256 _dna) internal {
        zombies.push(
            Zombie(_name, _dna, 1, uint32(block.timestamp + cooldownTime), 0, 0)
        );
        uint256 id = zombies.length - 1;

        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].add(1);

        emit NewZombie(id, _name, _dna);
    }

    function getRandomNumber() public returns (bytes32 requestId) {
        return requestRandomness(keyHash, fee);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness)
        internal
        override
    {
        randomResult = randomness;
    }

    function _generateRandomDna(string memory _str)
        private
        view
        returns (uint256)
    {
        uint256 rand = uint256(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint256 randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}
