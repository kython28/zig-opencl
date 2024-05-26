const cl = @import("cl.zig");
const opencl = cl.opencl;
const std = @import("std");

pub const enums = @import("enums/context.zig");
const d_enums = @import("enums/device.zig");
const errors = @import("errors.zig");

pub const cl_context_properties = opencl.cl_context_properties;
pub const cl_context = opencl.cl_context;

pub const pfn_notify_callback = fn (errinfo: [*c]const u8, private_info: ?*const anyopaque, cb: usize, user_data: ?*anyopaque) callconv(.C) void;

const device_id = opencl.cl_device_id;

pub fn create(
    properties: ?[]const cl_context_properties, devices: []const device_id,
    pfn_notify: ?*const pfn_notify_callback, 
    user_data: ?*anyopaque
)  errors.opencl_error!cl_context {
    var properties_ptr: ?[*]const cl_context_properties = null;
    if (properties) |v| {
        properties_ptr = v.ptr;
    }

    var ret: i32 = undefined;
    const context: cl_context = opencl.clCreateContext(
        properties_ptr, @intCast(devices.len), devices.ptr, pfn_notify, user_data,
        &ret
    );
    if (ret == opencl.CL_SUCCESS) return context;

    const errors_arr = .{
        "invalid_value", "out_of_host_memory", "invalid_platform", "device_not_available",
        "out_of_resources"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn create_from_type(
    properties: ?[]const cl_context_properties, device_type: d_enums.device_type,
    pfn_notify: ?* const pfn_notify_callback,
    user_data: ?*anyopaque
) errors.opencl_error!cl_context {
    var properties_ptr: ?[*]const cl_context_properties = null;
    if (properties) |v| {
        properties_ptr = v.ptr;
    }

    var ret: i32 = undefined;
    const context: cl_context = opencl.clCreateContextFromType(
        properties_ptr, @intFromEnum(device_type), pfn_notify, user_data,
        &ret
    );
    if (ret == opencl.CL_SUCCESS) return context;

    const errors_arr = .{
        "invalid_value", "out_of_host_memory", "invalid_platform", "device_not_available",
        "out_of_resources", "invalid_device_type", "device_not_found"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn get_info(context: cl_context, param_name: enums.context_info,
    param_value_size: usize, param_value: ?*anyopaque,
    param_value_size_ret: ?*usize) errors.opencl_error!void {
    const ret: i32 = opencl.clGetDeviceInfo(
        context, @intFromEnum(param_name), param_value_size, param_value,
        param_value_size_ret
    );
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "invalid_value", "out_of_host_memory",
        "invalid_context", "out_of_resources"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn retain(context: cl_context) errors.opencl_error!void {
    const ret: i32 = opencl.clRetainContext(context);
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "out_of_host_memory", "invalid_context", "out_of_resources"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn release(context: cl_context) errors.opencl_error!void {
    const ret: i32 = opencl.clReleaseContext(context);
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "out_of_host_memory", "invalid_context", "out_of_resources"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}
