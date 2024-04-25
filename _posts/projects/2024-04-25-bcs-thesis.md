---
layout: post
title: Bachelor Project - Sensor network for Smart Agriculture
date: 2024-04-25 00:00:00 +0100
category: project
tags: [university, stm32]
---

Picking the topic was mainly motivated by wanting to upgrade and evolve our [LoRa-based home automation system]({% post_url /projects/2021-06-29-lorastm-home-automation-system %}). That in itself constitutes the LoRa part, but the "Smart Agriculture" part is the result of finding a supervisor, who himself suggested the topic of soil moisture sensing, which was an amazing coincidence given my long-standing [Wireless soil moisture sensor project]({% post_url /projects/2020-04-20-wireless-soil-moisture-sensors %}).

Naturally, with great excitement, I immediately set out to work on the practical part of the thesis. This project, just like the others [] [], allowed me to do my uni-related duties fueled by the passion I have for these personal endeavors. 

After locking-in the topic with the supervisor, I started on **October 2023** by getting myself up-to-date with the viability of using Rust for this project, since that was also on my wishlist for quite a while. We agreed on using an STM32 as the main MCU, so I was mostly interested in the matureness of the various frameworks, such as [Embassy](https://github.com/embassy-rs/embassy) and [RTIC](https://github.com/rtic-rs/rtic). 

This move to Rust was, for me, a risky one. Most of my experience stems from using the classical C tooling and "frameworks" for embedded, so I wanted to limit the amount of surprises that could arise going down this path. Thesis has a hard deadline at the end of May and I did not want to be caught-up in a situation, where some crucial feature is missing and my only option is to implement it myself, which could be a huge setback considering my experience with Rust.

After playing around with the [Embassy examples](https://github.com/embassy-rs/embassy/tree/main/examples/stm32wl), which are great by the way, written for the [Nucleo-WL55JC](https://www.st.com/en/evaluation-tools/nucleo-wl55jc.html) board, I concluded that it is possible to continue. Though risky, the opportunity to learn something new and possibly help the community develop it outweighed most of the downsides.

At the **end of October**, I was sending my designs of the v0.1 LoRa module, based on the STM32WLE55 SoC, to PCBWay for manufacturing and assembly. All details about the various design choices can be found in the thesis in Chapter 3 and the design itself is hosted on [GitHub](https://github.com/manakjiri/soil-sensor-hw). I prioritized the hardware design, because I knew the lead-times were long and could possibly stretch longer unexpectedly.

While I was waiting for the prototypes to arrive, I worked on the firmware itself. Having tested the basic backbone stuff, such as radio settings, on the Nucleo dev board, I setup the [firmware repo](https://github.com/manakjiri/soil-sensor-fw) and split the code into "runtime" and "applications". The split was done in anticipation of a lot of similarity between the "node" and the "gateway" code and is talked about in the thesis in more detail.

Finished prototypes arrived at the **end of November**. I immediately hit a snag, where the [lora-rs](https://github.com/lora-rs/lora-rs) library (previously part of embassy) only supported TCXO as main system clock. Due to the way STM32WLE handles the clock, this caused an incompatibility with my hardware and I had to resort to swapping the on-module crystal oscillator with a TCXO to get the module up and running.