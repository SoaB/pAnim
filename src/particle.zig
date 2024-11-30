const std = @import("std");
const math = std.math;
const rl = @cImport({
    @cDefine("SUPPORT_GIF_RECORDING", "1");
    @cInclude("Raylib.h");
});
const rand = @import("rand.zig");

// Particle struct
const MOUSE_RAD: f32 = 100;
const MAX_RADIUS: f32 = 20;
const MIN_RADIUS: f32 = 4;
pub const Particle = struct {
    x: f32,
    y: f32,
    vx: f32,
    vy: f32,
    radius: f32,
    pushX: f32,
    pushY: f32,
    friction: f32,
    w: f32,
    h: f32,
    pub fn new(w: u32, h: u32) Particle {
        var p: Particle = undefined;
        p.w = @floatFromInt(w);
        p.h = @floatFromInt(h);
        p.radius = rand.float32() * MAX_RADIUS + MIN_RADIUS;
        p.x = p.radius + rand.float32() * (p.w - p.radius * 2);
        p.y = p.radius + rand.float32() * (p.h - p.radius * 2);
        p.vx = rand.float32() * 2 - 1;
        p.vy = rand.float32() * 2 - 1;
        p.pushX = 0;
        p.pushY = 0;
        p.friction = 0.95;
        return p;
    }

    pub fn draw(self: *Particle) void {
        const pos: rl.Vector2 = .{ .x = self.x, .y = self.y };
        const c: u8 = 255 - @as(u8, @intFromFloat(255 * self.radius / MAX_RADIUS));
        const col: rl.Color = .{ .r = c, .g = 5, .b = 5, .a = 255 };
        rl.DrawCircleV(pos, self.radius, col);
    }

    pub fn update(self: *Particle, mp: bool, mu: rl.Vector2) void {
        if (mp) {
            const dx: f32 = self.x - mu.x;
            const dy: f32 = self.y - mu.y;
            const distance: f32 = math.hypot(dx, dy);
            const force: f32 = (MOUSE_RAD / distance);
            if (distance < MOUSE_RAD) {
                const angle: f32 = math.atan2(dy, dx);
                self.pushX += math.cos(angle) * force;
                self.pushY += math.sin(angle) * force;
            }
        }
        self.pushX *= self.friction;
        self.pushY *= self.friction;
        self.x += (self.pushX + self.vx);
        self.y += (self.pushY + self.vy);
        const ww: f32 = self.w - self.radius;
        const hh: f32 = self.h - self.radius;
        if (self.x < self.radius) {
            self.x = self.radius;
            self.vx *= -1;
        } else if (self.x > ww) {
            self.x = ww;
            self.vx *= -1;
        }
        if (self.y < self.radius) {
            self.y = self.radius;
            self.vy *= -1;
        } else if (self.y > hh) {
            self.y = hh;
            self.vy *= -1;
        }
    }
};
