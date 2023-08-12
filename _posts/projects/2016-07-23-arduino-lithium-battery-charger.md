---
layout: post
title:  Arduino-based multicell Li-Po or Lead-acid battery 
date:   2016-07-23 00:00:00 +0200
category: project
tags: [arduino, notable-project]
---

This is a 240 W battery charger with lithium battery charging and cell balancing support. It can also discharge batteries or bring them to storage charge level (in the case of Li-Po batteries).

![]({% image_url lipo-charger/charger.jpg %})

I'm not even sure why I made it. Of course it is much easier (and safer most likely) to buy a proper battery charger (which I later bought anyway. Not because this one didn't work, I just needed more chargers). I certainly learned a lot about floating differential measurement, when measuring the individual cell voltages, and design of switching DC-DC converters in the process, so it was worth it.

[Dokumentace Li-Po nabijecka]( {% document_url dokumentace_li-po_nabijecka_2017.pdf %})

{% include image-gallery.html folder="lipo-charger" %}
