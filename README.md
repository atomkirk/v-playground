# Simple V LiveView Clone

This is simple clone of [Phoenix LiveView](https://github.com/phoenixframework/phoenix_live_view) in [V](https://vlang.io/). Also takes inspiration from [The Elm Architecture](https://guide.elm-lang.org/architecture/)

![example](https://cln.sh/8LAqOJqo5RbTVc4RNux5+)

If you'd like to clone and build it, simply:

```
# install V
git clone https://github.com/vlang/v
(cd v && make && v symlink)

# clone & run the example
git clone https://github.com/atomkirk/v-playground.git
cd v-playground
v run .
```

There's only 2 files:

- index.html which is the main page and contains the javascript to work inline
- live.v that contains the v server code
