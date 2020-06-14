## Ideas

Here are some notes on future ideas, while I work on stuff.

* provide release that is image of SDCard for quick install
* write detailed usage instructions and videos
* implement [these](https://guitarextended.wordpress.com/audio-effects-for-guitar-with-pure-data/) and other basic effect patches
* add support for expression pedal
* put patch/gpio controller in pd directly with [rpi-gpio](http://nyu-waverlylabs.org/rpi-gpio/)? Also, use kernel rotary evdev with [hid](https://at.or.at/hans/pd/hid.html)
* replace pd with [mod-host](https://github.com/moddevices/mod-host) & ladspa for better performance? I could make custom stuff in [faust](http://faust.grame.fr/) and even a completely standalone console-app with `faust2jackconsole`. There are some nice ideas [here](http://lac.linuxaudio.org/2008/download/papers/22.pdf)
* Redesign [pdpi](https://github.com/konsumer/pdpi) to use all this stuff
* consider putting all IO (screen, rotary-encoders, buttons) in go. It's fast & fun, and would allow small pre-compiled binaries. Here are soem good libs for that: [gpio](https://github.com/warthog618/gpio), [i2c](https://github.com/d2r2/go-i2c)
* Put hardware pin-settings in config.txt for complete pin configurability. Since I am using kernel params for rotary & i2c (OLED), it wil be in several places, but at least in the same file