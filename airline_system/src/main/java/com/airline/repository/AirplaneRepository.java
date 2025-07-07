package com.airline.repository;

import com.airline.model.Airplane;
import java.util.*;

public class AirplaneRepository {
    private final Map<String, Airplane> airplanes = new HashMap<>();

    public void addAirplane(Airplane airplane) {
        airplanes.put(airplane.getAirplaneId(), airplane);
    }

    public List<Airplane> getAllAirplanes() {
        return new ArrayList<>(airplanes.values());
    }

    public Airplane getAirplaneById(String airplaneId) {
        return airplanes.get(airplaneId);
    }

    public void removeAirplane(String airplaneId) {
        airplanes.remove(airplaneId);
    }
} 