---
layout: post
title:  Facebook datamining
category: project
tags: [ml]
---


How a random weekend project turned into my graduation work... At the beginning it was just that. I wanted to learn how to work with databases. I figured that instead of using some random JSON example I could download my data from Facebook and use that instead.

![]({% image_url facebook_graph.jpg %})


I'm already satisfied with the basic functionality (the original objective) - the Python script counts the amount of messages in a specified time frame, say a week, resulting in a messages per week value which it then puts into a .csv chart. I can then take this file, open it in Excel and make a nice graph out of it.


I recently also implemented the most used words counter. I'm planning to add a couple more features and make the script more interactive and intuitive to use. I haven't yet figured out whether this data could be used for at least rudimentary psychological research.


*Update:* I refined the project and made it [public](https://github.com/georges-circuits/fb_conversations). ~~It's certainly not finished yet, but~~ it works, for my use case at least. If you clone it, it should run just fine, it uses just one non-standard package (tqdm to show progress bars) but you can edit that out of the code, it's not mandatory (just don't freak out when it hangs for a couple of minutes, sometimes it does take quite a while to chew through all those messages).


