const cl = @import("cl.zig");
const opencl = cl.opencl;

const std = @import("std");

pub const enums = @import("enums/program.zig");
const errors = @import("errors.zig");

pub const cl_program = opencl.cl_program;
pub const cl_program_build_info = opencl.cl_program_build_info;
const cl_context = opencl.cl_context;
const cl_device_id = opencl.cl_device_id;

pub const pfn_notify_callback = fn (program: cl_program, user_data: ?*anyopaque) callconv(.C) void;

pub fn create_with_source(
    context: cl_context, strings: []const []const u8,
    allocator: std.mem.Allocator
) !cl_program {
    const tmp_array: [][*c]const u8 = try allocator.alloc([*c]const u8, strings.len);
    defer allocator.free(tmp_array);

    const tmp_lengths: []usize = try allocator.alloc(usize, strings.len);
    defer allocator.free(tmp_lengths);

    for (tmp_array, tmp_lengths, strings) |*d, *dl, s| {
        d.* = @ptrCast(s.ptr);
        dl.* = @intCast(s.len);
    }

    var ret: i32 = undefined;
    const program: ?cl_program = opencl.clCreateProgramWithSource(
        context, @intCast(strings.len), tmp_array.ptr, tmp_lengths.ptr,
        &ret
    );
    if (ret == opencl.CL_SUCCESS) return program.?;

    const errors_arr = .{
        "invalid_context", "invalid_value", "out_of_resources",
        "out_of_host_memory"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn compile(
    allocator: std.mem.Allocator, program: cl_program, devices: ?[]const cl_device_id,
    options: ?[]const u8, input_headers: ?[]const cl_program,
    header_include_names: ?[]const []const u8,
    callback: ?*const pfn_notify_callback, user_data: ?*anyopaque
) !void {
    if (@intFromBool(input_headers != null)^@intFromBool(header_include_names != null) == 1) {
        return errors.opencl_error.invalid_value;
    }

    var devices_ptr: ?[*]const cl_device_id = null;
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
    var input_headers_ptr: ?[*]const cl_program = null;
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
        program, devices_len, devices_ptr, options_ptr,
        input_headers_len, input_headers_ptr,
        tmp_array_ptr, callback, user_data
    );
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "invalid_program", "invalid_value", "invalid_device",
        "invalid_compiler_options", "invalid_operation",
        "compiler_not_available", "compile_program_failure",
        "out_of_resources", "out_of_host_memory"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn link(
    context: cl_context, devices: []const cl_device_id,
    options: ?[]const u8, input_programs: []const cl_program,
    callback: ?*const pfn_notify_callback, user_data: ?*anyopaque
) errors.opencl_error!cl_program {
    var options_ptr: ?[*]const u8 = null;
    if (options) |v| {
        options_ptr = v.ptr;
    }
    var ret: i32 = undefined;
    const program: ?cl_program = opencl.clLinkProgram(
        context, @intCast(devices.len), devices.ptr, options_ptr,
        @intCast(input_programs.len), input_programs.ptr,
        callback, user_data, &ret
    );
    if (ret == opencl.CL_SUCCESS) return program.?;

    const errors_arr = .{
        "invalid_context", "invalid_value", "invalid_program",
        "invalid_device", "invalid_linker_options",
        "invalid_operation", "linker_not_available",
        "link_program_failure", "out_of_host_memory",
        "out_of_resources"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn build(
    program: cl_program, device_list: []const cl_device_id, options: ?[]const u8,
    callback: ?*const pfn_notify_callback, user_data: ?*anyopaque
) errors.opencl_error!void {
    var options_ptr: ?[*]const u8 = null;
    if (options) |v| {
        options_ptr = v.ptr;
    }
    const ret: i32 = opencl.clBuildProgram(
        program, @intCast(device_list.len), device_list.ptr, options_ptr,
        callback, user_data
    );
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "out_of_host_memory", "invalid_program", "out_of_resources",
        "invalid_device", "invalid_binary", "invalid_build_options",
        "compiler_not_available", "build_program_failure", "invalid_operation"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn get_build_info(
    program: cl_program, device: cl_device_id, param_name: enums.build_info,
    param_value_size: usize, param_value: ?*anyopaque, param_value_size_ret: ?*usize
) errors.opencl_error!void {
    const ret: i32 = opencl.clGetProgramBuildInfo(
        program, device, @intFromEnum(param_name), param_value_size, param_value,
        param_value_size_ret
    );
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "invalid_device", "invalid_value", "invalid_program", "out_of_resources",
        "out_of_host_memory"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn retain(program: cl_program) errors.opencl_error!void {
    const ret: i32 = opencl.clRetainProgram(program);
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "out_of_host_memory", "invalid_program", "out_of_resources"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn release(program: cl_program) errors.opencl_error!void {
    const ret: i32 = opencl.clReleaseProgram(program);
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "out_of_host_memory", "invalid_program", "out_of_resources"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}
