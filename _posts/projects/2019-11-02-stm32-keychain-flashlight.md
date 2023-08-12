---
layout: post
title:  Coincell keychain flashlight
date:   2019-11-02 00:00:00 +0200
category: project
tags: [stm32]
---

Christmas gift for my friends. Also a pilot project for the moisture sensors. It periodically checks for movement and adjusts its "activity" value accordingly. The activity value determines how often (or if at all) it randomly flashes. It's supposed to feel like its alive, in a sense. Written out like this it doesn't sound like much but I think the effect is kinda neat and serves its purpose.

![]({% image_url keychain-flashlight/flashlight_leds_lit.jpg %})

It also has some more or less useful features like static flashlight and various flashing modes and a "game" which you cannot win.

**User Manual**
* Flick it and simultaneously press the button to get into the menu or keep holding the button and the light will come on.
* Menu:
	+ Red: Exit menu
	+ Orange: Flashing mode 1 (exit by pressing the button, no timeout)
	+ Yellow: Flashing mode 2 (exit by pressing the button, no timeout)
	+ Green: The game (Have fun! If you figure out how to play it, congratulate yourself)
	+ Blue: Suspend the random flashing for 24 hours
	+ Purple: Show battery level

Source code and a little bit of documentation available on my [GitHub](https://github.com/georges-circuits/coincell_flashlight)


{% include image-gallery.html folder="keychain-flashlight" %}
