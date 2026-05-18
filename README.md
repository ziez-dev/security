# ziez-security

Helmet + XSS protection middleware for [ziez](https://github.com/ziez-dev/ziez).

## Requirements

- Zig 0.16.0+

## Installation

In `build.zig.zon`:

```zig
.dependencies = .{
    .ziez = .{
        .url = "https://github.com/ziez-dev/ziez/archive/refs/tags/v0.0.1.tar.gz",
        .hash = "ziez-0.0.1-zH20Gh1jAwADi2a_88hnfVHclInMW1YPLF_y7SS7CJ5Y",
    },
    .@"ziez-security" = .{
        .url = "https://github.com/ziez-dev/security/archive/refs/tags/v0.0.1.tar.gz",
        .hash = "1220b1fe03d61a1cc83ee28e918e1a2e4f0e0d6d1e23844e0c0e28194a8bbbe9d2e8",
    },
},
```

In `build.zig`:

```zig
const security_dep = b.dependency("ziez-security", .{
    .target = target,
    .optimize = optimize,
});
exe_mod.addImport("ziez_security", security_dep.module("ziez-security"));
```

## Quick Start

```zig
const std = @import("std");
const ziez = @import("ziez");
const security = @import("ziez_security");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var app = ziez.init(allocator);
    defer app.deinit();

    app.use(security.middleware(.{
        .helmet = .{},
        .xss = .{ .sanitize_body = true },
    }));

    app.get("/", struct {
        fn h(_: *ziez.Request, res: *ziez.Response) !void {
            res.json(.{ .message = "Hello with security headers!" });
        }
    }.h);

    try app.listen("0.0.0.0:3000");
}
```

## Configuration

**SecurityConfig:**

| Option | Type | Default | Description |
|---|---|---|---|
| `helmet` | `?HelmetConfig` | `.{}` | Security headers (set to `null` to disable) |
| `xss` | `?XssConfig` | `.{}` | XSS protection (set to `null` to disable) |

**HelmetConfig:**

| Option | Type | Default |
|---|---|---|
| `content_security_policy` | `?CspConfig` | `.{}` |
| `strict_transport_security` | `?HstsConfig` | `.{}` |
| `x_frame_options` | `?[]const u8` | `"SAMEORIGIN"` |
| `x_content_type_options` | `?[]const u8` | `"nosniff"` |
| `referrer_policy` | `?[]const u8` | `"no-referrer"` |
| `cross_origin_opener_policy` | `?[]const u8` | `"same-origin"` |
| `cross_origin_resource_policy` | `?[]const u8` | `"same-origin"` |
| `x_xss_protection` | `?[]const u8` | `"0"` |
| `x_powered_by` | `bool` | `true` |

**XssConfig:**

| Option | Type | Default | Description |
|---|---|---|---|
| `sanitize_body` | `bool` | `true` | Sanitize request body |
| `sanitize_query` | `bool` | `true` | Sanitize query parameters |
| `mode` | `XssMode` | `.strip` | Sanitization mode (`.strip` or `.escape`) |

## License

MIT
