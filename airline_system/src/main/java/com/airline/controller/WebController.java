package com.airline.controller;

import com.airline.model.Flight;
import com.airline.model.Passenger;
import com.airline.model.Reservation;
import com.airline.service.FlightService;
import com.airline.service.ReservationService;
import com.airline.repository.PassengerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Controller
public class WebController {

    @Autowired
    private FlightService flightService;

    @Autowired
    private ReservationService reservationService;

    @Autowired
    private PassengerRepository passengerRepository;

    @GetMapping("/")
    public String home(Model model) {
        List<Flight> flights = flightService.getAllFlights();
        List<Passenger> passengers = passengerRepository.findAll();
        List<Reservation> reservations = reservationService.getAllReservations();
        
        model.addAttribute("flights", flights);
        model.addAttribute("passengers", passengers);
        model.addAttribute("reservations", reservations);
        return "index";
    }

    @GetMapping("/flights")
    public String flights(Model model) {
        List<Flight> flights = flightService.getAllFlights();
        model.addAttribute("flights", flights);
        model.addAttribute("newFlight", new Flight());
        return "flights";
    }

    @PostMapping("/flights/add")
    public String addFlight(@ModelAttribute Flight flight, 
                           @RequestParam String departureTimeStr) {
        try {
            LocalDateTime departureTime = LocalDateTime.parse(departureTimeStr, 
                DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
            flight.setDepartureTime(departureTime);
            flight.setAvailableSeats(flight.getSeatCapacity());
            flightService.addFlight(flight);
        } catch (Exception e) {
        }
        return "redirect:/flights";
    }

    @GetMapping("/passengers")
    public String passengers(Model model) {
        List<Passenger> passengers = passengerRepository.findAll();
        model.addAttribute("passengers", passengers);
        model.addAttribute("newPassenger", new Passenger());
        return "passengers";
    }

    @PostMapping("/passengers/add")
    public String addPassenger(@ModelAttribute Passenger passenger) {
        passengerRepository.save(passenger);
        return "redirect:/passengers";
    }

    @GetMapping("/reservations")
    public String reservations(Model model) {
        List<Reservation> reservations = reservationService.getAllReservations();
        List<Flight> flights = flightService.getAllFlights();
        List<Passenger> passengers = passengerRepository.findAll();
        
        model.addAttribute("reservations", reservations);
        model.addAttribute("flights", flights);
        model.addAttribute("passengers", passengers);
        return "reservations";
    }

    @PostMapping("/reservations/add")
    public String addReservation(@RequestParam String flightNumber, 
                                @RequestParam String passengerId) {
        try {
            reservationService.createReservation(flightNumber, passengerId);
        } catch (Exception e) {
        }
        return "redirect:/reservations";
    }
} 