---
layout: post
title:  Arduino-based MPPT battery solar charge controller v2.0
category: project
tags: [arduino, solar, notable-project]
---

MPPT stands for Maximum Power Point Tracking. Solar panels have a specific Current/Voltage [characteristic](https://www.ti.com/lit/an/slyt478/slyt478.pdf). I'll give you a real-world example using actual numbers instead of pure theory. We'll connect our imaginary solar panel, which can put out 22 V at no load and 1 A when shorted, directly to our imaginary 12 V battery. The battery is going to start charging at about 1 A, which means that we're getting 12 W of power from our solar panel. Not bad right? But we can do better.

See, up to a certain point the solar panel sort of acts like a current limited power supply, so the only way to increase the power output is to increase the voltage. An efficient DC-DC buck converter can do the job, we just need to find the MPP tipping point. This is exactly what the MPPT algorithm does, it keeps nudging the load up (you can think of it as variable resistive load) while measuring the power output, if it notices that the power is dropping, it will ease off.

By doing this, it should ideally find that our imaginary solar panel has its MPP at about 18 V. 1A \* 18V gives us 18W of power, a 30% improvement. Of course, you have to factor in the efficiency of the DC-DC converter but those are pretty efficient.

I picked those numbers deliberately because those are the specs of my 20 W polycrystalline panel which lays on the roof suspended by a couple of wires from the rooftop window (It's been like that for a couple of years now and survived quite a few storms and high winds... Still, not a preferred mounting method, I guess). In practice, the simple MPPT algorithm didn't really work so ideally. If I look back, I think these were the main reasons:

* The relatively low difference between the battery charge voltage and the solar panel's MPP voltage (13.5 V and 18 V)
* I'd imagine that my eyeballed component values used in the DC-DC converter have left a lot to be desired efficiency-wise
* Low resolution of the AtMega328's ADCs

I later came up with a "scanning" MPPT algorithm (I have no idea whether this is used in the industry, I think there are better ways). Every couple of minutes or so it went through the entire duty cycle range of the DC-DC converter and took note of the duty cycle value which yielded the highest power output, then it sat on that value until the next scan. This worked quite well, in fact, it still sits on my bench and charges batteries to this day*. The SLA batteries themselves haven't aged very well, they hold a fraction of the rated capacity now.

I managed to snag a bargain deal on a [240 W panel]({% asset 2023/mppt-v2/mppt_240w_panel.jpg %}) but I haven't managed to mount it on the roof yet (I guess my old mounting technique wouldn't work so well this time). This MPPT isn't designed to handle this much power, so there is some demand for v3.0.

[Some more documentation written in czech]({% asset 2023/mppt-v2/dokumentace_mppt_2016.pdf %}).

![MPPT v2]({% asset 2023/mppt-v2/mppt_display.jpg %})
![MPPT v2]({% asset 2023/mppt-v2/mppt_inside.jpg %})
![MPPT v2]({% asset 2023/mppt-v2/mppt_pcb.jpg %})

*I finally retired it in 2024 after the batteries reached the end of their life.