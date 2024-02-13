const std = @import("std");
const io = std.io;

fn draw_board(board: [3][3][]const u8) !void {
    const stdout = io.getStdOut().writer();

    try stdout.print("  1 2 3\n", .{});

    for (board, 0..) |value, i| {
        try stdout.print("{} {s} {s} {s}\n", .{ i + 1, value[0], value[1], value[2] });
    }
}

fn nextToken(reader: anytype, buffer: []u8) []const u8 {
    return reader.readUntilDelimiter(
        buffer,
        ' ',
    ) catch unreachable;
}

fn nextLine(reader: anytype, buffer: []u8) []const u8 {
    const line = reader.readUntilDelimiterOrEof(
        buffer,
        '\n',
    ) catch unreachable;

    if (@import("builtin").os.tag == .windows) {
        return std.mem.trimRight(u8, line.?, "\r");
    } else {
        return line.?;
    }
}

fn parseUsize(buf: []const u8) usize {
    return std.fmt.parseInt(usize, buf, 10) catch unreachable;
}

pub fn main() !void {
    var board: [3][3][]const u8 = .{
        .{ "-", "-", "-" },
        .{ "-", "-", "-" },
        .{ "-", "-", "-" },
    };

    const stdout = io.getStdOut().writer();
    const stdin = io.getStdIn();

    try stdout.print("Tick Tack Toe\n", .{});

    var line_buf: [20]u8 = undefined;
    var i: u8 = 1;
    while (i <= 9) {
        try draw_board(board);

        const x = parseUsize(nextToken(stdin.reader(), &line_buf));
        const y = parseUsize(nextLine(stdin.reader(), &line_buf));

        if (i % 2 != 0) {
            board[x - 1][y - 1] = "o";
        } else if (i % 2 == 0) {
            board[x - 1][y - 1] = "x";
        }

        i += 1;
    }
}
