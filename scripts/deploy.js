const { ethers } = require("hardhat");

// deploy is an asynchronus funtion
const deploy = async() => {
    // getSigners() brings the information from configuratipn where the private key is stored.
    // deployer is an objet that allows deploy an smart contract in the configured network. Hardhat will fill automatically.
    const [deployer] = await ethers.getSigners();
    console.log("Deploying smart contract with the account:", deployer.address);

    // Definig the SC PlatziPunks in the context
    // ethers.getContractFactory() gets informationn from build cache and brings the required information to create the methods and deploy the SC.
    const PlatziPunks = await ethers.getContractFactory("PlatziPunks");
    // Creating instance of deployed SC.
    const deployed = await PlatziPunks.deploy();
    console.log("PlatziPunks is deployed at: ", deployed.address);
}

// Calling deploy() function
deploy()
    // process.exit(0): Process completed then close it.
    .then(() => process.exit(0))
    .catch((error) => {
        console.log(error);
        // process.exit(1): Process with an error then close it.
        process.exit(1);
    });