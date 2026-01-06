return {
	s(
		'stdout',
		fmt([[
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer: std.fs.File.Writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout: *std.Io.Writer = &stdout_writer.interface;
      ]], {})),
	s(
		'stdin',
		fmt([[
    var stdin_buffer: [1024]u8 = undefined;
    var stdin_reader: std.fs.File.Reader = std.fs.File.stdin().reader(&stdin_buffer);
    const stdin: *std.Io.Reader = &stdin_reader.interface;
      ]], {})),
	s(
		'gpa',
		fmt([[
			var gpa = std.heap.GeneralPurposeAllocator(.{{}}){{}};
			defer _ = gpa.deinit();
			const allocator = gpa.allocator();
			]], {})),
  s("rfile_alloc", fmt([[
		var file: std.fs.File = try std.fs.cwd().openFile({}, .{{ .mode = {}}});
		defer file.close();
		var file_reader: std.fs.File.Reader = file.reader(&.{{}});
		const file_interface: *std.Io.Reader = &file_reader.interface;
		var buffer: []u8 = try file_interface.allocRemaining(allocator, .unlimited);
  ]], {
    i(1, "path"),
    i(2, ".read_only")
  })),
  s("rfile_buffer", fmt([[
		var file: std.fs.File = try std.fs.cwd().openFile({}, .{{ .mode = {}}});
		defer file.close();
		var buffer_reader: [{}]u8 = undefined;
		var file_reader: std.fs.File.Reader = file.reader(&buffer_reader);
  ]], {
    i(1, "path"),
    i(2, ".read_only"),
    i(3, "1024")
  })),
  s("wfile_buffer", fmt([[
		var file: std.fs.File = try std.fs.cwd().openFile({}, .{{ .mode = {}}});
		defer file.close();
		var buffer_writer: [{}]u8 = undefined;
		var file_writer: std.fs.File.Writer = file.writer(&buffer_writer);
		const file_interface: *std.Io.Writer = &file_writer.interface;
  ]], {
    i(1, "path"),
    i(2, ".write_only"),
    i(3, "1024")
  })),
	s('dprint', {
		t 'std.debug.print("', i(1), t '", .{', i(2), t '});', i(0),
	}),
}
