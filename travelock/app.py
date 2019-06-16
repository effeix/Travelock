import json
import os

# Microframework for REST APIs
from flask import (
    Flask,
    jsonify,
    render_template,
    request
)

# Web3 is an interface between python and ethereum
from web3 import Web3, HTTPProvider

from contract import Contract


# Flask setup
app = Flask(__name__)

# Ethereum Network setup
eth = Web3(HTTPProvider("http://localhost:8545")).eth

reservations = Contract("Reservations", eth)
reservations.deploy()

@app.route("/", methods=["GET"])
def index():
    contract = reservations.get()
    
    return jsonify({"name": reservations.name})

@app.route("/airlines", methods=["GET", "POST"])
def airlines():
    contract = reservations.get()

    if request.method == "POST":
        data = json.loads(request.data)
        name = data.get("name")

        contract.createAirline(name.encode(), transact=reservations.get_details())

        return jsonify({"name": name})

@app.route("/airlines/<int:aid>/flights", methods=["POST"])
def airline_flights(aid):
    contract = reservations.get()

    if request.method == "POST":
        data =json.loads(request.data)
        orig = data.get("orig")
        dest = data.get("dest")
        flight_id = int(data.get("flight_id"))
        
        contract.createFlight(flight_id, int(aid), orig.encode(), dest.encode())

        return jsonify({
            "message": "RESOURCE_CREATED",
            "type": "flight",
            "origin": orig,
            "destiny": dest,
            "id": flight_id
        })

@app.route("/book", methods=["POST"])
def book():
    contract = reservations.get()

    if request.method == "POST":
        data = json.loads(request.data)

        seat_number = data.get("seat_number")
        flight_number = data.get("flight_number")
        airline_number = data.get("airline_number")

        try:
            contract.reserveSeat(
                int(seat_number),
                int(flight_number),
                int(airline_number),
                transact=reservations.get_details()
            )
        except ValueError as ve:
            print(ve)
            return jsonify({"error": ""})

        return jsonify({"booked": True})

    return jsonify({})
        
if __name__ == "__main__":
    app.run(debug=True, use_reloader=False)
