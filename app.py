from web3 import Web3
import json

infura_url = 'https://ropsten.infura.io/v3/ecb7d87db9b54cf4b990e11a68023008'
address = '0x9BB5C8A74C15e50A3ec99bfc4547085B2068F82C'
contract_address = '0xb61186297354fB162A066eb57bd35d2c3B700C4B'
private_key = '8142dc4e284a285cadf57d7ead6ff7a28d6d112027a403fc5e3e046cf4445ac6'

w3 = Web3(Web3.HTTPProvider(infura_url))
w3.eth.defaultAccount = address
balance = w3.eth.getBalance(address)
print(w3.fromWei(balance, 'ether'))

with open('rosreestr.abi') as f:
    abi = json.load(f)

contract = w3.eth.contract(address=contract_address, abi=abi)

print(contract.functions.GetOwner().call())

nonce = w3.eth.getTransactionCount(address)

empl_tr = contract.functions.AddEmployee('0x656c7A6b11351A10f4A2aa6E1d7fBAFCA6680aE7', 'Ivanov Ivan', 'Manager', '+79241234567').buildTransaction({
    'gas': 3000000,
    'gasPrice': w3.toWei('1', 'gwei'),
    'from': address,
    'nonce': nonce,
})
signed_tr = w3.eth.account.signTransaction(empl_tr, private_key=private_key)
w3.eth.sendRawTransaction(signed_tr.rawTransaction)

print(contract.functions.GetEmployee('0x656c7A6b11351A10f4A2aa6E1d7fBAFCA6680aE7').call())