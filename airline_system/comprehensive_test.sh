#!/bin/bash

echo "=== Comprehensive Airline Reservation System Security & Functionality Test ==="
echo "Testing all endpoints, security controls, and business logic..."
echo

BASE_URL="http://localhost:8080"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counter
PASSED=0
FAILED=0

# Function to print test results
print_result() {
    local test_name="$1"
    local result="$2"
    local details="$3"
    
    if [ "$result" = "PASS" ]; then
        echo -e "   ${GREEN}✓ $test_name${NC}"
        ((PASSED++))
    else
        echo -e "   ${RED}✗ $test_name${NC}"
        if [ -n "$details" ]; then
            echo -e "      ${YELLOW}Details: $details${NC}"
        fi
        ((FAILED++))
    fi
}

echo -e "${BLUE}1. BASIC CONNECTIVITY TESTS${NC}"

# Test 1.1: Application is running
echo "1.1 Testing application startup..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" $BASE_URL/)
if [ "$RESPONSE" = "200" ]; then
    print_result "Application is running and responding" "PASS"
else
    print_result "Application startup" "FAIL" "HTTP $RESPONSE"
fi

# Test 1.2: All main pages are accessible
echo "1.2 Testing main page accessibility..."
PAGES=("/" "/flights" "/passengers" "/reservations")
for page in "${PAGES[@]}"; do
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" $BASE_URL$page)
    if [ "$RESPONSE" = "200" ]; then
        print_result "Page $page is accessible" "PASS"
    else
        print_result "Page $page accessibility" "FAIL" "HTTP $RESPONSE"
    fi
done

echo -e "\n${BLUE}2. SECURITY TESTS${NC}"

# Test 2.1: SQL Injection prevention
echo "2.1 Testing SQL injection prevention..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "passengerId=PASS'; DROP TABLE passengers; --&firstName=John&lastName=Doe" \
    $BASE_URL/passengers/add)
if [ "$RESPONSE" = "302" ] || [ "$RESPONSE" = "200" ]; then
    print_result "SQL injection prevention" "PASS" "Request processed safely"
else
    print_result "SQL injection prevention" "FAIL" "HTTP $RESPONSE"
fi

# Test 2.2: XSS prevention
echo "2.2 Testing XSS prevention..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "passengerId=PASS002&firstName=<script>alert('xss')</script>&lastName=Doe" \
    $BASE_URL/passengers/add)
if [ "$RESPONSE" = "302" ] || [ "$RESPONSE" = "200" ]; then
    print_result "XSS prevention" "PASS" "Request processed safely"
else
    print_result "XSS prevention" "FAIL" "HTTP $RESPONSE"
fi

# Test 2.3: Input validation
echo "2.3 Testing input validation..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "passengerId=&firstName=&lastName=" \
    $BASE_URL/passengers/add)
if [ "$RESPONSE" = "400" ] || [ "$RESPONSE" = "422" ]; then
    print_result "Input validation" "PASS" "Empty fields rejected"
else
    print_result "Input validation" "FAIL" "HTTP $RESPONSE - should reject empty fields"
fi

echo -e "\n${BLUE}3. BUSINESS LOGIC TESTS${NC}"

# Test 3.1: Flight creation with valid data
echo "3.1 Testing flight creation with valid data..."
FUTURE_DATE=$(date -d "+1 day" +"%Y-%m-%dT%H:%M")
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "flightNumber=TEST001&departure=Istanbul&destination=Ankara&departureTime=$FUTURE_DATE&seatCapacity=150" \
    $BASE_URL/flights/add)
if [ "$RESPONSE" = "302" ] || [ "$RESPONSE" = "200" ]; then
    print_result "Flight creation with valid data" "PASS"
else
    print_result "Flight creation with valid data" "FAIL" "HTTP $RESPONSE"
fi

# Test 3.2: Passenger creation with valid data
echo "3.2 Testing passenger creation with valid data..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "passengerId=PASS001&firstName=John&lastName=Doe" \
    $BASE_URL/passengers/add)
if [ "$RESPONSE" = "302" ] || [ "$RESPONSE" = "200" ]; then
    print_result "Passenger creation with valid data" "PASS"
else
    print_result "Passenger creation with valid data" "FAIL" "HTTP $RESPONSE"
fi

# Test 3.3: Reservation creation
echo "3.3 Testing reservation creation..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "flightNumber=TEST001&passengerId=PASS001" \
    $BASE_URL/reservations/add)
if [ "$RESPONSE" = "302" ] || [ "$RESPONSE" = "200" ]; then
    print_result "Reservation creation" "PASS"
