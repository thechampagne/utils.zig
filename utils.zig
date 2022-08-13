// Copyright (c) 2022 XXIV
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
const std = @import("std");

/// Read a file
/// 
/// Example:
/// * *
/// const std = @import("std");
/// const utils = @import("utils.zig");
/// 
/// pub fn main() !void {
///   var allocator = std.heap.page_allocator;
///   const text = try utils.readFile(allocator, "file.txt");
///   defer allocator.free(text);
///   std.debug.print("{s}\n", .{text});
/// }
/// * *
/// 
/// @param allocator
/// @param file_path
/// @return file content
pub fn readFile(allocator: std.mem.Allocator, file_path: []const u8) ![]u8 {
    const file = try std.fs.cwd().openFile(file_path, .{});
    defer file.close();

    const file_size = (try file.stat()).size;

    var buf = try allocator.alloc(u8, file_size);
    errdefer allocator.free(buf);

    _ = try file.read(buf);

    return buf;
}

/// Write a file
/// 
/// Example:
/// * *
/// const std = @import("std");
/// const utils = @import("utils.zig");
/// 
/// pub fn main() !void {
///   try utils.writeFile("file.txt", "Hello World!");
/// }
/// * *
/// 
/// @param file_path
/// @param bytes content
pub fn writeFile(file_path: []const u8, bytes: []const u8) !void {
    const file = try std.fs.cwd().createFile(file_path, .{});
    defer file.close();

    _ = try file.write(bytes);
}

/// Read directory
/// 
/// Example:
/// * *
/// const std = @import("std");
/// const utils = @import("utils.zig");
/// 
/// pub fn main() !void {
///   var allocator = std.heap.page_allocator;
///   const dir = try utils.readDir(allocator,".");
///   defer allocator.free(dir);
/// 
///   for (dir) |entry| {
///     switch (entry.kind) {
///       .Directory => std.debug.print("Name: {s}, Kind: Directory\n", .{entry.name}),
///       .File => std.debug.print("Name: {s}, Kind: File\n", .{entry.name}),
///       else => std.debug.print("Name: {s}\n", .{entry.name})
///     }
///   }
/// }
/// * *
/// 
/// @param allocator
/// @param dir_path
/// @param Slice of std.fs.Dir.Entry
pub fn readDir(allocator: std.mem.Allocator, dir_path: []const u8) ![]std.fs.Dir.Entry {
    var dir = try std.fs.cwd().openDir(dir_path, .{ .iterate = true });
    defer dir.close();

    var entries = try allocator.alloc(std.fs.Dir.Entry, 0);
    errdefer allocator.free(entries);

    var iter = dir.iterate();
    var i: usize = 0;
    while (try iter.next()) |entry| : (i += 1) {
        entries = try allocator.realloc(entries, (i + 1));
        entries[i] = entry;
    }

    return entries;
}

/// Read string from stdin
/// 
/// Example:
/// * *
/// const std = @import("std");
/// const utils = @import("utils.zig");
/// 
/// pub fn main() !void {
///   var allocator = std.heap.page_allocator;
///   const str = try utils.readString(allocator,'\n');
///   defer allocator.free(str);
///   std.debug.print("{s}\n", .{str});
/// }
/// * *
/// 
/// @param allocator
/// @param delimiter
/// @param Slice of bytes
pub fn readString(allocator: std.mem.Allocator, delimiter: u8) ![]u8 {
    const stdin = std.io.getStdIn().reader();
    var buffer = try allocator.alloc(u8, 0);
    errdefer allocator.free(buffer);
    var i: usize = 0;
    var byte = try stdin.readByte();
    while (byte != delimiter ) : ({ byte = try stdin.readByte(); i += 1; }) {
        buffer = try allocator.realloc(buffer, (i + 1));
        buffer[i] = byte;
    }
    return buffer;
}