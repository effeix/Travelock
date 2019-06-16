from os.path import (
    abspath,
    dirname,
    join
)

# Helper functions for solidity contracts
from solc import (
    compile_files,
    compile_source,
    link_code
)

from web3.contract import ConciseContract


CONTRACTS_PATH = join(dirname(abspath(__file__)), "contracts")

class Contract():

    def __init__(self, name, provider):
        self.provider = provider
        self.name = name
        self.path = f"{join(CONTRACTS_PATH, name)}.sol"
        self.raw = self._read(self.name)
        self.compiled = self._compile(self.raw)
        self.factory = self.provider.contract(
            abi=self._abi(),
            bytecode=self._binary()
        )
        self.constructor = self.factory.constructor()
        self.instance = None
        self.details = {
            "from": self.provider.accounts[0]
        }

    def _read(self, name):
        try:
            with open(self.path, "r") as f:
                return f.readlines()
        except Exception as e:
            print(e)

    def _compile(self, src):
        return compile_source("".join(src))

    def _abi(self):
        return self.compiled[f'<stdin>:{self.name}']['abi']

    def _binary(self):
        return self.compiled[f'<stdin>:{self.name}']['bin']

    def deploy(self): 
        self.hash = self.constructor.transact(
            self.details
        )

        tx_receipt = self.provider.getTransactionReceipt(self.hash)
        self.address = tx_receipt["contractAddress"]

        self.instance = self.provider.contract(
            abi=self._abi(),
            address=self.address,
            ContractFactoryClass=ConciseContract
        )

    def get_details(self):
        return self.details

    def get(self):
        return self.instance
