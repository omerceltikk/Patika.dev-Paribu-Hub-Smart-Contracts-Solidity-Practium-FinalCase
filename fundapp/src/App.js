import { Box, Heading, Center, Flex, Text, Grid, Button, Input, GridItem } from '@chakra-ui/react';
import { useState, useEffect } from 'react';
import useConnection from './hooks/useConnection';
import useContract from './hooks/useContract';
import { fundAddress } from './config.js';
import fundjson from "./metadata/fundabi.json"


function App() {
  //deposit, transfer veya withdraw edilmek istenen tutar
  const [amount, setAmount] = useState(0);
  const [address, userAddress] = useState("")
  //kullanıcı bakiyesini tutan state
  const [balance, setBalance] = useState(0);

  const connection = useConnection();
  const contract = useContract(fundAddress, fundjson.abi);

  const investMoney = async () => {
    const txn = await contract.deposit({ value: amount });
    await txn.wait();
    userBalance();
  }

 
  const startFund = async () => {
    const txn = await contract.deposit({ value: amount });
    await txn.wait();
    userBalance();
  }
  const cancel = async () => {
    userBalance();
  }
  const milestone = async () => {
    const txn = await contract.deposit({ value: amount });
    await txn.wait();
    userBalance();
  }
  const withdraw = async () => {
    userBalance();
  }
  const reward = async () => {
    userBalance();
  }

  const userBalance = async () => {
    const data = await contract.viewBalance(connection.address);
    setBalance(data.toNumber());
  }

  useEffect(() => {
    connection.connect();
    if (connection.address) {
      userBalance();
      userAddress(connection.address)
    }else{userAddress("")}
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

              size='xl'>ZetToken Fund App</Heading>
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
                <Text  as='b' fontSize='md'>
                  User Balance:<br></br>
                  <Text fontWeight="400">{balance}
                  </Text>
                </Text>
                <Text as='b' fontSize='md'>
                  Start At:<br></br>
                  <Text fontWeight="400">asda
                  </Text>
                </Text>
                <Text as='b' fontSize='md'>End At:
                  <br></br>
                  <Text fontWeight="400">asda
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
                <Button onClick={investMoney} colorScheme='green'>BUY</Button>
                <Input type="number" onChange={(e) => setAmount(e.target.value)} placeholder="Ethers to ZTN" />
                <Button onClick={startFund} colorScheme='green'>START FUND</Button>
                <Input type="number" onChange={(e) => setAmount(e.target.value)} placeholder="Ethers to ZTN" />
                <GridItem colSpan={2}>
                  <Button onClick={cancel} rowSpan="" width="100%" colorScheme='red'>CANCEL FUND</Button>
                </GridItem>
                <Button onClick={milestone} colorScheme='purple'> MILESTONE</Button>
                <Button onClick={withdraw} colorScheme='purple'>WITHDRAW</Button>
              </Grid>

              <Button mt={6} onClick={reward} colorScheme='purple' width="100%">REWARD</Button>
            </Box>
          </Box>
        </section>
      </Box>
    </Center>
    </Box>
  );
}

export default App;
