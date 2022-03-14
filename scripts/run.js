const main = async() => {
  const nftContractFactory = await hre.ethers.getContractFactory("FirstNFT");
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log("Contract deployed to: ", nftContract.address);

  // call the function.
  let txn = await nftContract.makeNFT()
  // wait for it to be mined.
  await txn.wait()

  // txn = await nftContract.makeNFT()
  // await txn.wait()
}

const runMain = async () => {
  try {
    await main()
    process.exit(0)
  } catch (err) {
    console.error(err);
    process.exit(1)
  }
}

runMain()