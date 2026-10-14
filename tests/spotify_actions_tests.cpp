#include "../src/Extension/Music/spotify_actions.h"
#include <iostream>
int main() {
    using namespace dingosdk::spotify_web;
    int failures = 0;
    auto check = [&](bool value) { if (!value) ++failures; };
    check(valid_track_uri("spotify:track:0123456789ABCDEFGHIJKL"));
    check(!valid_track_uri("spotify:album:0123456789ABCDEFGHIJKL"));
    check(!valid_track_uri("spotify:track:0123456789ABCDEFGHIJK"));
    check(!valid_track_uri("spotify:track:0123456789ABCDEFGHIJKL\""));
    check(!valid_track_uri("spotify:track:0123456789ABCDEFGHIJK\""));
    check(!valid_track_uri("spotify:track:0123456789ABCDEFGHIJK/"));
    check(valid_control("shuffle", "true"));
    check(valid_control("shuffle", "false"));
    check(valid_control("repeat", "off"));
    check(valid_control("repeat", "context"));
    check(valid_control("repeat", "track"));
    check(!valid_control("repeat", "off&device_id=elsewhere"));
    check(!valid_control("shuffle", "1"));
    check(!valid_control("seek", "10"));
    std::cout << failures << " failed checks\n";
    return failures ? 1 : 0;
}

