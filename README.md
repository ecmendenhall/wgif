# WGif
[![Build Status](https://travis-ci.org/ecmendenhall/wgif.svg?branch=master)](https://travis-ci.org/ecmendenhall/wgif)
[![Code Climate](https://codeclimate.com/github/ecmendenhall/wgif.png)](https://codeclimate.com/github/ecmendenhall/wgif)

WGif is a command line tool for creating animated GIFs from YouTube videos.

##TL;DR
```
Usage: wgif [YouTube URL] [output file] [options]

    -f, --frames N          Number of frames in the final gif. (Default 20)
    -s, --start HH:MM:SS    Start creating gif from input video at this timestamp. (Default 00:00:00)
    -d, --duration seconds  Number of seconds of input video to capture. (Default 1)
    -w, --width pixels      Width of the gif in pixels. (Default 480px)
    -u, --upload            Upload finished gif to Imgur
    -p, --preview           Preview finished gif with Quick Look
    -h, --help              Print help information.

Example:

    $ wgif https://www.youtube.com/watch?v=1A78yTvIY1k bjork.gif -s 00:03:30 -d 2 -w 400 --upload
```

## Installation (Mac OS X)
To install from Rubygems:

```sh
$ gem install wgif
```

To install from source, run

```sh
$ gem build wgif.gemspec
```

and

```sh
$ gem install wgif-0.3.0.gem
```

to install the executable.

WGif uses FFmpeg for video transcoding and ImageMagick to optimize GIFs.
To install dependencies with [Homebrew](http://brew.sh/), just run

```sh
$ wgif install
```

## Making a GIF
WGif expects two arguments: a YouTube video URL and a name for the GIF it creates. So,

```sh
$ wgif https://www.youtube.com/watch?v=1A78yTvIY1k bjork.gif
```

Is enough to create a GIF of [Bjork explaining her television](https://www.youtube.com/watch?v=1A78yTvIY1k). Without any extra parameters, WGif starts at
the beginning of the video, and creates a 20-frame, 480px GIF of the first second. Since GIFs are more
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

To preview the output in a Quick Look window, add the `--preview` flag:

```sh
$ wgif https://www.youtube.com/watch?v=1A78yTvIY1k bjork.gif --start 00:03:30 -d 2 -f 18 --preview
```

You'll see a preview pop up in a Quick Look window like this one:

![Preview](http://i.imgur.com/cccOnpY.png)

Droping frames shrunk the file to 2.2 megabytes, but it's still not small enough to post on my Sugarcubes fan-Tumblr.
Let's scale it down a little with the `-w` or `--width` flag:

```sh
$ wgif https://www.youtube.com/watch?v=1A78yTvIY1k bjork.gif --start 00:03:30 -d 2 -f 18 --width 350
```

And finally, now that everything's completed, let's add the `--upload` flag to automatically post it to Imgur:

```sh
$ wgif https://www.youtube.com/watch?v=1A78yTvIY1k bjork.gif --start 00:03:30 -d 2 -f 18 --width 350 --upload
Finished. GIF uploaded to Imgur at http://i.imgur.com/iA28DuR.gif
```

And here it is:

![Bjork](http://i.imgur.com/iA28DuR.gif)
### "You shouldn't let poets lie to you."

## Changes
- v0.3.0, 2014/4/20: Add Quick Look preview with `--preview` flag.
- v0.2.0, 2014/4/11: Add automatic upload to Imgur with `--upload` flag.

## Contributors
Thanks to [arlandism](https://github.com/arlandism) and [ellie007](https://github.com/ellie007) for pairing on Imgur uploads.

## Contributions
Are welcome via pull request.

## License
This project is MIT licensed. See [LICENSE.txt](https://github.com/ecmendenhall/wgif/blob/master/LICENSE.txt) for details.
