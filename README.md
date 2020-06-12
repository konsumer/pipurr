# zerostomp

This is a builder for a nice piZero-based effect-pedal.

## development

This uses [pi-gen](https://github.com/RPi-Distro/pi-gen). I configured it with ideas from [here](http://kmdouglass.github.io/posts/create-a-custom-raspbian-image-with-pi-gen-part-1/).

I setup a `config` file, so you can set it up with `./build-docker.sh`

Still need to incorporate ideas from [here](https://github.com/konsumer/zerostomp-ideas)

## hardware

The pedal is meant to operate plugged-in (no battery power) and uses a pi-zero to do all the work. It uses 4 rotary-encoders for input, a single 3PDT footswitch for true-bypass, and 2 buttons to select the current patch. It has a Nokia 5110 to display status and show the values of different parameters. The USB power plug is hooked up to the piZero data-port, so it can get power & also run in USB host mode if it's connected to a computer.

### parts

* [nice enclosures & buttons](https://www.mammothelectronics.com/)
* [audio hat](https://www.amazon.com/gp/product/B075V1VNDD/ref=ppx_yo_dt_b_asin_title_o02_s00?ie=UTF8&psc=1) look into [pi-codeczero](http://iqaudio.co.uk/hats/101-pi-codeczero.html)
* [panel-mount USB for power & input](https://www.adafruit.com/product/4217)
* 4x [rotary encoders with pullup resistors](https://www.amazon.com/gp/product/B06XQTHDRR/ref=ppx_yo_dt_b_asin_title_o01_s00?ie=UTF8&psc=1) this [i2c rotary-controller](https://www.tindie.com/products/saimon/i2cencoder-v2-connect-multiple-encoder-on-i2c-bus/) also looks cool to simplify hookup, but it adds a bit of cost to the project
* [pizero](https://www.adafruit.com/product/2885)
* [stacking header](https://www.amazon.com/gp/product/B071XCHZNB/ref=ppx_yo_dt_b_asin_title_o00_s00?ie=UTF8&psc=1)
* 2x [input buttons](https://www.amazon.com/gp/product/B076V2QYSJ/ref=ppx_yo_dt_b_asin_title_o01_s00?ie=UTF8&psc=1)
* 2x [audio jacks](https://www.amazon.com/gp/product/B00CO6Q1II/ref=ppx_yo_dt_b_asin_title_o01_s00?ie=UTF8&psc=1)
* [3PDT bypass footswitch](https://www.mammothelectronics.com/collections/footswitches/products/3pdt-ls-pro-footswitch)
* [Nokia 5110 LCD](https://www.adafruit.com/product/338) this [OLED display](https://www.amazon.com/MakerFocus-Display-SSD1306-3-3V-5V-Arduino/dp/B0761LV1SD/ref=pd_rhf_dp_s_all_spx_wp_0_3/134-4039483-3143422?_encoding=UTF8&pd_rd_i=B0761LV1SD&pd_rd_r=17ceed7d-2098-49cf-ae9b-a86382757db0&pd_rd_w=7hfrp&pd_rd_wg=BXBz1&pf_rd_p=ffd394b3-6bb0-43ec-8bd8-b3dd44ab44d6&pf_rd_r=0RZCJGGR9AV8SPX9KTTX&refRID=0RZCJGGR9AV8SPX9KTTX&th=1) looks nice & would be simpler to hookup, but will require different drivers.
* [breakout board](https://www.buyapi.ca/product/raspberry-pi-3-cobbler-breakout-kit/) - to connect peripherals to a nice cable connector
* [standoffs](https://www.buyapi.ca/product/brass-m2-5-standoffs-for-pi-hats-pack-of-4/)

### pins

These are the pins I hookup:

```
         +-----+-----+---------+-Pi ZeroW-+---------+-----+-----+
         | BCM | wPi |   Name  | Physical | Name    | wPi | BCM |
         +-----+-----+---------+----++----+---------+-----+-----+
         |     |     |    3.3v |  1 || 2  | 5v      |     |     |
         |   2 |   8 |   SDA.1 |  3 || 4  | 5v      |     |     |
         |   3 |   9 |   SCL.1 |  5 || 6  | 0v      |     |     |
K1-DT    |   4 |   7 | GPIO. 7 |  7 || 8  | TxD     | 15  | 14  |
         |     |     |      0v |  9 || 10 | RxD     | 16  | 15  |
K1-CLK   |  17 |   0 | GPIO. 0 | 11 || 12 | GPIO. 1 | 1   | 18  | L-CS
K1-BTN   |  27 |   2 | GPIO. 2 | 13 || 14 | 0v      |     |     |
K2-DT    |  22 |   3 | GPIO. 3 | 15 || 16 | GPIO. 4 | 4   | 23  | K2-BTN
         |     |     |    3.3v | 17 || 18 | GPIO. 5 | 5   | 24  | K3-DT
L-DIN    |  10 |  12 |    MOSI | 19 || 20 | 0v      |     |     |
         |   9 |  13 |    MISO | 21 || 22 | GPIO. 6 | 6   | 25  | K3-CLK
L-CLK    |  11 |  14 |    SCLK | 23 || 24 | CE0     | 10  | 8   | 
         |     |     |      0v | 25 || 26 | CE1     | 11  | 7   |
         |   0 |  30 |   SDA.0 | 27 || 28 | SCL.0   | 31  | 1   |
B1       |   5 |  21 | GPIO.21 | 29 || 30 | 0v      |     |     |
B2       |   6 |  22 | GPIO.22 | 31 || 32 | GPIO.26 | 26  | 12  | K3-BTN
L-D/C    |  13 |  23 | GPIO.23 | 33 || 34 | 0v      |     |     |
L-RST    |  19 |  24 | GPIO.24 | 35 || 36 | GPIO.27 | 27  | 16  | K4-DT
K2-CLK   |  26 |  25 | GPIO.25 | 37 || 38 | GPIO.28 | 28  | 20  | K4-CLK
         |     |     |      0v | 39 || 40 | GPIO.29 | 29  | 21  | K4-BTN
         +-----+-----+---------+----++----+---------+-----+-----+
         | BCM | wPi |   Name  | Physical | Name    | wPi | BCM |
         +-----+-----+---------+-Pi ZeroW-+---------+-----+-----+

```

* `K*` are rotary encoders knobs
* `B*` are input buttons
* `L*` are LCD hookups

If you need more reference, [this](https://cdn.sparkfun.com/assets/learn_tutorials/6/7/6/PiZero_1.pdf) has a nice pinout diagram.
