---
layout: post
title: Bachelor Project - Sensor Network for Smart Agriculture
date: 2024-05-25 00:00:00 +0100
category: project
tags: [university, stm32, iot, notable-project]
---

# Live Demo

<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/luxon@^2"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-adapter-luxon@^1"></script>

<div>
    <div style="position: relative; height:35vh">
        <canvas id="myChart" style="height:35vh"></canvas>
    </div>
    <div style="position: relative; height: 500px; float: right; margin: 5%;">
        <img src="{% image_url bcs-thesis/preview.svg %}" alt="Soil moisture sensor" style="height: 500px;">
        <label id="zone1" style="position: absolute; top: 130px; left: 20px; color: white;">N/A</label>
        <label id="zone2" style="position: absolute; top: 220px; left: 20px; color: white;">N/A</label>
        <label id="zone3" style="position: absolute; top: 305px; left: 20px; color: white;">N/A</label>
        <label id="zone4" style="position: absolute; top: 390px; left: 20px; color: white;">N/A</label>
    </div>
</div>

<script type="text/javascript">
    const myChart = new Chart("myChart", {
        type: "line",
        data: {
            labels: [],
            datasets: [{
                data: [],
                borderColor: "#007e59ff",
                fill: false
            },{
                data: [],
                borderColor: "#b74200ff",
                fill: false
            },{
                data: [],
                borderColor: "#575292ff",
                fill: false
            },{
                data: [],
                borderColor: "#c40e6bff",
                fill: false
            }]
        },
        options: {
            maintainAspectRatio: false,
            legend: {display: false},
            scales: {
                yAxes: [{
                    ticks: {
                        beginAtZero: true,
                        suggestedMax: 100
                    },
                    scaleLabel: {
                        display: true,
                        labelString: "Moisture saturation [%]",
                    }
                }],
                xAxes: [{
                    type: 'time',
                    time: {
                        unit: 'second',
                        displayFormats: {
                            second: 'HH:mm:ss'
                        }
                    },
                    ticks: {
                        maxTicksLimit: 3,
                        maxRotation: 0,
                    },
                    scaleLabel: {
                        display: true,
                        labelString: "Time",
                    },
                }],
            }
        }
    });

    const url = "ws://new-horizons.lumias.cz:8765";
    var ws = null;
    function connect() {
        console.log('Connecting to', url);
        ws = new WebSocket(url);
        ws.onopen = () => {
            console.log('Connected to server');
        };
        ws.onclose = () => {
            console.log('Disconnected from server');
            ws = null;
            setTimeout(function() {
                connect();
            }, 5000);
        };
        ws.onerror = (event) => {
            console.error('Websocket error:', event);
            ws.close();
        };
        ws.onmessage = (event) => {
            const msg = JSON.parse(event.data);
            document.getElementById('zone1').innerText = msg.zones[0] + " %";
            document.getElementById('zone2').innerText = msg.zones[1] + " %";
            document.getElementById('zone3').innerText = msg.zones[2] + " %";
            document.getElementById('zone4').innerText = msg.zones[3] + " %";
            
            myChart.data.labels.push(new Date().toISOString());
            myChart.data.labels = myChart.data.labels.slice(-30);
            myChart.data.datasets.forEach((dataset, index) => {
                dataset.data.push(msg.zones[index]);
                dataset.data = dataset.data.slice(-30);
            });
            myChart.update();
        };
    }
    connect();
</script>

These are the live readings from the soil moisture sensor. The chart shows the relative moisture saturation, as measured by the sensor on the right. Colors correspond to the depth. The sensor communicates with the LoRa Nucleo board connected to a Raspberry Pi, which then forwards the data to this website.

# Introduction

Picking the topic was mainly motivated by wanting to upgrade and evolve our [LoRa-based home automation system]({% post_url /projects/2021-06-29-lorastm-home-automation-system %}). That in itself constitutes the LoRa part, but the "Smart Agriculture" part is the result of finding a supervisor, who himself suggested the topic of soil moisture sensing, which was an amazing coincidence given my long-standing [Wireless soil moisture sensor project]({% post_url /projects/2020-04-20-wireless-soil-moisture-sensors %}).

Naturally, with great excitement, I immediately set out to work on the practical part of the thesis. This project, just like the [Prosthesis motor control]({% post_url /projects/2023-04-30-prosthesis-motor-control %}) and [STM32 robot competition]({% post_url /projects/2022-05-17-stm32-car %}), allowed me to do my uni-related duties fueled by the passion I have for these personal endeavors.

# Timeline

