from os.path import (
    abspath,
    dirname,
    join
)
from solc import compile_files
from web3 import Web3


CONTRACTS_PATH = join(dirname(abspath(__file__)), "contracts")


w3 = Web3(Web3.HTTPProvider("http://127.0.0.1:8545"))

def deploy_contract(interface):
    contract = w3.eth.contract(
        abi=interface["abi"],
        bytecode=interface["bin"]
    )

    tx_hash = contract.deploy(
        transaction={
            "from": w3.eth.accounts[1]
        }
    )

    tx_receipt = w3.eth.getTransactionReceipt(tx_hash)
    return tx_receipt["contractAddress"]

contracts = compile_files([join(CONTRACTS_PATH, "Reservations.sol")])
print("PATH", f"{join(CONTRACTS_PATH, 'Reservations.sol')}:Reservations")
main_contract = contracts.pop(f"{join(CONTRACTS_PATH, 'Reservations.sol')}:Reservations")

with open('reservations.json', 'w') as outfile:
    data = {
        "abi": main_contract['abi'],
        "contract_address": deploy_contract(main_contract)
    }
    json.dump(data, outfile, indent=4, sort_keys=True)
