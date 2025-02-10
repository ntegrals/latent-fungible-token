# Latent Fungible Tokens on Ethereum - PoC Implementation

![latent fungible token](https://github.com/user-attachments/assets/4d2b5208-5421-4a13-807f-f2025c5e9a05)

This project is a Proof of Concept (PoC) implementation of the Latent Fungible Token (LFT) standard, an extension of
EIP-20 that introduces tokens which transition from non-fungible to fungible after a specified period.

Live demo of the contract can be found on the Sepolia testnet at the following link:

LatentFungibleToken: https://sepolia.etherscan.io/address/0xf265852ecbfcb63d5343c2d03972235f43775226

# Abstract

The Latent Fungible Token (LFT) standard is an extension of EIP-20 that enables tokens to become fungible after an
initial non-fungible period. Once minted, tokens are non-fungible until they reach maturity. At maturity, they become
fungible and can be transferred, traded, and used in any way that a standard EIP-20 token can be used.

This PoC implementation explores the practical aspects of implementing such a standard.

# Motivation

The LFT standard opens up new possibilities in token economics and DeFi applications. Key use cases include:

1. Receipt tokens that do not become active until a certain date or condition is met. For example, this can be used to
   enforce minimum deposit durations in lending protocols.
2. Vesting tokens that cannot be transferred or used until the vesting period has elapsed.
3. Time-locked rewards or incentives in various DeFi protocols.

# Detailed Analysis

### Consequences

#### Pros:

- Enables time-based vesting mechanisms directly within the token contract.
- Allows for more granular control over token distribution and circulation.
- Maintains compatibility with existing ERC-20 infrastructure after maturity.
- Provides a native solution for time-locked tokens without requiring separate vesting contracts.

#### Cons:

- Complexity in user experience, as users need to be aware of maturity periods.
- Potential for confusion if not properly explained to token holders.
- Increased gas costs due to additional checks and storage requirements.
- May require updates to existing DeFi protocols to fully leverage the latent fungibility feature.

### Specification

#### Methods

- **balanceOf**

  Returns the total balance of tokens for a given address, including both matured and non-matured tokens.

  ```solidity
  function balanceOf(address account) public view override returns (uint256)
  ```

- **balanceOfMatured**

  Returns the balance of matured (fungible) tokens for a given address.

  ```solidity
  function balanceOfMatured(address user) external view returns (uint256)
  ```

- **getMints**

  Returns an array of all mint metadata for a given address.

  ```solidity
  function getMints(address user) external view returns (MintMetadata[] memory)
  ```

- **mint**

  Mints new tokens to the specified address with a given maturity delay.

  ```solidity
  function mint(address to, uint256 amount, uint256 delay) public
  ```

#### Structures

- **MintMetadata**

  Stores information about each mint operation.

  ```solidity
  struct MintMetadata {
    uint256 amount;
    uint256 time;
    uint256 delay;
  }
  ```

# Implementation

This PoC implementation of the Latent Fungible Token is a Solidity smart contract that extends the OpenZeppelin ERC20
implementation. Key features include:

- Overridden transfer and transferFrom functions to enforce maturity checks.
- Additional data structures to track mint history and maturity periods.
- New functions to query matured balances and mint metadata.

The implementation aims to balance the unique features of LFTs with gas efficiency and ease of integration with existing
systems.

---

### Resources & Citations

- Fabian Vogelsteller, Vitalik Buterin, "EIP-20: Token Standard," Ethereum Improvement Proposals, no. 20, November 2015.
  [Online serial]. Available: https://eips.ethereum.org/EIPS/eip-20.
- OpenZeppelin. "OpenZeppelin Contracts." GitHub repository. https://github.com/OpenZeppelin/openzeppelin-contracts.
- Cozy Finance, Tony Sheng, Matt Solomon, David Laprade, Payom Dousti, Chad Fleming, Franz Chen, "Latent Fungible
  Tokens: An interface for tokens that become fungible after a period of time." Ethereum Improvement Proposals, no.
  5744, September 2022 Available: https://eips.ethereum.org/EIPS/eip-5744
