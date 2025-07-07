package com.airline.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "flights")
public class Flight {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(unique = true, nullable = false)
    private String flightNumber;
    private String departure;
    private String destination;
    private LocalDateTime departureTime;
    private int seatCapacity;
    private int availableSeats;

    public Flight() {}

    public Flight(String flightNumber, String departure, String destination, LocalDateTime departureTime, int seatCapacity) {
        this.flightNumber = flightNumber;
        this.departure = departure;
        this.destination = destination;
        this.departureTime = departureTime;
        this.seatCapacity = seatCapacity;
        this.availableSeats = seatCapacity;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public String getFlightNumber() { return flightNumber; }
    public void setFlightNumber(String flightNumber) { this.flightNumber = flightNumber; }
    
    public String getDeparture() { return departure; }
    public void setDeparture(String departure) { this.departure = departure; }
    
    public String getDestination() { return destination; }
    public void setDestination(String destination) { this.destination = destination; }
    
    public LocalDateTime getDepartureTime() { return departureTime; }
    public void setDepartureTime(LocalDateTime departureTime) { this.departureTime = departureTime; }
    
    public int getSeatCapacity() { return seatCapacity; }
    public void setSeatCapacity(int seatCapacity) { this.seatCapacity = seatCapacity; }
    
    public int getAvailableSeats() { return availableSeats; }
    public void setAvailableSeats(int availableSeats) { this.availableSeats = availableSeats; }
} 