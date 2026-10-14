#include "music_overlay.h"
#include "external_player.h"
#include "Extension/Profile/local_profile_runtime.h"
#include <imgui.h>
#include <algorithm>
#include <atomic>
#include <chrono>

namespace dingosdk::music_overlay {
namespace {
std::atomic<bool> visible{true};
bool preference_read{};
external_player::Track track;
std::chrono::steady_clock::time_point next_read;
void read() {
    const auto now = std::chrono::steady_clock::now();
    if (now < next_read) return;
    next_read = now + std::chrono::milliseconds(400);
    track = external_player::now();
    track.artwork.clear();
}
}
bool enabled() noexcept {
    if (!preference_read) {
        if (const auto kept = profile_runtime::local_preference("ReskateMusicOverlay")) visible.store(*kept);
        preference_read = true;
    }
    return visible.load();
}
void set_enabled(bool value) { visible.store(value); profile_runtime::set_local_preference("ReskateMusicOverlay", value); }
bool pending() {
    if (!enabled()) return false;
    read();
    return track.available && !track.title.empty();
}
void draw() {
    if (!pending()) return;
    const auto *viewport = ImGui::GetMainViewport();
    const float scale = std::clamp(viewport->Size.y / 1080.f, .75f, 2.f);
    const float width = std::min(320.f * scale, viewport->Size.x - 32.f * scale);
    ImGui::SetNextWindowPos(ImVec2(viewport->Pos.x + viewport->Size.x - 18.f * scale,
                                viewport->Pos.y + viewport->Size.y - 18.f * scale), ImGuiCond_Always, ImVec2(1, 1));
    ImGui::SetNextWindowSize(ImVec2(width, 0), ImGuiCond_Always);
    ImGui::SetNextWindowBgAlpha(.28f);
    ImGui::PushStyleVar(ImGuiStyleVar_WindowRounding, 9.f * scale);
    ImGui::PushStyleVar(ImGuiStyleVar_WindowPadding, ImVec2(12.f * scale, 9.f * scale));
    const auto flags = ImGuiWindowFlags_NoDecoration | ImGuiWindowFlags_AlwaysAutoResize |
        ImGuiWindowFlags_NoInputs | ImGuiWindowFlags_NoNav | ImGuiWindowFlags_NoSavedSettings |
        ImGuiWindowFlags_NoFocusOnAppearing;
    if (ImGui::Begin("ReskateMusic.NowPlaying", nullptr, flags)) {
        ImGui::SetWindowFontScale(scale);
        ImGui::TextColored(ImVec4(.12f, .84f, .38f, .9f), "%s", track.playing ? "NOW PLAYING" : "PAUSED");
        ImGui::TextUnformatted(track.title.c_str());
        ImGui::TextColored(ImVec4(1, 1, 1, .7f), "%s", track.artist.c_str());
    }
    ImGui::End();
    ImGui::PopStyleVar(2);
}
}
