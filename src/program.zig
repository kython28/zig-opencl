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
    const program: cl_program = opencl.clCreateProgramWithSource(
        context, @intCast(strings.len), tmp_array.ptr, tmp_lengths.ptr,
        &ret
    );
    if (ret == opencl.CL_SUCCESS) return program;

    const errors_arr = .{
        "invalid_context", "invalid_value", "out_of_resources",
        "out_of_host_memory"
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
