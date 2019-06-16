var Reservations = artifacts.require ('./Reservations.sol');

module.exports = function(deployer) {
    deployer.deploy(Reservations);
}
