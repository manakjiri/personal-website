---
layout: post
title:  Portable Bluetooth speaker
category: project
tags: [arduino, notable-project]
---

![]({% image_url bluetooth-speaker/bt_speaker.jpg %})

* Amplifiers: **2x10W** AB class
* Battery: **37 Wh** 3-cell Li-Ion
* Built-in analog equalizer
* Bluetooth or 3.5 mm jack
* Charging current: 1.5 A max (manually configurable or automatic MPPT)
* Charging power: 15 W max
* USB output (up to 2 A)
* Requisite over-temperature and overload protections including error reporting


Almost everything is custom designed (except the Bluetooth module and the two power converters visible [here]({% image_url bluetooth-speaker/speaker_inside_2.jpg %}), but those were modified to be controllable by the microcontroller). The enclosure is made out of [layers]({% image_url bluetooth-speaker/speaker_layer_model.jpg %}) of laser cut plywood, the back is 3 mm aluminum for structural and cooling purposes. It's not the most efficient speaker in the world because it uses AB amplifiers. Pretty much all portable speakers use class D, which are way more efficient but higher distortion.


Participated in the electronics [competition](https://www.roznovskastredni.cz/aktuality/mistrovstvi-cr-v-radiotelektronice-deti-a-mladeze-2019) in Rožnov pod Radhoštěm. [Dokumentace reproduktor 2019]({% document_url dokumentace_reproduktor_2019.pdf %}).


{% include image-gallery.html folder="bluetooth-speaker" %}
