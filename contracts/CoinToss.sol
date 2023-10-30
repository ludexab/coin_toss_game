// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract CoinToss {

    constructor () public payable {
        //  This is to enable contract admin send some crypto during deployment before any user can use the contract,
        //  to avoid always having to revert the transaction if the first rule of the game is not satisfied.
    }


    //  PAYMENT OPTIONS
    //  1. Pay the user nothing
    //  2. Pay the user double of amount sent
    

    //  Payment probabilities
    //  Pay user double = 49.9% and below, payUserDouble = 50.1% and above

   //   CummulativeProbability = [49, 100] --> [49.9%, 49.9+50.1 %] ,removing the denominator to create a non floating number 
   event paymentEvent(
       string decision,
       uint amount
   );

    function determinePaymentOption() internal view returns(uint){
        //  Creating some randomness
        uint256 randNum = (uint256(
            keccak256(
                abi.encodePacked(
                    block.number,
                    block.timestamp,
                    block.difficulty,
                    msg.sender)
                )
            ) % 101) + 1;  //  ensure we have a number within 1-100 (bounds inclusive)

        // skewing the payment towards not paying any amount.
        if(randNum < 49){
            return 0; // return 0 to pay user Double
        } else{
            return 1; // return 1  to pay user Nothing
        }
    }

    function payUser(uint _amount, address _userAddress) internal {
        payable(_userAddress).transfer(_amount);
    }

    function receive() public payable {
        require(msg.value < address(this).balance, "Rule 1. Amount cannot be greater than treasury balance");
        uint paymentDecision = determinePaymentOption();
        if (paymentDecision == 0 && address(this).balance >= msg.value*2){ //   Ensure the treasury has enough balance to pay user double of amount sent
            payUser(msg.value*2, msg.sender);
            emit paymentEvent("Paying User Double of Sent Crypto", msg.value *2);
        }else{
            emit paymentEvent("Paying Nothing to The User", 0);
        }
    }

    function treasury() public view returns(uint){ //   Returns current treasury balance
        return address(this).balance;
    }
}
