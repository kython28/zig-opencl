const cl = @import("cl.zig");
const opencl = cl.opencl;
const std = @import("std");

const errors = @import("errors.zig");
pub const OpenCLError = errors.OpenCLError;

pub const Property = struct {
    pub const platform = opencl.CL_CONTEXT_PLATFORM;
    pub const interop_user_sync = opencl.CL_CONTEXT_INTEROP_USER_SYNC;
};
pub const Properties = opencl.cl_context_properties;

pub const Info = enum(u32) {
    reference_count = opencl.CL_CONTEXT_REFERENCE_COUNT,
    devices = opencl.CL_CONTEXT_DEVICES,
    properties = opencl.CL_CONTEXT_PROPERTIES,
    num_devices = opencl.CL_CONTEXT_NUM_DEVICES,
};

pub const Context = *opaque {};

pub const Callback = fn (
    errinfo: [*c]const u8,
    private_info: ?*const anyopaque,
    cb: usize,
    user_data: ?*anyopaque,
) callconv(.C) void;

const device = @import("device.zig");
const DeviceId = device.DeviceId;

pub fn create(
    properties: ?[]const Properties,
    devices: []const DeviceId,
    pfn_notify: ?*const Callback,
    user_data: ?*anyopaque,
) OpenCLError!Context {
    var properties_ptr: ?[*]const Properties = null;
    if (properties) |v| {
        properties_ptr = v.ptr;
    }

    var ret: i32 = undefined;
    const context: ?Context = @ptrCast(opencl.clCreateContext(
        properties_ptr,
        @intCast(devices.len),
        @ptrCast(devices.ptr),
        pfn_notify,
        user_data,
        &ret,
    ));
    if (ret == opencl.CL_SUCCESS) return context.?;

    const errors_arr = .{
        "invalid_value",    "out_of_host_memory",
        "invalid_platform", "device_not_available",
        "out_of_resources", "invalid_property",
    };
    return errors.translateOpenCLError(errors_arr, ret);
}

pub fn createFromType(
    properties: ?[]const Properties,
    device_type: device.Type,
    pfn_notify: ?*const Callback,
    user_data: ?*anyopaque,
) OpenCLError!Context {
    var properties_ptr: ?[*]const Properties = null;
    if (properties) |v| {
        properties_ptr = v.ptr;
    }

    var ret: i32 = undefined;
    const context: ?Context = @ptrCast(opencl.clCreateContextFromType(
        properties_ptr,
        @intFromEnum(device_type),
        pfn_notify,
        user_data,
        &ret,
    ));
    if (ret == opencl.CL_SUCCESS) return context.?;

    const errors_arr = .{
        "invalid_value",    "out_of_host_memory",  "invalid_platform", "device_not_available",
        "out_of_resources", "invalid_device_type", "device_not_found",
    };
    return errors.translateOpenCLError(errors_arr, ret);
}

pub fn getInfo(
    context: Context,
    param_name: Info,
    param_value_size: usize,
    param_value: ?*anyopaque,
    param_value_size_ret: ?*usize,
) OpenCLError!void {
    const ret: i32 = opencl.clGetContextInfo(
        @ptrCast(context),
        @intFromEnum(param_name),
        param_value_size,
        param_value,
        param_value_size_ret,
    );
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "invalid_value",   "out_of_host_memory",
        "invalid_context", "out_of_resources",
    };
    return errors.translateOpenCLError(errors_arr, ret);
}

pub fn retain(context: Context) OpenCLError!void {
    const ret: i32 = opencl.clRetainContext(@ptrCast(context));
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{ "out_of_host_memory", "invalid_context", "out_of_resources" };
    return errors.translateOpenCLError(errors_arr, ret);
}

pub fn release(context: Context) void {
    const ret: i32 = opencl.clReleaseContext(@ptrCast(context));
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{ "out_of_host_memory", "invalid_context", "out_of_resources" };
    std.debug.panic(
        "Unexpected error while releasing OpenCL context: {s}",
        .{@errorName(errors.translateOpenCLError(errors_arr, ret))},
    );
}
