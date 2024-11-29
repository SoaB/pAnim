const std = @import("std");
const math = std.math;
const rl = @cImport({
    @cDefine("SUPPORT_GIF_RECORDING", "1");
    @cInclude("Raylib.h");
});
const rand = @import("rand.zig");

// Particle struct
const MOUSE_RAD: f32 = 100;
pub const Particle = struct {
    x: f32,
    y: f32,
    vx: f32,
    vy: f32,
    radius: f32,
    pushX: f32,
    pushY: f32,
    friction: f32,

    pub fn new(w: u32, h: u32) Particle {
        return Particle{
            .x = rand.float32() * @as(f32, @floatFromInt(w - 40 + 20)),
            .y = rand.float32() * @as(f32, @floatFromInt(h - 40 + 20)),
            .vx = rand.float32() * 2 - 1,
            .vy = rand.float32() * 2 - 1,
            .radius = rand.float32() * 10 + 4,
            .pushX = 0,
            .pushY = 0,
            .friction = 0.95,
        };
    }

    pub fn draw(self: *Particle) void {
        const pos: rl.Vector2 = .{ .x = self.x, .y = self.y };
        const c: u8 = 255 - @as(u8, @intFromFloat(255 * self.radius / 14));
        const col: rl.Color = .{ .r = c, .g = 5, .b = 5, .a = 255 };
        rl.DrawCircleV(pos, self.radius, col);
    }

    pub fn update(self: *Particle, w: u32, h: u32) void {
        if (rl.IsMouseButtonDown(rl.MOUSE_BUTTON_LEFT)) {
            const mouse: rl.Vector2 = rl.GetMousePosition();
            const dx: f32 = self.x - mouse.x;
            const dy: f32 = self.y - mouse.y;
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
        const ww: f32 = @as(f32, @floatFromInt(w)) - self.radius;
        const hh: f32 = @as(f32, @floatFromInt(h)) - self.radius;
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
