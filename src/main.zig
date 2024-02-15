const std = @import("std");
const io = std.io;

fn draw_board(board: [3][3][]const u8) !void {
    const stdout = io.getStdOut().writer();

    try stdout.print("  1 2 3\n", .{});

    for (board, 0..) |value, i| {
        try stdout.print("{} {s} {s} {s}\n", .{ i + 1, value[0], value[1], value[2] });
    }
    try stdout.print("\n", .{});
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

fn check_board(board: [3][3][]const u8, symbol: []const u8) bool {
    // horizontal check
    if (std.mem.eql(u8, board[0][0], symbol) and std.mem.eql(u8, board[0][1], symbol) and std.mem.eql(u8, board[0][2], symbol)) {
        return true;
    } else if (std.mem.eql(u8, board[1][0], symbol) and std.mem.eql(u8, board[1][1], symbol) and std.mem.eql(u8, board[1][2], symbol)) {
        return true;
    } else if (std.mem.eql(u8, board[2][0], symbol) and std.mem.eql(u8, board[2][1], symbol) and std.mem.eql(u8, board[2][2], symbol)) {
        return true;
    }

    // vertical check
    if (std.mem.eql(u8, board[0][0], symbol) and std.mem.eql(u8, board[1][0], symbol) and std.mem.eql(u8, board[2][0], symbol)) {
        return true;
    } else if (std.mem.eql(u8, board[0][1], symbol) and std.mem.eql(u8, board[1][1], symbol) and std.mem.eql(u8, board[2][1], symbol)) {
        return true;
    } else if (std.mem.eql(u8, board[0][2], symbol) and std.mem.eql(u8, board[1][2], symbol) and std.mem.eql(u8, board[2][2], symbol)) {
        return true;
    }
    // diagonal check
    if (std.mem.eql(u8, board[0][0], symbol) and std.mem.eql(u8, board[1][1], symbol) and std.mem.eql(u8, board[2][2], symbol)) {
        return true;
    } else if (std.mem.eql(u8, board[0][2], symbol) and std.mem.eql(u8, board[1][1], symbol) and std.mem.eql(u8, board[2][0], symbol)) {
        return true;
    }

    return false;
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
        try stdout.print("\x1b[2J\x1b[2;0H", .{});
        try draw_board(board);

        if (i % 2 != 0) {
            try stdout.print("turn: o\n", .{});
        } else {
            try stdout.print("turn: x\n", .{});
        }

        try stdout.print("x y\n", .{});
        const x = parseUsize(nextToken(stdin.reader(), &line_buf));
        const y = parseUsize(nextLine(stdin.reader(), &line_buf));

        if (i % 2 != 0) {
            board[x - 1][y - 1] = "o";
            if (check_board(board, "o")) {
                try stdout.print("player o win!!\n", .{});
                return;
            } else {
                i += 1;
            }
        } else {
            board[x - 1][y - 1] = "x";
            if (check_board(board, "x")) {
                try stdout.print("player x win!!\n", .{});
                return;
            } else {
                i += 1;
            }
        }
    }

    try stdout.print("draw\n", .{});
}
