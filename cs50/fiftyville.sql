-- Log of SQL executions

-- Get the description and id. Note, the id is 295 for CS50 duck theft
-- Three witnesses present at the time each mention the bakery. Interviews
-- conducted on 28th July. Time of theft if 10.15 AM.
SELECT id, description
FROM crime_scene_reports
WHERE month = 7 AND day = 28 AND year = 2025
AND street = 'Humphrey Street' AND description LIKE '%duck%';

-- Names of witnesses: Ruth, Eugene and Raymond (ids: 161, 162, 163)
-- Ruth says thief left within ten mins of theft in a car in the bakery car park.
-- Eugene says the thief looks familiar. He saw thief getting cash from ATM on Leggett Street
-- Raymond heard the thief say they're getting the earliest flight out tomorrow (29th July).
-- The thief asked the person to whom they were talking on the phone to purchase the ticket.
SELECT id, name, transcript
FROM interviews
WHERE month = 7 AND day = 28 AND year = 2025;

-- Look for cars that entered and left the car park within 10 mins. Also, the theft was early morning.
-- L68E5I0 ENTRANCE AT 8.25 EXIT AT 8.34
SELECT *
FROM bakery_security_logs
JOIN people ON bakery_security_logs.license_plate = people.license_plate
WHERE month = 7 AND day = 28 AND year = 2025 AND hour = 10 AND minute >= 15 AND minute < 27;

-- Get people who made atm transactions on 28.07.2025 on Leggett St.
SELECT *
FROM atm_transactions
JOIN bank_accounts ON atm_transactions.account_number = bank_accounts.account_number
JOIN people ON bank_accounts.person_id = people.id
WHERE atm_location = 'Leggett Street' AND month = 7 AND day = 28 AND year = 2025;

-- Get people who had phone calls less than 60 secs duration and who made a transaction on the day of the theft
-- on Leggett Street
SELECT *
FROM people
JOIN phone_calls ON people.phone_number = phone_calls.caller
WHERE phone_calls.duration < 60 AND phone_calls.day = 28 AND people.id IN (
    SELECT person_id
    FROM bank_accounts
    WHERE account_number IN (
        SELECT account_number
        FROM atm_transactions
        WHERE atm_location = 'Leggett Street' AND month = 7 AND day = 28 AND year = 2025
    )
);

-- Get callers who had a short phone call (i.e. < 60 seconds on 28th July)
-- Note their license plate may not necessarily be the same as the 'getaway' car
SELECT *
FROM phone_calls
JOIN people ON phone_calls.caller = people.phone_number
WHERE duration < 60 AND month = 7 AND day = 28 AND year = 2025;

-- Check layout of airports
SELECT *
FROM airports;

-- CHECK FLIGHTS

-- flight with id 36 is the earliest flight on 29/07/25 (going back to what witness said)
SELECT *
FROM flights
WHERE month = 7 AND day = 29 AND year = 2025 AND origin_airport_id = (
    SELECT id
    FROM airports
    WHERE full_name = 'Fiftyville Regional Airport'
);

-- Check destination airport
SELECT *
FROM airports
WHERE id = (
    SELECT destination_airport_id
    FROM flights
    WHERE destination_airport_id = 4
);

-- Get all people on the earliest flight on 29/07/2025 who had phone calls on day of theft
-- less than 60 seconds duration
SELECT *
FROM passengers
JOIN people ON passengers.passport_number = people.passport_number
WHERE flight_id = 36 and passengers.passport_number IN (
    SELECT passport_number
    FROM phone_calls
    JOIN people ON phone_calls.caller = people.phone_number
    WHERE duration < 60 AND month = 7 AND day = 28 AND year = 2025
);

-- Get all the people who are on the earliest flight. Bruce is suspicious.
SELECT *
FROM passengers
JOIN people ON passengers.passport_number = people.passport_number
JOIN bakery_security_logs ON people.license_plate = bakery_security_logs.license_plate
WHERE flight_id = 36 AND passengers.passport_number IN (
    SELECT passport_number
    FROM phone_calls
    JOIN people ON phone_calls.caller = people.phone_number
    WHERE duration < 60 AND month = 7 AND day = 28 AND year = 2025
);

-- Get people who had phone calls less than 60 secs duration and who made a transaction on the day of the theft
-- on Leggett Street and are taking the earliest flight out of Fiftyville on 29th July.
-- These people are: Kenny, Taylor, and Bruce who als made transactions (withdrawals) on Leggett St. on 28th.
-- Bruce is thief, however because he left within 10 mins of theft.
SELECT *
FROM people
JOIN phone_calls ON people.phone_number = phone_calls.caller
JOIN passengers ON people.passport_number = passengers.passport_number
WHERE phone_calls.duration < 60 AND phone_calls.day = 28 AND passengers.flight_id = 36 AND people.id IN (
    SELECT person_id
    FROM bank_accounts
    WHERE account_number IN (
        SELECT account_number
        FROM atm_transactions
        WHERE atm_location = 'Leggett Street' AND month = 7 AND day = 28 AND year = 2025
    )
);

-- Who did Bruce call on 28.7.25 for less than 60 seconds? i.e. accomplice
SELECT *
FROM phone_calls
JOIN people ON phone_calls.receiver = people.phone_number
WHERE year = 2025 AND month = 7 AND day = 28 AND duration < 60 AND caller = (
    SELECT phone_number
    FROM people
    WHERE name = 'Bruce'
);
