const std = @import("std");

/// A dynamic string type for Halogen, focused purely on 8-bit ASCII character
/// string handling.
pub const String = struct {
    chars: std.ArrayList(u8),

    pub fn new() String {
        return .{
            .chars = .empty
        };
    }

    pub fn push(self: *String, alloc: std.mem.Allocator, addition: u8) error{OutOfMemory}!void {
        try self.chars.append(alloc, addition);
    }

    pub fn push_str(self: *String, alloc: std.mem.Allocator, addition: []const u8) error{OutOfMemory}!void {
        try self.chars.appendSlice(alloc, addition);
    }

    pub fn pop(self: *String) ?u8 {
        return self.chars.pop();
    }

    pub fn pop_str(self: *String, count: usize) ?[]u8 {
        if (self.chars.items.len < count) {
            return null;
        }
        const start = self.chars.items.len - count;
        const slice = self.chars.items[start ..];
        self.chars.items.len -= count;
        return slice;
    }

    pub fn deinit(self: *String, alloc: std.mem.Allocator) void {
        self.chars.deinit(alloc);
    }
};

test "String.new" {
    try std.testing.expectEqual(String.new().chars, std.ArrayList(u8).empty);
}

test "String.push and String.pop" {
    const allocator = std.testing.allocator;
    var s = String.new();
    try s.push(allocator, 'H');
    try s.push(allocator, 'i');
    try std.testing.expectEqual(s.pop(), 'i');
    try std.testing.expectEqual(s.pop(), 'H');
}

test "String.pop empty" {
    var s = String.new();
    try std.testing.expectEqual(s.pop(), null);
}

test "String.push_str and String.pop_str" {
    const allocator = std.testing.allocator;
    var s = String.new();
    try s.push_str(allocator, "Hello, ");
    try s.push_str(allocator, "world!");
    try std.testing.expectEqual(s.pop_str(6), "world!");
    try std.testing.expectEqual(s.pop_str(7), "Hello, ");
    try s.deinit(allocator);
}


