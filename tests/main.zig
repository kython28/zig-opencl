pub const opencl = @import("opencl");
const std = @import("std");

test {
    std.testing.refAllDecls(opencl.utils);
    std.testing.refAllDecls(opencl.platform);
    std.testing.refAllDecls(opencl.device);
    std.testing.refAllDecls(opencl.kernel);
    std.testing.refAllDecls(opencl.program);
    std.testing.refAllDecls(opencl.event);
    std.testing.refAllDecls(opencl.buffer);
    std.testing.refAllDecls(opencl.command_queue);
    std.testing.refAllDecls(opencl.context);
    std.testing.refAllDecls(opencl.errors);
}
