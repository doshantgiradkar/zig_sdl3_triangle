const std = @import("std");
const sdl = @import("sdl");

const Global = struct {
    fps: f32,
    screen_width: u16,
    screen_height: u16,
    title: [:0]u8,
};

pub fn main() !void {
    defer sdl.shutdown();
    const global: Global = .{ .fps = 60.0, .screen_width = 800, .screen_height = 600, .title =  @constCast("") };

    const initFlags: sdl.InitFlags = .{ .video = true, .events = true };
    try sdl.init(initFlags);

    var fps_capper = sdl.extras.FramerateCapper(f32){ .mode = .{ .limited = global.fps } };

    var should_quit = false;
    const window = try sdl.video.Window.init(global.title, global.screen_width, global.screen_height, .{});
    defer window.deinit();

    const renderer = try sdl.render.Renderer.init(window, null);
    defer renderer.deinit();

    const vert = [_]sdl.render.Vertex{
        .{
            .position = .{ .x = global.screen_width/2, .y = 30 },
            .color = .{
                .r = 1,
                .g = 0,
                .b = 0,
                .a = 1,
            },
            .tex_coord = .{ .x = 0, .y = 0 },
        },
        .{
            .position = .{ .x = global.screen_width/6, .y = global.screen_height - 30 },
            .color = .{
                .r = 0,
                .g = 1,
                .b = 0,
                .a = 1,
            },
            .tex_coord = .{ .x = 0, .y = 0 },
        },
        .{
            .position = .{ .x = (global.screen_width/6)*5, .y = global.screen_height - 30 },
            .color = .{
                .r = 0,
                .g = 0,
                .b = 1,
                .a = 1,
            },
            .tex_coord = .{ .x = 0, .y = 0 },
        },
    };

    while (!should_quit) {
        const dt = fps_capper.delay();
        _ = dt;

        while (sdl.events.poll()) |event| {
            switch (event) {
                .quit => should_quit = true,
                .terminating => should_quit = true,
                else => {},
            }
        }

        try renderer.setDrawColor( .{ .r = 0, .g = 0, .b = 0, .a = 255 } );
        try renderer.clear();
        try renderer.renderGeometry(null, &vert, null);
        try renderer.present();
    }
}
