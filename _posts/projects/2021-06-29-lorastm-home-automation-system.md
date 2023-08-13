---
layout: post
title:  LoRaSTM wireless dev-board
date:   2021-06-29 00:00:00 +0200
category: project
tags: [stm32, linux, iot, notable-project]
---


I got into this project mainly because I finally wanted to turn my peer-to-peer protocol into reality. I've been thinking about it ever since the [Wireless soil moisture sensors project]({% project_url wireless-soil-moisture-sensors %}). Even though I didn't think of this one like that at first, this project, and it's rather quick bring-up and completion, as a pleasant side-effect also really helped to move forward the sensor project, if I ever decide to revive it in the future. 


The protocol, which I've come to call the Tiny Secure Protocol Stack, TSPS in short, does exactly what its name suggests - very small footprint, built in encryption of the payload and support for encapsulation. I wrote a summary of the features, design and implementation, but it is only available in czech.


LoRaSTM\_demo [(mp4)]({% video_url LoRaSTM_demo.mp4 %}) [(webm)]({% video_url LoRaSTM_demo.webm %}), [TSPS whitepaper]({% document_url dokumentace_tsps.pdf %})


{% include image-gallery.html folder="lorastm" %}
