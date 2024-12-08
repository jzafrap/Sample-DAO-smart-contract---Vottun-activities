# Sample-DAO-smart-contract---Vottun-activities
Sample DAO smart contract for educational purposes
This smart contract is already deployed on Amoy Testnet at address: 0x97FC8C8fBfD3C4256a00762a321D09eFcb48F7D3

Basic operations:
1. deploy the DAO passing the ERC20 governance token used in the DAO, and the treasury address.
2. token holders can create proposals
3. during lifetime of proposal, token holders can vote for or against proposals.
4. after proposal voting period, if proposal success, call executeProposal() to execute the proposal.

