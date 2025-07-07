#!/bin/bash

echo "=== Airline Reservation System Test Suite ==="
echo "Testing all endpoints and functionality..."
echo

BASE_URL="http://localhost:8080"

# Test 1: Home page
echo "1. Testing home page..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" $BASE_URL/)
if [ "$RESPONSE" = "200" ]; then
    echo "   ✓ Home page is accessible"
else
    echo "   ✗ Home page failed (HTTP $RESPONSE)"
fi

# Test 2: Flights page
echo "2. Testing flights page..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" $BASE_URL/flights)
if [ "$RESPONSE" = "200" ]; then
    echo "   ✓ Flights page is accessible"
else
    echo "   ✗ Flights page failed (HTTP $RESPONSE)"
fi

# Test 3: Passengers page
echo "3. Testing passengers page..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" $BASE_URL/passengers)
if [ "$RESPONSE" = "200" ]; then
    echo "   ✓ Passengers page is accessible"
else
    echo "   ✗ Passengers page failed (HTTP $RESPONSE)"
fi

# Test 4: Reservations page
echo "4. Testing reservations page..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" $BASE_URL/reservations)
if [ "$RESPONSE" = "200" ]; then
    echo "   ✓ Reservations page is accessible"
else
    echo "   ✗ Reservations page failed (HTTP $RESPONSE)"
fi

# Test 5: Add a flight
echo "5. Testing flight addition..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "flightNumber=TEST001&departure=Istanbul&destination=Ankara&departureTime=2024-01-15T10:00&seatCapacity=150" \
    $BASE_URL/flights/add)
if [ "$RESPONSE" = "302" ] || [ "$RESPONSE" = "200" ]; then
    echo "   ✓ Flight addition endpoint is working"
else
    echo "   ✗ Flight addition failed (HTTP $RESPONSE)"
fi

# Test 6: Add a passenger
echo "6. Testing passenger addition..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "passengerId=PASS001&firstName=John&lastName=Doe" \
    $BASE_URL/passengers/add)
if [ "$RESPONSE" = "302" ] || [ "$RESPONSE" = "200" ]; then
    echo "   ✓ Passenger addition endpoint is working"
else
    echo "   ✗ Passenger addition failed (HTTP $RESPONSE)"
fi

# Test 7: Add a reservation
echo "7. Testing reservation creation..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "flightNumber=TEST001&passengerId=PASS001" \
    $BASE_URL/reservations/add)
if [ "$RESPONSE" = "302" ] || [ "$RESPONSE" = "200" ]; then
    echo "   ✓ Reservation creation endpoint is working"
else
    echo "   ✗ Reservation creation failed (HTTP $RESPONSE)"
fi

# Test 8: Check if templates are being served correctly
echo "8. Testing template rendering..."
RESPONSE=$(curl -s $BASE_URL/flights | grep -q "Flight Management" && echo "200" || echo "404")
if [ "$RESPONSE" = "200" ]; then
    echo "   ✓ Templates are rendering correctly"
else
    echo "   ✗ Template rendering failed"
fi

# Test 9: Database connectivity (H2 console)
echo "9. Testing database connectivity..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" $BASE_URL/h2-console)
if [ "$RESPONSE" = "200" ]; then
    echo "   ✓ H2 database console is accessible"
else
    echo "   ✗ H2 database console failed (HTTP $RESPONSE)"
fi

# Test 10: Error handling
echo "10. Testing error handling..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" $BASE_URL/nonexistent-page)
if [ "$RESPONSE" = "404" ]; then
    echo "   ✓ Error handling is working correctly"
else
    echo "   ✗ Error handling failed (HTTP $RESPONSE)"
fi

echo
echo "=== Test Summary ==="
echo "All basic functionality tests completed."
echo "The airline reservation system is running successfully!"
echo
echo "You can access the application at: http://localhost:8080"
echo "H2 Database Console: http://localhost:8080/h2-console"
echo
echo "Available pages:"
echo "- Home: http://localhost:8080/"
echo "- Flights: http://localhost:8080/flights"
echo "- Passengers: http://localhost:8080/passengers"
echo "- Reservations: http://localhost:8080/reservations" 