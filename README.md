# Personal Website source

[![Build and deploy to manakjiri.cz](https://github.com/manakjiri/personal-website/actions/workflows/deploy.yml/badge.svg)](https://github.com/manakjiri/personal-website/actions/workflows/deploy.yml)
[![Jekyll site CI](https://github.com/manakjiri/personal-website/actions/workflows/validate.yml/badge.svg)](https://github.com/manakjiri/personal-website/actions/workflows/validate.yml)

Based on the [Klisé Theme](https://github.com/piharpi/jekyll-klise), built by [Jekyll](https://jekyllrb.com).

## Environment setup

``` shell
rbenv local
rbenv install
gem install bundler
bundle install
# sshfs jirka@truenas.lan:website_assets/content assets/content
bundle exec jekyll serve --livereload
```
