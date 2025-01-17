#pragma once
#include <hardware/watchdog.h>

struct Watchdog final
{
  Watchdog()
  {
    auto constexpr MHzs = XOSC_KHZ / 1'000u;
    watchdog_start_tick(MHzs);
    auto constexpr pause_on_debug = false;
    auto constexpr delay_ms = 2'000;
    watchdog_enable(delay_ms, pause_on_debug);
  }

  Watchdog(Watchdog const&) = delete;
  Watchdog& operator=(Watchdog const&) = delete;
  Watchdog(Watchdog&&) = delete;
  Watchdog& operator=(Watchdog&&) = delete;

  void reset() { watchdog_update(); }
  static bool rebooted_by_watchdog() { return watchdog_caused_reboot(); }
};
