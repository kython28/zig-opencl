const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const opencl_version = b.option([]const u8, "opencl_version", "Opencl Target Version (default: 300)") orelse "300";

    const options = b.addOptions();
    options.addOption([]const u8, "opencl_version", opencl_version);

    const module = b.addModule("opencl", .{
        .root_source_file = b.path("src/opencl.zig"),
        .target = target,
        .optimize = optimize
    });
    module.addIncludePath(.{
        .cwd_relative = "/usr/include/"
    });
    module.linkSystemLibrary("OpenCL", .{
        .needed = true
    });
    module.linkSystemLibrary("c", .{
        .needed = true
    });
    module.addOptions("opencl_config", options);
}
