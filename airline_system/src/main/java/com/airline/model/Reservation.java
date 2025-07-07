package com.airline.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "reservations")
public class Reservation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(unique = true, nullable = false)
    private String reservationId;
    @ManyToOne
    @JoinColumn(name = "flight_id")
    private Flight flight;
    
    @ManyToOne
    @JoinColumn(name = "passenger_id")
    private Passenger passenger;
    
    private LocalDateTime reservationDate;

    public Reservation() {}

    public Reservation(String reservationId, Flight flight, Passenger passenger, LocalDateTime reservationDate) {
        this.reservationId = reservationId;
        this.flight = flight;
        this.passenger = passenger;
        this.reservationDate = reservationDate;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public String getReservationId() { return reservationId; }
    public void setReservationId(String reservationId) { this.reservationId = reservationId; }
    
    public Flight getFlight() { return flight; }
    public void setFlight(Flight flight) { this.flight = flight; }
    
    public Passenger getPassenger() { return passenger; }
    public void setPassenger(Passenger passenger) { this.passenger = passenger; }
    
    public LocalDateTime getReservationDate() { return reservationDate; }
    public void setReservationDate(LocalDateTime reservationDate) { this.reservationDate = reservationDate; }
} 