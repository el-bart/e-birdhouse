#pragma once

namespace detail
{
constexpr auto ext_wdg_pin = 12;
constexpr auto update_delay_ms = 100u;
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

  auto const next_update = last_update + detail::update_delay_ms;   // note: may roll over!

  if( next_update <= millis() || next_update < last_update )
  {
    digitalWrite(detail::ext_wdg_pin, pin_state);
    pin_state = pin_state == LOW ? HIGH : LOW;
  }
}
