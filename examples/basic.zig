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
