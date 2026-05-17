const std = @import("std");
const ziez = @import("ziez");
const security = @import("security.zig");

pub const SecurityConfig = security.SecurityConfig;
pub const HelmetConfig = security.HelmetConfig;
pub const XssConfig = security.XssConfig;
pub const XssMode = security.XssMode;
pub const CspConfig = security.CspConfig;
pub const CspDirective = security.CspDirective;
pub const HstsConfig = security.HstsConfig;

/// Returns a configured Middleware that can be passed to `app.use()`.
pub fn middleware(config: SecurityConfig) ziez.Middleware {
    return security.asMiddleware(config);
}

/// Convenience: registers security middleware on the app in one call.
pub fn setup(app: *ziez.App, config: SecurityConfig) void {
    app.use(middleware(config));
}
