const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const module = b.addModule("opencl", .{
        .root_source_file = b.path("src/opencl.zig"),
        .target = target,
        .optimize = optimize,
    });
    const headers = b.dependency("opencl_headers", .{});
    module.addIncludePath(headers.path(""));
    if (target.result.os.tag == .windows) {
        module.addLibraryPath(.{ .cwd_relative = "C:\\Windows\\System32\\" });
    } else {
        module.addIncludePath(.{ .cwd_relative = "/usr/include/" });
    }
    module.linkSystemLibrary("OpenCL", .{ .needed = true });
    module.linkSystemLibrary("c", .{ .needed = true });

    const unit_tests_module = b.addModule("Unit tests", .{
        .root_source_file = b.path("tests/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    unit_tests_module.addImport("opencl", module);

    const exe_unit_tests = b.addTest(.{
        .root_module = unit_tests_module,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);
    run_exe_unit_tests.has_side_effects = true;

    // // Similar to creating the run step earlier, this exposes a `test` step to
    // // the `zig build --help` menu, providing a way for the user to request
    // // running the unit tests.
    const test_step = b.step("test", "Run unit tests");
    // test_step.dependOn(&run_lib_unit_tests.step);
    test_step.dependOn(&run_exe_unit_tests.step);
}
