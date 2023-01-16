import { Box, Heading, Center, Flex, Text, Grid, Button, Input, GridItem } from '@chakra-ui/react';
import { useState, useEffect } from 'react';
import useConnection from './hooks/useConnection';
import useContract from './hooks/useContract';
import { _contractAddress } from './config.js';
import _contractAbi from "./metadata/zettokengameabi.json"


function App() {
  //deposit, transfer veya withdraw edilmek istenen tutar
  const [amount, setAmount] = useState(0);
  const [address, userAddress] = useState("");
  const [startAt, setStartAt] = useState(false);
  //kullanıcı bakiyesini tutan state
  const [balance, setBalance] = useState(0);
  const [id, setId] = useState(0)
  // const [time , userTime] = useState("")
  const now = new Date();
  


  const connection = useConnection();
  const contract = useContract(_contractAddress, _contractAbi.abi);

  const investTokens = async () => {
    const txn = await contract.investTokens(amount);
    await txn.wait();
    userBalance();
  }
  const gameStart = async () => {
    const txn = await contract.gameStart();
    await txn.wait();
    await setStartAt(true);
    // await startAt ? userTime(now) : userTime("");
  }

  const buyItem = async () => {
    const txn = await contract.buyItem(id,amount);
    await txn.wait();
    userBalance();
  }
  const sellItem = async () => {
    const txn = await contract.sellItem(id,amount);
    await txn.wait();
    userBalance();
  }
  const prepareToken = async () => {
    const txn = await contract.prepareToken();
    await txn.wait();
  }
  const takeToken = async () => {
    const txn = await contract.takeToken();
    await txn.wait();
  }
  const reward = async () => {
    const txn = await contract.reward();
    await txn.wait();
  }

  const userBalance = async () => {
    const data = await contract.userBalance(connection.address);
    setBalance(data.toNumber());
  }

  useEffect(() => {
    connection.connect();
    if (connection.address) {
      userBalance();
      userAddress(connection.address)
    } else { userAddress("") }
  }, [connection.address])


  return (
   
   <Box bgColor="#093657">
      <Center h="100vh">
        <Box
          borderRadius="10px"
          p="5"
          alignItems="center"
          w="xl"
          bgColor="#fff"
          as='container'>
          <Box
            display="flex"
            justifyContent="center">
            <Box>
              <Heading
                borderBottom="1px"
                color="#093657"
                p={4} as='h2'

                size='xl'>ZetToken Game App</Heading>
            </Box>
          </Box>
          <br></br>
          <section>
            <Box display="flex"
              justifyContent="center">
              <Box borderBottom="1px"
                p="4"
                width="70%">
                <Text as='b' fontSize='md'>
                  User Address:<br></br>
                  <Text mb={8} fontSize='sm' display="flex" width="40%" fontWeight="400">{connection.address}
                  </Text>
                </Text>
                <Grid templateColumns='repeat(3, 1fr)' gap={6}>
                  <Text as='b' fontSize='md'>
                    User Balance:<br></br>
                    <Text fontWeight="400">
                      {connection.address ? "" : "000000"}
                    </Text>
                  </Text>
                  <Text as='b' fontSize='md'>
                    Start At:<br></br>
                    <Text fontWeight="400">
                      {startAt ? null : null}
                    </Text>
                  </Text>
                  <Text as='b' fontSize='md'>Status:
                    <br></br>
                    <Text fontWeight="400">{connection.address ? "connected" : "not connected"}
                    </Text>
                  </Text>
                </Grid>
              </Box>
            </Box>
            <Box
              display="flex"
              justifyContent="center">
              <Box
                mt={6}
                p="4"
                width="70%">
                <Grid templateColumns='repeat(2, 1fr)' gap={6}>
                  <Button onClick={investTokens} colorScheme='green'>BUY TOKEN</Button>
                  <Input type="number" onChange={(e) => setAmount(e.target.value)} placeholder="Ethers to ZTN" />
                  <GridItem colSpan={2}>
                      <Button width="100%" onClick={gameStart} colorScheme='green'>
                        START STAKE
                        </Button>
                  </GridItem>
                      <Button onClick={buyItem} colorScheme='green'>
                        BUY ITEM
                        </Button>
                  <GridItem colSpan={1}>
                    <Input type="number"
                      fontSize='xs'
                      mr={1}
                      width="45%"
                      onChange={(e) => setAmount(e.target.value)}
                      placeholder="amount" />
                    <Input type="number" fontSize='xs'
                      width="50%"
                      onChange={(e) => setId(e.target.value)}
                      placeholder="item id.." />
                  </GridItem>
                      <Button onClick={sellItem} colorScheme='red'>
                        SELL ITEM
                        </Button>
                  <GridItem colSpan={1}>
                    <Input type="number"
                      fontSize='xs'
                      mr={1}
                      width="45%"
                      onChange={(e) => setAmount(e.target.value)}
                      placeholder="amount" />
                    <Input type="number" fontSize='xs'
                      width="50%"
                      onChange={(e) => setId(e.target.value)}
                      placeholder="item id.." />
                  </GridItem>
                      <Button onClick={prepareToken} colorScheme='blue'>
                        PREPARE ITEM
                        </Button>
                      <Button onClick={takeToken} colorScheme='blue'>
                        TAKE ITEM
                        </Button>
                  </Grid>
                <Button mt={6} onClick={reward} colorScheme='blue' width="100%">
                  REWARD
                </Button>
              </Box>
            </Box>
          </section>
        </Box>
      </Center>
    </Box>
  );
}

export default App;
