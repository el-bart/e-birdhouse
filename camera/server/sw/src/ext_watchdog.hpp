#pragma once

namespace detail
{
constexpr auto ext_wdg_pin = 12;
constexpr auto toggle_delay_ms = 50u; // 2*10ms == 10Hz
}

inline void ext_watchdog_init()
{
  pinMode(detail::ext_wdg_pin, OUTPUT);
  digitalWrite(detail::ext_wdg_pin, HIGH);
}

inline void ext_watchdog_reset()
{
  static auto pin_state = LOW;
  static auto last_update = millis();

  auto const now = millis();
  auto const next_update = last_update + detail::toggle_delay_ms;   // note: may roll over!

  if( next_update <= now || next_update < last_update )
  {
    digitalWrite(detail::ext_wdg_pin, pin_state);
    pin_state = pin_state == LOW ? HIGH : LOW;
    last_update = now;
  }
}
