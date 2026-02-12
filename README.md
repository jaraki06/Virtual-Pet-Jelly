# Virtual Pet Jelly!
*Made for [Hack the Coast 2026](https://devpost.com/software/virtual-pet-jelly) - a 24-hour hackathon*

Inspired by the classic childhood virtual pet games, we wanted to recreate the feeling of caring of a digital companion that reacts to how you interact with it in the real world. 

## Inspiration
In an increasingly digital world, we wanted to bridge the gap between hardware engineering and emotional support. Inspired by the comforting nostalgia of childhood virtual pet games, we developed a companion that encourages tactile, real-world interaction rather than passive screen time. Our goal was to explore how low-level hardware can create 

## What it does
Take care of a virtual pet and practice emotional grounding through physical and button-based interactions. The pet’s internal state acts as a mirror for the user’s attentiveness, encouraging a routine of care through physical interaction and empathy-based logic.
- **Pet** your virtual companion  
- **Play** with it  
- **Shake** it using real-world motion  
- **Feed** it to maintain its hunger level  

Each interaction affects the pet’s internal state and behaviour.

## How we built it
We built the core logic and state transitions on a **DE10-Lite FPGA**, using SystemVerilog finite state machines (FSMs) to manage both the game logic (your pet's internal state) and shake detection. The FPGA processes sensor data from the onboard **ADXL345 accelerometer** to detect shaking in real time, and uses the buttons for feed and play interactions.

The FPGA outputs the pet’s current state to an Arduino, which handles displaying the pet’s status through the Serial Monitor. Communication between the DE10-Lite and Arduino is done using Arduino-compatible I/O pins.

## Challenges we ran into
Our original plan was to integrate RTOS with HDL logic on the DE10-Lite to combine HDL and C to print directly to the terminal. However, we could not find clear documentation on how to integrate these components. In the end, we decided to pivot by using an Arduino for output and display, which allowed us to move forward with our project.

## Accomplishments that we're proud of
We accomplished a lot of new and challenging things in a short amount of time:
- Designed and implemented **two fully functional finite state machines**
  - One FSM handles the game logic and pet behaviour
  - One FSM processes accelerometer data to accurately detect a “shake,” with adjustable sensitivity
- Successfully interfaced a **DE10-Lite FPGA with an Arduino**
- Communicated real-time FPGA outputs to external hardware using Arduino I/O pins
- Implemented reliable shake detection using real sensor data instead of simulated input
- Wiring hardware components cleanly and securely

## What we learned
- How to design and debug complex FSMs in SystemVerilog  
- How to process and interpret accelerometer data on an FPGA  
- How to integrate FPGA hardware with external microcontrollers  
- How to adapt project scope and architecture when initial plans don’t work out  

## What's next?
Improve the visual output and user experience  
- Adding an LCD display to show the pet’s state directly on the device and everything into a single standalone unit instead of relying on the Serial Monitor  
- Adding more interactions and pet behaviours using different types of sensors for greater interactivity (e.g. light and temperature)
