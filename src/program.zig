const cl = @import("cl.zig");
const opencl = cl.opencl;

const std = @import("std");

const errors = @import("errors.zig");
pub const OpenCLError = errors.OpenCLError;

pub const Program = *opaque {};

pub const BuildInfo = enum(u32) {
    build_status = opencl.CL_PROGRAM_BUILD_STATUS,
    build_options = opencl.CL_PROGRAM_BUILD_OPTIONS,
    build_log = opencl.CL_PROGRAM_BUILD_LOG,
    binary_type = opencl.CL_PROGRAM_BINARY_TYPE,
    build_global_variable_total_size = opencl.CL_PROGRAM_BUILD_GLOBAL_VARIABLE_TOTAL_SIZE,
};

const Context = @import("context.zig").Context;
const DeviceId = @import("device.zig").DeviceId;

pub const Callback = fn (program: Program, user_data: ?*anyopaque) callconv(.c) void;

pub inline fn createWithSource(
    context: Context,
    strings: []const []const u8,
    allocator: std.mem.Allocator,
) !Program {
    const tmp_array: [][*c]const u8 = try allocator.alloc([*c]const u8, strings.len);
    defer allocator.free(tmp_array);

    const tmp_lengths: []usize = try allocator.alloc(usize, strings.len);
    defer allocator.free(tmp_lengths);

    for (tmp_array, tmp_lengths, strings) |*d, *dl, s| {
        d.* = @ptrCast(s.ptr);
        dl.* = @intCast(s.len);
    }

    var ret: i32 = undefined;
    const program: ?Program = @ptrCast(opencl.clCreateProgramWithSource(
        @ptrCast(context),
        @intCast(strings.len),
        tmp_array.ptr,
        tmp_lengths.ptr,
        &ret,
    ));
    if (ret == opencl.CL_SUCCESS) return program.?;

    const errors_arr = .{
        "invalid_context",  "invalid_value",
        "out_of_resources", "out_of_host_memory",
    };
    return errors.translateOpenCLError(errors_arr, ret);
}

pub inline fn compile(
    allocator: std.mem.Allocator,
    program: Program,
    devices: ?[]const DeviceId,
    options: ?[]const u8,
    input_headers: ?[]const Program,
    header_include_names: ?[]const []const u8,
    callback: ?*const Callback,
    user_data: ?*anyopaque,
) !void {
    if (@intFromBool(input_headers != null) ^ @intFromBool(header_include_names != null) == 1) {
        return OpenCLError.invalid_value;
    }

    var devices_ptr: ?[*]const DeviceId = null;
    var devices_len: u32 = 0;
    if (devices) |v| {
        devices_ptr = v.ptr;
        devices_len = @intCast(v.len);
    }

    var options_ptr: ?[*]const u8 = null;
    if (options) |v| {
        options_ptr = v.ptr;
    }

    var tmp_array: ?[][*c]const u8 = null;
    var tmp_array_ptr: ?[*][*c]const u8 = null;
    var input_headers_ptr: ?[*]const Program = null;
    var input_headers_len: u32 = 0;
    if (input_headers) |v| {
        input_headers_ptr = v.ptr;
        input_headers_len = @intCast(v.len);
    }

    if (header_include_names) |v| {
        tmp_array = try allocator.alloc([*c]const u8, v.len);
        tmp_array_ptr = tmp_array.?.ptr;

        for (tmp_array.?, v) |*d, s| {
            d.* = @ptrCast(s.ptr);
        }
    }
    defer {
        if (header_include_names) |_| {
            allocator.free(tmp_array.?);
        }
    }

    const ret: i32 = opencl.clCompileProgram(
        @ptrCast(program),
        devices_len,
        @ptrCast(devices_ptr),
        options_ptr,
        input_headers_len,
        @ptrCast(input_headers_ptr),
        tmp_array_ptr,
        @ptrCast(callback),
        user_data,
    );
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "invalid_program",         "invalid_value",
        "invalid_device",          "invalid_compiler_options",
        "invalid_operation",       "compiler_not_available",
        "compile_program_failure", "out_of_resources",
        "out_of_host_memory",
    };
    return errors.translateOpenCLError(errors_arr, ret);
}

pub inline fn link(
    context: Context,
    devices: []const DeviceId,
    options: ?[]const u8,
    input_programs: []const Program,
    callback: ?*const Callback,
    user_data: ?*anyopaque,
) OpenCLError!Program {
    var options_ptr: ?[*]const u8 = null;
    if (options) |v| {
        options_ptr = v.ptr;
    }
    var ret: i32 = undefined;
    const program: ?Program = @ptrCast(opencl.clLinkProgram(
        @ptrCast(context),
        @intCast(devices.len),
        @ptrCast(devices.ptr),
        options_ptr,
        @intCast(input_programs.len),
        @ptrCast(input_programs.ptr),
        @ptrCast(callback),
        user_data,
        &ret,
    ));
    if (ret == opencl.CL_SUCCESS) return program.?;

    const errors_arr = .{
        "invalid_context",        "invalid_value",
        "invalid_program",        "invalid_device",
        "invalid_linker_options", "invalid_operation",
        "linker_not_available",   "link_program_failure",
        "out_of_host_memory",     "out_of_resources",
    };
    return errors.translateOpenCLError(errors_arr, ret);
}

pub inline fn build(
    program: Program,
    device_list: []const DeviceId,
    options: ?[]const u8,
    callback: ?*const Callback,
    user_data: ?*anyopaque,
) OpenCLError!void {
    var options_ptr: ?[*]const u8 = null;
    if (options) |v| {
        options_ptr = v.ptr;
    }
    const ret: i32 = opencl.clBuildProgram(
        @ptrCast(program),
        @intCast(device_list.len),
        @ptrCast(device_list.ptr),
        options_ptr,
        @ptrCast(callback),
        user_data,
    );
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "out_of_host_memory",     "invalid_program",
        "out_of_resources",       "invalid_device",
        "invalid_binary",         "invalid_build_options",
        "compiler_not_available", "build_program_failure",
        "invalid_operation",
    };
    return errors.translateOpenCLError(errors_arr, ret);
}

pub inline fn get_build_info(
    program: Program,
    device: DeviceId,
    param_name: BuildInfo,
    param_value_size: usize,
    param_value: ?*anyopaque,
    param_value_size_ret: ?*usize,
) OpenCLError!void {
    const ret: i32 = opencl.clGetProgramBuildInfo(
        @ptrCast(program),
        @ptrCast(device),
        @intFromEnum(param_name),
        param_value_size,
        param_value,
        param_value_size_ret,
    );
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "invalid_device",     "invalid_value", "invalid_program", "out_of_resources",
        "out_of_host_memory",
    };
    return errors.translateOpenCLError(errors_arr, ret);
}

pub inline fn retain(program: Program) OpenCLError!void {
    const ret: i32 = opencl.clRetainProgram(@ptrCast(program));
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{ "out_of_host_memory", "invalid_program", "out_of_resources" };
    return errors.translateOpenCLError(errors_arr, ret);
}

pub inline fn release(program: Program) void {
    const ret: i32 = opencl.clReleaseProgram(@ptrCast(program));
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{ "out_of_host_memory", "invalid_program", "out_of_resources" };
    std.debug.panic(
        "Unexpected error while releasing OpenCL program: {s}",
        .{@errorName(errors.translateOpenCLError(errors_arr, ret))},
    );
}
