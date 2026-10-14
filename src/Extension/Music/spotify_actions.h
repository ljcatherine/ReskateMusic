#pragma once
#include <string_view>
namespace dingosdk::spotify_web {
inline bool valid_track_uri(std::string_view uri) {
    return uri.starts_with("spotify:track:") && uri.size() == 36 &&
        uri.find_first_not_of("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789", 14) == std::string_view::npos;
}
inline bool valid_control(std::string_view action, std::string_view value) {
    return (action == "shuffle" && (value == "true" || value == "false")) ||
        (action == "repeat" && (value == "off" || value == "track" || value == "context"));
}
}
