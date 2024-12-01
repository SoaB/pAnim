const rl = @cImport({
    @cDefine("SUPPORT_GIF_RECORDING", "1");
    @cInclude("Raylib.h");
});

const std = @import("std");
const math = std.math;
const print = std.debug.print;
const effect1 = @import("effect1.zig").Effect1;
const rand = @import("rand.zig");

const scrWidth = 800;
const scrHeight = 600;

pub fn main() !void {
    rand.init();
    rl.InitWindow(scrWidth, scrHeight, "Noise for FUN");
    rl.SetTargetFPS(60);
    effect1.init(scrWidth, scrHeight);
    //canvas = rl.LoadRenderTexture(scrWidth, scrHeight);
    while (!rl.WindowShouldClose()) {
        rl.BeginDrawing();
        rl.ClearBackground(rl.BLACK);
        rl.BeginBlendMode(rl.BLEND_ADDITIVE);
        effect1.update();
        effect1.draw();
        rl.EndBlendMode();
        rl.EndDrawing();
    }
    //rl.UnloadRenderTexture(canvas);
    rl.CloseWindow();
}
