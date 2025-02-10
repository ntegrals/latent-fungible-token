import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  const tokenName = "Latent Fungible Token";
  const tokenSymbol = "LFT";

  const latentFungibleToken = await deploy("LatentFungibleToken", {
    from: deployer,
    args: [tokenName, tokenSymbol],
    log: true,
  });

  console.log(`LatentFungibleToken contract: `, latentFungibleToken.address);

  // Optional: Mint some tokens to the deployer
  if (hre.network.name !== "mainnet") {
    // Only mint on non-mainnet networks
    const LFTContract = await hre.ethers.getContractAt("LatentFungibleToken", latentFungibleToken.address);
    const mintAmount = hre.ethers.parseEther("1000"); // Mint 1000 tokens
    const maturityDelay = 60 * 60 * 24 * 7; // 7 days in seconds

    await LFTContract.mint(deployer, mintAmount, maturityDelay);
    console.log(
      `Minted ${hre.ethers.formatEther(mintAmount)} LFT tokens to ${deployer} with a ${maturityDelay} second maturity delay`,
    );
  }
};

export default func;
func.id = "deploy_latent_fungible_token"; // id required to prevent reexecution
func.tags = ["LatentFungibleToken"];
