const std = @import("std");
//var rand = std.rand.DefaultPrng.init();
//const seed1: u64 = @as(u64, @bitCast(std.time.milliTimestamp()));
var rnd: std.Random.Xoshiro256 = undefined;

pub fn init() void {
    var seed: u64 = undefined;
    std.posix.getrandom(std.mem.asBytes(&seed)) catch |err| {
        std.log.err("getrandom failed with error: {}", .{err});
        seed = 78786937;
    };

    rnd = std.Random.Xoshiro256.init(seed);
}
pub fn int32() i32 {
    return rnd.random().int(i32);
}
pub fn uint32() u32 {
    return rnd.random().int(u32);
}
pub fn uint32Range(min: u32, max: u32) u32 {
    return rnd.random().uintLessThan(u32, max - min) + min;
}
pub fn int32Range(min: i32, max: i32) i32 {
    return rnd.random().intRangeLessThan(i32, min, max);
}
pub fn float32() f32 {
    return rnd.random().float(f32);
}
