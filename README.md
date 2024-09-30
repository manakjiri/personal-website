# Personal Website source

[![Build and deploy to manakjiri.cz](https://github.com/manakjiri/personal-website/actions/workflows/deploy.yml/badge.svg)](https://github.com/manakjiri/personal-website/actions/workflows/deploy.yml) [![Better Stack Badge](https://uptime.betterstack.com/status-badges/v2/monitor/1kz3w.svg)](https://status.manakjiri.cz) 

Based on the [Klisé Theme](https://github.com/piharpi/jekyll-klise), built by [Jekyll](https://jekyllrb.com).

Currently hosted on Cloudflare Pages with static assets in R2. The analytics are self-hosted on my VPS.

## Environment setup

``` shell
rbenv local
rbenv install
gem install bundler
bundle install
bundle exec jekyll serve --livereload
```
