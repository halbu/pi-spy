# pi-spy

![](pi-spy.gif)

Monitoring service and command-line tool for Raspberry Pi. Stores periodic snapshots of temperature, CPU and memory use in a sqlite3 database.

## Motivation

I want to know if my Raspberry Pi 3 Model B is melting

## Installation

* Prerequisites
  * sqlite3: `sudo apt-get install sqlite3`
* Setup
  * Clone repository into user `pi`'s home directory
  * `./pi-spy-setup.sh`

## Usage

`pi-spy-cli` or alternatively `sqlite3 ~/pi-spy/pi-spy.db "your custom query here"`

#### Flags
 
 * `-x` Extended output (print additional information that is not typically subject to significant short-term change e.g. SD card memory usage)

## Todo

- [ ] Monitor more stuff
- [ ] Optional arguments to specify particular criteria or timespan for reporting
