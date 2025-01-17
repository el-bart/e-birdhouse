#include <iostream>
#include <hardware/timer.h>
#include <pico/stdlib.h>
#include <cstdio>

#include "Watchdog.hpp"

auto const pin_power = 21; // transistor-controling PIN (high == power is on)
auto const pin_input = 20; // input from IO12 on esp32-cam
auto const timeout_us = 10'000'000u;


auto time_us() { return time_us_64(); }

template<typename ...Args>
void log(Args const& ...args)
{
  auto const now_us = time_us();
  char ts[128];
  snprintf(ts, sizeof(ts), "%.6f", time_us() / 1'000'000.0);
  std::cout << ts << " ";
  ( ( std::cout << " " << args) , ... );
  std::cout << "\n";
}

void init_pins()
{
  log("initializing pins");

  gpio_init(pin_input);
  gpio_set_dir(pin_power, GPIO_IN);

  gpio_init(pin_power);
  gpio_set_dir(pin_power, GPIO_OUT);
}

void power(bool status)
{
  gpio_put(pin_power, status);
  log("power", status?"on":"off");
}

void power_cycle()
{
  power(false);
  sleep_ms(800);
  power(true);
}

auto read() { return gpio_get(pin_input); }


int main()
{
  Watchdog wdg;
  stdio_init_all();

  std::cout << "\n#########################################\n";
  log("starting");
  init_pins();
  power(true);
  log("initialized");

  log("waiting for first signal...");
  auto waiting_for_first_signal = true;

  auto last_state = read();
  auto last_changed_at = time_us();
  while(true)
  {
    sleep_ms(89);   // 100ms is the official cycle - keepping lower and prime, to avoid phase-locks
    wdg.reset();

    auto const state = read();
    auto const now_us = time_us();
    if(state != last_state)
    {
      if(waiting_for_first_signal)
      {
        log("received first signal from µC!");
        waiting_for_first_signal = false;
      }
      last_state = state;
      last_changed_at = now_us;
      continue;
    }

    auto const deadline = last_changed_at + timeout_us;
    if(deadline < now_us)
    {
      log("DEADLINE EXCEEDED!");
      power_cycle();
      waiting_for_first_signal = true;
      last_changed_at = time_us();
    }
  }
}