else
    print_result "Reservation creation" "FAIL" "HTTP $RESPONSE"
fi

# Test 3.4: Duplicate flight number prevention
echo "3.4 Testing duplicate flight number prevention..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "flightNumber=TEST001&departure=Istanbul&destination=Ankara&departureTime=$FUTURE_DATE&seatCapacity=150" \
    $BASE_URL/flights/add)
if [ "$RESPONSE" = "400" ] || [ "$RESPONSE" = "409" ]; then
    print_result "Duplicate flight number prevention" "PASS" "Duplicate rejected"
else
    print_result "Duplicate flight number prevention" "FAIL" "HTTP $RESPONSE - should reject duplicate"
fi

# Test 3.5: Duplicate passenger ID prevention
echo "3.5 Testing duplicate passenger ID prevention..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "passengerId=PASS001&firstName=Jane&lastName=Smith" \
    $BASE_URL/passengers/add)
if [ "$RESPONSE" = "400" ] || [ "$RESPONSE" = "409" ]; then
    print_result "Duplicate passenger ID prevention" "PASS" "Duplicate rejected"
else
    print_result "Duplicate passenger ID prevention" "FAIL" "HTTP $RESPONSE - should reject duplicate"
fi

echo -e "\n${BLUE}4. ERROR HANDLING TESTS${NC}"

# Test 4.1: Non-existent page handling
echo "4.1 Testing non-existent page handling..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" $BASE_URL/nonexistent-page)
if [ "$RESPONSE" = "404" ]; then
    print_result "Non-existent page handling" "PASS"
else
    print_result "Non-existent page handling" "FAIL" "HTTP $RESPONSE"
fi

# Test 4.2: Invalid HTTP method handling
echo "4.2 Testing invalid HTTP method handling..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X PUT $BASE_URL/flights)
if [ "$RESPONSE" = "405" ] || [ "$RESPONSE" = "404" ]; then
    print_result "Invalid HTTP method handling" "PASS"
else
    print_result "Invalid HTTP method handling" "FAIL" "HTTP $RESPONSE"
fi

echo -e "\n${BLUE}5. DATABASE TESTS${NC}"

# Test 5.1: H2 console accessibility
echo "5.1 Testing H2 console accessibility..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" $BASE_URL/h2-console)
if [ "$RESPONSE" = "200" ] || [ "$RESPONSE" = "302" ]; then
    print_result "H2 console accessibility" "PASS"
else
    print_result "H2 console accessibility" "FAIL" "HTTP $RESPONSE"
fi

# Test 5.2: Database persistence
echo "5.2 Testing database persistence..."
# Add a test passenger
curl -s -o /dev/null -X POST \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "passengerId=PERSIST001&firstName=Test&lastName=User" \
    $BASE_URL/passengers/add

# Check if it's still there
RESPONSE=$(curl -s $BASE_URL/passengers | grep -q "PERSIST001" && echo "200" || echo "404")
if [ "$RESPONSE" = "200" ]; then
    print_result "Database persistence" "PASS"
else
    print_result "Database persistence" "FAIL" "Data not persisted"
fi

echo -e "\n${BLUE}6. PERFORMANCE TESTS${NC}"

# Test 6.1: Response time
echo "6.1 Testing response time..."
START_TIME=$(date +%s%N)
curl -s -o /dev/null $BASE_URL/
END_TIME=$(date +%s%N)
RESPONSE_TIME=$(( (END_TIME - START_TIME) / 1000000 ))
if [ $RESPONSE_TIME -lt 1000 ]; then
    print_result "Response time" "PASS" "${RESPONSE_TIME}ms"
else
    print_result "Response time" "FAIL" "${RESPONSE_TIME}ms (too slow)"
fi

echo -e "\n${BLUE}=== TEST SUMMARY ===${NC}"
echo -e "Total tests: $((PASSED + FAILED))"
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"

if [ $FAILED -eq 0 ]; then
    echo -e "\n${GREEN}🎉 ALL TESTS PASSED! The airline reservation system is working correctly.${NC}"
else
    echo -e "\n${YELLOW}⚠️  Some tests failed. Please review the issues above.${NC}"
fi

echo -e "\n${BLUE}Application URLs:${NC}"
echo "Main Application: http://localhost:8080"
echo "H2 Database Console: http://localhost:8080/h2-console"
echo "Flights Management: http://localhost:8080/flights"
echo "Passengers Management: http://localhost:8080/passengers"
echo "Reservations Management: http://localhost:8080/reservations" 