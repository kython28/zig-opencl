const cl = @import("cl.zig");
const opencl = cl.opencl;
const std = @import("std");

pub const enums = @import("enums/context.zig");
const d_enums = @import("enums/device.zig");
const errors = @import("errors.zig");

pub const cl_context_properties = opencl.cl_context_properties;
pub const cl_context = *opaque {};

pub const pfn_notify_callback = fn (errinfo: [*c]const u8, private_info: ?*const anyopaque, cb: usize, user_data: ?*anyopaque) callconv(.C) void;

const cl_device_id = @import("device.zig").cl_device_id;

pub inline fn create(
    properties: ?[]const cl_context_properties, devices: []const cl_device_id,
    pfn_notify: ?*const pfn_notify_callback, 
    user_data: ?*anyopaque
)  errors.opencl_error!cl_context {
    var properties_ptr: ?[*]const cl_context_properties = null;
    if (properties) |v| {
        properties_ptr = v.ptr;
    }

    var ret: i32 = undefined;
    const context: ?cl_context = @ptrCast(opencl.clCreateContext(
        properties_ptr, @intCast(devices.len), @ptrCast(devices.ptr), pfn_notify, user_data,
        &ret
    ));
    if (ret == opencl.CL_SUCCESS) return context.?;

    const errors_arr = .{
        "invalid_value", "out_of_host_memory", "invalid_platform", "device_not_available",
        "out_of_resources", "invalid_property"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub inline fn create_from_type(
    properties: ?[]const cl_context_properties, device_type: d_enums.device_type,
    pfn_notify: ?* const pfn_notify_callback,
    user_data: ?*anyopaque
) errors.opencl_error!cl_context {
    var properties_ptr: ?[*]const cl_context_properties = null;
    if (properties) |v| {
        properties_ptr = v.ptr;
    }

    var ret: i32 = undefined;
    const context: ?cl_context = @ptrCast(opencl.clCreateContextFromType(
        properties_ptr, @intFromEnum(device_type), pfn_notify, user_data,
        &ret
    ));
    if (ret == opencl.CL_SUCCESS) return context.?;

    const errors_arr = .{
        "invalid_value", "out_of_host_memory", "invalid_platform", "device_not_available",
        "out_of_resources", "invalid_device_type", "device_not_found"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub inline fn get_info(context: cl_context, param_name: enums.context_info,
    param_value_size: usize, param_value: ?*anyopaque,
    param_value_size_ret: ?*usize) errors.opencl_error!void {
    const ret: i32 = opencl.clGetContextInfo(
        @ptrCast(context), @intFromEnum(param_name), param_value_size, param_value,
        param_value_size_ret
    );
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "invalid_value", "out_of_host_memory",
        "invalid_context", "out_of_resources"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub inline fn retain(context: cl_context) errors.opencl_error!void {
    const ret: i32 = opencl.clRetainContext(@ptrCast(context));
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "out_of_host_memory", "invalid_context", "out_of_resources"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub inline fn release(context: cl_context) void {
    const ret: i32 = opencl.clReleaseContext(@ptrCast(context));
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "out_of_host_memory", "invalid_context", "out_of_resources"
    };
    std.debug.panic("Unexcepted error while releasing OpenCL context: {s}", .{
        @errorName(errors.translate_opencl_error(errors_arr, ret))}
    );
}
