const { expect } = require("chai");

describe("Eimer Punks Contract", () => {
  const setup = async ({ maxSupply = 10000 }) => {
    const [owner] = await ethers.getSigners();
    const EimerPunks = await ethers.getContractFactory("EimerPunks");
    const deployed = await EimerPunks.deploy(maxSupply);

    return {
      owner,
      deployed,
    };
  };

  describe("Deployment", () => {
    it("Sets max supply to passed param", async () => {
      const maxSupply = 4000;

      const { deployed } = await setup({ maxSupply });

      const returnedMaxSupply = await deployed.maxSupply();
      expect(maxSupply).to.equal(returnedMaxSupply);
    });
  });

  describe("Minting", () => {
    it("Mints a new token and assigns it to owner", async () => {
      const { owner, deployed } = await setup({});

      await deployed.safeMint();

      const ownerOfMinted = await deployed.ownerOf(0);

      expect(ownerOfMinted).to.equal(owner.address);
    });

    it("Has a minting limit", async () => {
      const maxSupply = 2;

      const { deployed } = await setup({ maxSupply });

      // Mint all
      await Promise.all([deployed.safeMint(), deployed.safeMint()]);

      // Assert the last minting
      await expect(deployed.safeMint()).to.be.revertedWith(
        "No EimerPunks left :("
      );
    });
  });

    describe("tokenURI", () => {
      it("returns valid metadata", async () => {
        const { deployed } = await setup({});

        await deployed.safeMint();

        const tokenURI = await deployed.tokenURI(0);
        const stringifiedTokenURI = await tokenURI.toString();
        const [, base64JSON] = stringifiedTokenURI.split(
          "data:application/json;base64,"
        );
        const stringifiedMetadata = await Buffer.from(
          base64JSON,
          "base64"
        ).toString("ascii");

        const metadata = JSON.parse(stringifiedMetadata);

        expect(metadata).to.have.all.keys("name", "description", "image");
      });
    });
});