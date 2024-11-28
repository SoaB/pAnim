const std = @import("std");
const math = std.math;
const rl = @cImport({
    @cDefine("SUPPORT_GIF_RECORDING", "1");
    @cInclude("Raylib.h");
});

const particle = @import("particle.zig").Particle;

const EFFECT_NAME = "Effect1";
const MAX_ITEMS = 100;
pub const Effect1 = struct {
    pub const NAME = EFFECT_NAME;
    var Particles: [MAX_ITEMS]particle = undefined;
    var w: u32 = 0;
    var h: u32 = 0;
    pub fn init(width: u32, height: u32) void {
        w = width;
        h = height;
        for (0..MAX_ITEMS) |i| {
            Particles[i] = particle.new(w, h);
        }
    }
    pub fn connectParticles() void {
        const maxDistance: f32 = 80;
        for (0..MAX_ITEMS - 1) |a| {
            for ((a + 1)..MAX_ITEMS) |b| {
                const dx: f32 = Particles[a].x - Particles[b].x;
                const dy: f32 = Particles[a].y - Particles[b].y;
                const distance: f32 = math.hypot(dx, dy);
                if (distance < maxDistance) {
                    const opacity: u8 = @as(u8, @intFromFloat(255.0 * (1.0 - distance / maxDistance)));
                    const col: rl.Color = .{ .r = 255, .g = 255, .b = 255, .a = opacity };
                    const x: i32 = @intFromFloat(Particles[a].x);
                    const y: i32 = @intFromFloat(Particles[a].y);
                    const x1: i32 = @intFromFloat(Particles[b].x);
                    const y1: i32 = @intFromFloat(Particles[b].y);
                    rl.DrawLine(x, y, x1, y1, col);
                }
            }
        }
    }
    pub fn update() void {
        for (0..MAX_ITEMS) |i| {
            Particles[i].update(w, h);
        }
    }
    pub fn draw() void {
        for (0..MAX_ITEMS) |i| {
            Particles[i].draw();
        }
        connectParticles();
    }
};
