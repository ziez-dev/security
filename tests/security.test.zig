const std = @import("std");
const security = @import("ziez_security");

test "middleware returns valid Middleware" {
    const mw = security.middleware(.{});
    try std.testing.expect(mw.ptr != null);
    try std.testing.expect(mw.deinit_fn != null);
}

test "SecurityConfig defaults" {
    const config = security.SecurityConfig{};
    try std.testing.expect(config.helmet != null);
    try std.testing.expect(config.xss != null);
}

test "XssConfig defaults" {
    const config = security.XssConfig{};
    try std.testing.expect(config.sanitize_body == true);
    try std.testing.expect(config.sanitize_query == true);
    try std.testing.expect(config.mode == .strip);
}

test "HstsConfig defaults" {
    const config = security.HstsConfig{};
    try std.testing.expect(config.max_age == 31_536_000);
    try std.testing.expect(config.include_sub_domains == true);
    try std.testing.expect(config.preload == false);
}
