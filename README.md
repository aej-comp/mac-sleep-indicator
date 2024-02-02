### Mac Studio (or Mac Mini) Sleep Indicator

![Sleep Indicator Image](/thumbnail.png)
[YouTube Video](https://youtu.be/ld1AK3wRRF4?si=h1AgnkIclTDRkks9)


## Resources

### Hardware

- Arduino Seeed XIAO RP2040
- USB-A to USB-C cable

### Software

- [Arduino Firmware](./firmware/firmware.zip)
- [Sleep Indicator App](./app/sleepindicator.dmg)
- [Case Design Files](./case/case.zip)

## Building Instructions

### Upload Arduino Firmware

1. **Download Arduino Firmware package** and unzip content.
2. **Open Terminal** and go to the folder.
3. **Connect Arduino** and identify the serial interface.

    ```plaintext
    > ls /dev/cu.*
    /dev/cu.Bluetooth-Incoming-Port /dev/cu.usbmodem83401
    ```

4. **Install pyserial** if not already installed.

    ```plaintext
    > pip3 install pyserial
    ```

5. **Upload firmware to Arduino**.

    ```plaintext
    > python3 uf2conv.py --serial "/dev/cu.usbmodem83401" --family RP2040 --deploy firmware_medium_v1.uf2
    Resetting /dev/cu.usbmodem83401
    Converting to uf2, output size: 142336, start address: 0x2000
    Scanning for RP2040 devices
    Flashing /Volumes/RPI-RP2 (RPI-RP2)
    Wrote 142336 bytes to /Volumes/RPI-RP2/NEW.UF2
    ```

    *Note: The firmwares “medium” and “high” only differ in the brightness of the LED.*

### Install Sleep Indicator App

1. **Plug in the Sleep Indicator Dongle via USB.** This ensures the dongle is detected automatically.
2. **Download “SleepIndicator.dmg”** and open the dmg file.
3. **Copy the “SleepIndicator.app”** to your Applications folder.
4. **Open the app** from the Applications folder.
5. **Authorize the app** if you receive a message stating “Developer cannot be verified”.

### Set Up Auto-Start for the App

- Open System Settings.
- Search for “Login items”.
- Click on the “+” button and add “SleepIndicator.app” from your Applications folder.

### Case Assembly

1. **Download the design files**.
2. **Print the case** as instructed.

### Testing

Test by putting your Mac to sleep. The indicator light should start pulsating and stop pulsating when your Mac is awake again.

---

Shield: [![CC BY-NC-SA 4.0][cc-by-nc-sa-shield]][cc-by-nc-sa]

This work is licensed under a
[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License][cc-by-nc-sa].

[![CC BY-NC-SA 4.0][cc-by-nc-sa-image]][cc-by-nc-sa]

[cc-by-nc-sa]: http://creativecommons.org/licenses/by-nc-sa/4.0/
[cc-by-nc-sa-image]: https://licensebuttons.net/l/by-nc-sa/4.0/88x31.png
[cc-by-nc-sa-shield]: https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg

