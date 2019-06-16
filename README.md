# Travelock
Intelligent system for airplane sits using blockchain

# Business Model
One of the main problems with airplanes is the sit reservation. There are four or five main systems that offer the same flights all over the world. Since these systems are not linked to each other, sometimes people are able to book the same sit in the same flight. This is one of the main reasons for overbooking problems. If we had a blockchain implementation capable of maintainig history of sits booked that would be used by all major companies, there would be proof of who reserved the sit first and maybe trigger a script that changes the sit automatically. The companies would be insterested in validating the bookings (transactions), as a mean to mitigate this problem. Companies validating transactions could be rewarded with some kind of "credit" (that has an intrinsec value that would serve as discounts for fuel, new aircrafts, etc.

# Dependencies
- ganache-cli
- truffle
- python 3
- flask
- solidity 0.4.25

# Usage
Run ganache-cli. Then , run app.py as below

```sh
$ export FLASK_APP=app.py
$ flask run
```

The contract is going to be deployed and the API server is running on localhost, port 5000 and ready to used.

If you are getting the error
```
Invalid option to --combined-json: clone-bin
```
then your solidity compiler might be of a different version of what was used in this program. Try installing the right version.

# Install solidity v0.4.25
```sh
$ python -m solc.install v0.4.25
```

and the set the path to the new version
```sh
$ export SOLC_BINARY=$HOME/.py-solc/solc-v0.4.25/bin/solc
```
