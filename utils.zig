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
///   const text = try utils.readFile(&allocator, "file.txt");
///   defer allocator.free(text);
///   std.debug.print("{s}\n", .{text});
/// }
/// * *
/// 
/// @param allocator
/// @param file_path
/// @return file content
pub fn readFile(allocator: *std.mem.Allocator, file_path: []const u8) ![]u8 {
    const file = try std.fs.cwd().openFile(file_path, .{});
    defer file.close();

    const file_size = (try file.stat()).size;

    var buf = try allocator.alloc(u8, file_size);

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