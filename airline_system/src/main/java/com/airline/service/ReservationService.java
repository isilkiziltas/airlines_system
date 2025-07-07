package com.airline.service;

import com.airline.model.Flight;
import com.airline.model.Passenger;
import com.airline.model.Reservation;
import com.airline.repository.FlightRepository;
import com.airline.repository.PassengerRepository;
import com.airline.repository.ReservationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
public class ReservationService {
    @Autowired
    private ReservationRepository reservationRepository;
    
    @Autowired
    private FlightRepository flightRepository;
    
    @Autowired
    private PassengerRepository passengerRepository;

    public Reservation createReservation(String flightNumber, String passengerId) {
        Flight flight = flightRepository.findByFlightNumber(flightNumber);
        Passenger passenger = passengerRepository.findByPassengerId(passengerId);
        if (flight == null || passenger == null) {
            throw new IllegalArgumentException("Uçuş veya yolcu bulunamadı.");
        }
        if (flight.getAvailableSeats() <= 0) {
            throw new IllegalStateException("Uygun koltuk yok.");
        }
        flight.setAvailableSeats(flight.getAvailableSeats() - 1);
        flightRepository.save(flight);
        String reservationId = UUID.randomUUID().toString();
        Reservation reservation = new Reservation(reservationId, flight, passenger, LocalDateTime.now());
        reservationRepository.save(reservation);
        return reservation;
    }

    public List<Reservation> getAllReservations() {
        return reservationRepository.findAll();
    }

    public Reservation getReservationById(String reservationId) {
        return reservationRepository.findByReservationId(reservationId);
    }
} 