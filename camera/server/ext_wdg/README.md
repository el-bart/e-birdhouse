# external watchdog

separate board that's there to power-cycle `esp32-cam` whenever it gets stuck.
this apparently happens a lot, and often results with issues re-initializing camera.
to wrokaround this problem secondary board, based on `rp2040` is added.

it monitors `IO12` pin output of `esp32-cam` board.
it's expecting signal at 10Hz.
if signal is not arriving for a couple seconds, extenal transistor (`2n6292`) is pulled low.
this cuts power to `esp32-cam` board.

transistor's base is connected to `GP21`.
`GP20` is input from `IO12` signal.


## build

to build run:
`./make`


## flash

connect the board via USB and copy UF2 file to flash it.
file is here:
`build/ext_wdg.uf2`