After locking-in the topic with the supervisor, I started on **October 2023** by getting myself up-to-date with the viability of using [Rust](https://www.rust-lang.org/) for this project, since that was also on my wishlist for quite a while. We agreed on using an STM32 as the main MCU, so I was mostly interested in the [matureness of the various frameworks](https://arewertosyet.com/), such as [Embassy](https://github.com/embassy-rs/embassy) and [RTIC](https://github.com/rtic-rs/rtic).

This move to Rust was, for me, a risky one. Most of my experience stems from using the classical C tooling and "frameworks" for embedded, so I wanted to limit the amount of surprises that could arise going down this path. Thesis has a hard deadline at the end of May and I did not want to be caught-up in a situation, where some crucial feature is missing and my only option is to implement it myself, which could be a huge setback considering my current experience with Rust.

After playing around with the [Embassy examples](https://github.com/embassy-rs/embassy/tree/main/examples/stm32wl), which are great by the way, written for the [Nucleo-WL55JC](https://www.st.com/en/evaluation-tools/nucleo-wl55jc.html) board, I concluded that it is possible to continue. Though risky, the opportunity to learn something new and possibly help the community develop it outweighed most of the downsides.

At the **end of October**, I was sending my designs of the v0.1 LoRa module, based on the STM32WLE55 SoC, to PCBWay for manufacturing and assembly. All details about the various design choices can be found [in the thesis]({% document_url bcs-thesis.pdf %}) in Chapter 3 and the design itself is hosted on [GitHub](https://github.com/manakjiri/lora-module-hw). I prioritized the hardware design, because I knew the lead-times were long and could possibly stretch longer unexpectedly.

While I was waiting for the prototypes to arrive, I worked on the firmware itself. Having tested the basic backbone stuff, such as radio settings, on the Nucleo dev board, I setup the [firmware repo](https://github.com/manakjiri/lora-module-fw) and split the code into "runtime" and "applications". The split was done in an anticipation of a lot of similarity between the "node" and the "gateway" code and is talked about [in the thesis]({% document_url bcs-thesis.pdf %}) in more detail.

![]({% image_url bcs-thesis/module-v0.1.drawio.svg %})

Finished prototypes arrived at the **end of November**. I immediately hit a snag, where the [lora-rs](https://github.com/lora-rs/lora-rs) library (previously part of embassy) only supported TCXO as main system clock. Due to the way STM32WLE handles the clock, this caused an incompatibility with my hardware and I had to resort to swapping the on-module crystal oscillator with a TCXO to get the module up and running. However, the lora-rs project is in active development and this functionality was later added by a member of the community.

Implementation of the OTA update protocol was done during **December and early January**. In January a mid-project presentation was to take place, so I figured it would be interesting to demonstrate the OTA update functionality by transferring a screen buffer instead of the actual binary, so that the self-correcting feature of the protocol [could be seen in action]({% video_url lora_ota_demo.mp4 %}). In the video it is apparent, that the stream of the frame buffer chunks goes out for a while, then one comes out of order and then the missing two pieces are filled in. In practice, this means that you can have a very poor connection, but all that will do is slow down the update process and not cause any corruption of data.

I did not have time to work on the thesis during the end of the winter semester due to all the exams. The soil moisture sensor concept and design work was done during **March**, it was sent off to PCBWay at the end of the month.

![]({% image_url bcs-thesis/soil-sensor-F_Cu.svg %})

While I waited for the hardware to arrive, I started to work on the thesis itself. I started with one of the university LaTeX templates, which I ended up needing to modify to comply with the university guidelines. I could not help myself but to also setup a simple CI/CD pipeline on [GitHub](https://github.com/manakjiri/bcs-thesis), that built the thesis and uploaded it to this site. I knew I would need to share it quite often with other people and figured, that it would be great if I did not need to worry about keeping it up to date.

This also proved useful for fulfilling one particular curiosity:
![]({% image_url bcs-thesis/thesis_stats.svg %})
This was generated by a script, which walked the git commit history, one commit at a time, and since the thesis build process was set in stone by the pipeline, the script simply built every commit and then analyzed it using the pypdf library. But let's not get ahead of ourselves.

The finished sensors came at the **end of April**, so I set out to bring-up these boards as well, as can be seen on the "productivity graph" - I actually couldn't take a break. Sensors turned out great. They ended up working much better than expected. Originally, I only really needed to detect a change in the moisture level, since this is just a proof-of-concept solution. Surprisingly, they can confidently measure relative soil moisture saturation, once properly calibrated.

![]({% image_url bcs-thesis/sensor.png %})
![]({% image_url bcs-thesis/moisture-cal.svg %})

The RaspberryPi Pico at the bottom served as a data-logger, measuring the voltage of the sensor's battery. This was the only real let-down of the project, since the battery life was pretty underwhelming. The sensor was not able to accumulate enough charge to last through the night, as can be seen in the soil moisture chart above.

<!-- # Final remarks -->

