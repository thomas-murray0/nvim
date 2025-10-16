return {

  s(
    'stdout',
    fmt(
      [[
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer: std.fs.File.Writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout: *std.Io.Writer = &stdout_writer.interface;
      ]], {}, { indent_string = '', })),
  s(
    'stdin',
    fmt(
      [[
    var stdin_buffer: [1024]u8 = undefined;
    var stdin_reader: std.fs.File.Reader = std.fs.File.stdin().reader(&stdin_buffer);
    const stdin: *std.Io.Reader = &stdin_reader.interface;
      ]], {}, { indent_string = '', })),
}

