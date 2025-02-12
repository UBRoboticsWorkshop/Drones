# Code Glossary

## General

### `void neopixelWrite(uint8_t pin, uint8_t red_val, uint8_t green_val, uint8_t blue_val)`
Sends a data packet to an addressable LED. This accepts a pin number and three values from `0-255` to set the brightness of each color. This uses RMT, which utilizes long pulses and short pulses to represent `1` and `0`, respectively.

### `unsigned long micros()`
Returns the number of microseconds the sketch has been running.

### `uint8_t transfer(uint8_t data);`
Transmits a byte of data on MOSI and listens for a byte of data on MISO.

### `void digitalWrite(uint8_t pin, uint8_t val)`
Sets pin number `pin` to `val`.  
- `False`, `LOW`, or `0` sets it low.  
- Anything else sets it high.

---

## Bitwise Functions

### `int variableToShift << int placesToShift`
**Left shift** - Moves each bit in `variableToShift` left, `placesToShift` times.  
Equivalent to multiplying `variableToShift` by `2^placesToShift` with integers.

### `int variableA | int variableB`
**Bitwise OR** - Combines two variables by performing an OR function on each bit.

---

## VL53 API

### `getRange()`
Reads and returns the measured distance from the VL53 sensor in millimeters.

### `startRanging()`
Starts the ranging (distance measurement) process on the VL53 sensor.

### `stopRanging()`
Stops the ranging process on the VL53 sensor.

### `clearInterrupt()`
Clears any active interrupt on the VL53 sensor, resetting its interrupt GPIO pin.

### `getIntPolarity()`
Reads and returns the polarity of the interrupt pin (`0` or `1`).

### `dataReady()`
Checks if new ranging data is available and returns `true` if data is ready.

### `getRangeStatus()`
Reads and returns the status of the last distance measurement (e.g., valid, error, etc.).

### `initLiDAR()`
Initializes the VL53 sensor by loading default settings, clearing interrupts, and starting ranging.

### `bootState()`
Checks and returns whether the VL53 sensor has completed booting (`1` if ready, `0` otherwise).
