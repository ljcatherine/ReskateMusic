#pragma once
namespace dingosdk::music_overlay {
bool enabled() noexcept;
void set_enabled(bool value);
bool pending();
void draw();
}
