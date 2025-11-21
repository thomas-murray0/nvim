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
	s('dprint', {
		t 'std.debug.print("', i(1), t '", .{', i(2), t '};', i(0),
	}),
}
