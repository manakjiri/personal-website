---
layout: post
title:  Jetson Nano powered RC car
category: project
tags: [ml, stm32, linux, rc]
---


This has been a dream of mine for quite some time - build (or at least attempt to build) a sort of playful standalone autonomous wheel-based robot with a grabber arm perhaps. Something resembling Tony Stark's Dum-E, although I've had this idea in mind long before I got familiar with Marvel's Universe. 

Anyway, I needed some fun projects for the holidays so I decided to finally pursue this one. The objective isn't really to build a humanoid assistant to replace real people and friends or anything like that, it's mainly the idea of having a computer algorithm, which, by its very nature, is very deterministic and predictable (well, we developers might sometimes disagree with this wisdom until we reassure ourselves that the thing is doing exactly what it's told and that the problem resides somewhere between the chair and the keyboard, but I digress) and turn it into something that has a mind of its own (it will still obey every command I give it of course, it will be a computer after all, it will just mask it very well, or at least that's the idea).

![]({% image_url pycar/pycar_frontangle.jpg %})

The control is split into two parts - a microcontroller for the low-layer and real-time processing and a computer for the image processing and high-level control:
 * The computer is a [Jetson Nano](https://developer.nvidia.com/embedded/jetson-nano-developer-kit) from nVidia
    + It runs Nvidia's Jetpack distro which includes [Jetson inference](https://github.com/dusty-nv/jetson-inference) Python package that enables loading and running neural nets
    + It's got the [Raspberry pi camera V2](https://www.raspberrypi.org/products/camera-module-v2/) connected to it
    + It sends commands and retrieves data from sensors
    + And there are my Python scripts running the whole show including a GUI dashboard
* The microcontroller is an [STM32F407](https://www.st.com/en/microcontrollers-microprocessors/stm32f407-417.html) which communicates with the Jetson over USB
    + Generates control signals for the stepper motor which drives the whole car and the servo which does the steering
    + It receives data over UART from my I2C expansion boards (those are actually STM32F1 boards that emulate a number of I2C buses on their GPIO pins and communicate with [VL53L0X](https://www.adafruit.com/product/3317) ToF distance sensors)
    + It retrieves accelerometer, gyro, and compass data from an IMU
    + It acts as a watchdog for the Jetson and goes into a failsafe if it doesn't hear from the Jetson for too long
    + Finally it does some housekeeping stuff like checking the battery voltage, cleaning up the data from the sensors, and calibrating them

{% include image-gallery.html folder="pycar" %}
