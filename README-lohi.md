# Lohi - An RFID based cassette recorder
But without cassette and recording, but with loads of fun for big and small kids.

![ENSsRLQWwAEgTYn](https://user-images.githubusercontent.com/584259/71844899-2f4c2080-3095-11ea-818f-5480b69579f9.jpeg)

## What's this?
Basically a tape deck recorder but replaces the cassettes with RFID tags. You can link up any audio playlist to an RFID tag and once the device recognizes the same tag again, it will start playing the associated playlist.

Here is a video demoing this: https://twitter.com/OleMchls/status/1150655108193169408

Under the hood it's utilizing the [MPD (**M**usic **P**layer **D**aemon)](https://www.musicpd.org/) to control the music.

## Why?
Why not?!

## Getting Started
This is a hobby / side project. You probably wont be able to _just_ clone and deploy this project for yourself. You will need to spend some time to understand the project and code, including nerves and phoenix.

All resources are out there but remember this project comes _as is_.

### Project structure

The project consists of two more or less independent repositories. There is

### Lohi
This repository.

It's the startingpoint but it only contains just minimum config and dependencies to run and deploy to Nerves. So this project:

- Has a hard dependency to Lohi-UI
- Starts and configures the Music Player Daemon (MPD)
- Gives button input to Lohi-UI
- etc...

### Lohi UI
https://github.com/OleMchls/lohi_ui

It's the main application, it has no hardware dependency, so it can be developed locally without Nerves or a RaspberryPI. This project:

- provides the phoenix app to upload and manage playlists
- gives controls to start and stop the playlist
- talks to the Lohi MPD via a mpd client (paracusia)

## Parts list
These are the components with a software dependency:
- Raspberry Pi 3 Model B+
- Joy-IT MFRC-522 (RFID reader)

Depending on how you would like to build your box you will also need:

### Power
- **USB Cable** _To cut GND place the switch._
- **Switch** _Any (at least) two way switch will do._
- **Powerbank** _I use a Anker Powerbank PowerCore 10000mAh. Remember, these add the majority of the weight and a RaspberryPI does not need much power._

### Audio
- **AMP** _If you want to build it with speakers. I used the DEBO SOUND AMP2._
- **Speaker** _For the DEBO AMP any that is < 15 Watt_
- **Audiojack** _If you also want headphone support. Make sure it's stereo and passthrough if you want to use headphones and a speaker._

### Misc
You will need all sorts of wires, LEDs and buttons:
- **4 buttons** _I used "ARCADE BUTTONS"._
- **1 LED** for general power indication
- **5 LEDs** for the boot & readiness animation
- **Wires** and tools (soldering iron, tongs, etc...)

## Wiring
HAHA IDK! But seriously, you will need some reverse engineering of https://github.com/OleMchls/lohi/blob/master/lib/lohi/io/buttons.ex#L9-L14 for the buttons and https://github.com/OleMchls/lohi/blob/master/lib/lohi/lights.ex#L20-L24 for the LEDs.

The RFID reader needs some strict pin mapping you need to fetch from: https://github.com/arjan/nerves_io_rc522#connecting-the-hardware

## Deployment
Now for the exciting part; you have the basics put together and want to start putting some Elixir to work.

### Configuration
For the project to build successfully you will need these environment variables (obviously you may want to adjust to your local network preferences):

```
MIX_TARGET=jonas-looniebox
NERVES_NETWORK_SSID=looniebox
NERVES_NETWORK_PSK=youdontknowjack
NERVES_HOST=kiddoname-looniebox # This is the for the cluster feature that is still in development
```

### Deployment

  * Clone `lohi_ui` next(adjacent) to this project
  * Install dependencies with `mix deps.get`
  * Bundle assets in `lohi_ui` via `cd ../lohi_ui && mix phx.digest`
  * Create firmware with `cd - && mix firmware`
  * Burn to an SD card with `mix firmware.burn`

## Learn more

[![](https://user-images.githubusercontent.com/584259/71847407-cf587880-309a-11ea-9221-fefeeebc5423.png)](https://www.youtube.com/watch?v=CeW3mYMDUqo)

### Links

  * Official docs: https://hexdocs.pm/nerves/getting-started.html
  * Official website: http://www.nerves-project.org/
  * Discussion Slack elixir-lang #nerves ([Invite](https://elixir-slackin.herokuapp.com/))
  * Source: https://github.com/nerves-project/nerves
