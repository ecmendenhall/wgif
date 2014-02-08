# WGif

WGif is a command line tool for creating animated GIFs from YouTube videos.

##TL;DR
```
Usage: wgif [YouTube URL] [output file] [options]

    -f, --frames N                   Number of frames in the final gif. (Default 20)
    -s, --start HH:MM:SS             Start creating gif from input video at this timestamp. (Default 00:00:00)
    -d, --duration seconds           Number of seconds of input video to capture. (Default 5)
    -w, --width pixels               Width of the gif in pixels. (Default 500px)

Example:

    $ wgif https://www.youtube.com/watch?v=1A78yTvIY1k bjork.gif -s 00:03:30 -d 2 -w 400
```

## Installation
WGif uses FFmpeg for video transcoding and ImageMagick to optimize GIFs.
To install dependencies with Homebrew, just run:

```sh
$ brew bundle
```

in the project directory. Then

```sh
$ gem build wgif.gemspec
```

and

```sh
$ gem install wgif-0.0.1.gem
```

to install the executable.

## Making a GIF
WGif expects two arguments: a YouTube video URL and a name for the GIF it creates. So,

```sh
$ wgif https://www.youtube.com/watch?v=1A78yTvIY1k bjork.gif
```

Is enough to create a GIF of Bjork explaining her television. Without any extra parameters, WGif starts at
the beginning of the video, and creates a 20-frame, 500px GIF of the first five seconds. Since GIFs are more
art than science, you'll probably want to tweak the size, duration, and number of frames.

Start by isolating the section of the video you'd like to GIF. Bjork starts her advice about dishonest
Icelandic poets around 3 minutes 30 seconds, and it lasts about two seconds. Pass the start timestamp with
`-s` or `--start` and the duration with `-d` or `--duration`:

```sh
$ wgif https://www.youtube.com/watch?v=1A78yTvIY1k bjork.gif --start 00:03:30 -d 2
```

A good start, but the GIF is way too big: around 5.6 megabytes. We can pass `-f` or `--frames` to specify the
total number of frames in the finished GIF. This defaults to 20, so let's drop a few to reduce the file size:

```sh
$ wgif https://www.youtube.com/watch?v=1A78yTvIY1k bjork.gif --start 00:03:30 -d 2 -f 18
```

Down to 2.2 megabytes, but still not small enough to post on my Sugarcubes fan-Tumblr. Let's scale it down a little
with the `-w` or `--width` flag:

```sh
$ wgif https://www.youtube.com/watch?v=1A78yTvIY1k bjork.gif --start 00:03:30 -d 2 -f 18 --width 350
```

And here it is:

![Bjork](http://i.imgur.com/NZXWwey.gif)
### "You shouldn't let poets lie to you."
