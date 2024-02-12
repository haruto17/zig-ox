const std = @import("std");

pub fn main() !void {
    // const matrix: [3][3]u32 = .{
    //     .{ 1, 2, 3 },
    //     .{ 4, 5, 6 },
    //     .{ 7, 8, 9 },
    // };

    var count: usize = 1;

    while (count <= 9) : (count += 1) {
        std.debug.print("{d}\n", .{count});
    }
}
