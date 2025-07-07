package com.airline.model;

public class Airplane {
    private String airplaneId;
    private String model;
    private int seatCapacity;

    public Airplane(String airplaneId, String model, int seatCapacity) {
        this.airplaneId = airplaneId;
        this.model = model;
        this.seatCapacity = seatCapacity;
    }

    public String getAirplaneId() { return airplaneId; }
    public String getModel() { return model; }
    public int getSeatCapacity() { return seatCapacity; }
} 