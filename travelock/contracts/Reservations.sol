pragma solidity ^0.4.25;

contract Reservations {
    struct Seat {
        address passenger;
        bool exists;
    }

    struct Flight {
        uint max_seats;
        uint seat_count;
        uint[] seats;
        bytes32 origin;
        bytes32 dest;
        bool exists;
    }

    struct Airline {
        bytes32 name;
        uint[] flights;
        uint flight_count;
        uint max_flight_count;
        bool exists;
    }

    // These mappings keep track of all objects created by this contract.
    // The structs above are gonna reference these by id.
    // Example:
    //     if flight 39 belongs to airline 10, flights mapping is going to have
    //     flights[39] => some flight struct, and struct airline[10] is going to
    //     have 39 as one of the elements in its flights array. The same goes
    //     for seats.
    mapping(uint => Airline) public airlines;
    mapping(uint => Flight) public flights;
    mapping(uint => Seat) public seats;

    uint next_airline_id = 1;
    uint airline_count = 0;

    function createAirline(bytes32 name)
            public returns (uint) {

        if (airlines[next_airline_id].exists) {
            return 0;
        }

        airlines[next_airline_id++] = Airline(
            name,
            new uint[](10),
            0,   // initial flight count
            10, // max flights allowed
            true
        );

        airline_count++;

        return airline_count;
    }

    function createFlight(uint id, uint airline_id, bytes32 orig,
            bytes32 dest) public returns (uint) {

        // Get airline, check if it exists and if we can add more flights
        Airline storage airline = airlines[airline_id];
        require(airline.exists, "Airline does not exist");
        require(airline.flight_count < airline.max_flight_count,
            "This airline does not support more flights!");

        // If the flight does not exist in global flights, create it
        if(!flights[id].exists) {
            flights[id] = Flight(
                255, // max seats allowed
                0,   // initial seat count
                new uint[](255),
                orig,
                dest,
                true
            );

            // Add the new flight to the current airline
            airline.flights[airline.flight_count] = id;
            airline.flight_count++;
        }
        else {
            return 0;
        }

        return id;
    }

    function reserveSeat(uint id, uint flight_id, uint airline_id)
            public returns (uint) {

        Airline storage airline = airlines[airline_id];
        require(airline.exists, "Airline does not exist!");

        Flight storage flight = flights[flight_id];
        require(flight.exists, "Flight does not exist!");
        require(flight.seat_count < flight.max_seats, "This flight is full!");

        if(!seats[id].exists) {
            seats[id] = Seat(
                msg.sender,
                true
            );

            flight.seats[flight.seat_count] = id;
            flight.seat_count++;
        }
        else {
            return 0;
        }

        return id;
    }

    function getSeatOwner(uint seat_id) public view returns (address) {
        return seats[seat_id].passenger;
    }

    function compare(string _a, string _b) public returns (int) {
        bytes memory a = bytes(_a);
        bytes memory b = bytes(_b);
        uint minLength = a.length;
        if (b.length < minLength) minLength = b.length;
        //@todo unroll the loop into increments of 32 and do full 32 byte comparisons
        for (uint i = 0; i < minLength; i ++)
            if (a[i] < b[i])
                return -1;
            else if (a[i] > b[i])
                return 1;
        if (a.length < b.length)
            return -1;
        else if (a.length > b.length)
            return 1;
        else
            return 0;
    }
    /// @dev Compares two strings and returns true iff they are equal.
    function equal(string _a, string _b) public returns (bool) {
        return compare(_a, _b) == 0;
    }

}
