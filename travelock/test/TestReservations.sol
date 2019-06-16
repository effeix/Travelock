pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import '../contracts/Reservations.sol';

contract TestReservations {
    Reservations res = Reservations(DeployedAddresses.Reservations());

    function beforeEach() public {
        res.createAirline(40, "Ikedair");
        res.createFlight(1, 40, "New York", "Sao Paulo");
        res.reserveSeat(60, 1, 40);
    }

    function testCreateAirline() public {
        uint answer = 42;
        uint created = res.createAirline(answer, "Rochair");

        Assert.equal(created, answer, "IDs do not match!");
    }

    function testCreateDuplicatedAirline() public {
        uint duplicated_id = 40;
        uint created = res.createAirline(duplicated_id, "Rochair");

        Assert.equal(created, 0, "Allowed creation of duplicates!");
    }

    function testCreateFlight() public {
        uint new_id = 2;
        uint created = res.createFlight(new_id, 40, "Dubai", "Toronto");

        Assert.equal(created, new_id, "IDs do not match!");
    }

    function testCreateDuplicatedFlight() public {
        uint new_id = 1;
        uint created = res.createFlight(new_id, 40, "Dubai", "Toronto");

        Assert.equal(created, 0, "Allowed creation of duplicates!");
    }

    function testReserveSeat() public {
        address expected_passenger = address(this);
        uint new_id = 68;
        
        res.reserveSeat(new_id, 1, 40);
        address passenger = res.getSeatOwner(new_id);

        Assert.equal(passenger, expected_passenger, "Addresses do not match!");
    }

    // function testReserveDuplicatedSeat() public {
    //     address expected_passenger = address(0);
    //     uint new_id = 60;

    //     uint created = res.reserveSeat(new_id, 1, 40);
    //     address passenger = res.getSeatOwner(new_id);

    //     Assert.equal(passenger, expected_passenger, "Allowed creation of duplicates!");
    //     Assert.equal(created, 0, "Allowed creation of duplicates!");
    // }
}
