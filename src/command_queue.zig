const std = @import("std");

const cl = @import("cl.zig");
const opencl = cl.opencl;

const errors = @import("errors.zig");
pub const OpenCLError = errors.OpenCLError;

pub const Property = struct {
    pub const out_of_order_exec_mode_enable = opencl.CL_QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE;
    pub const profiling_enable = opencl.CL_QUEUE_PROFILING_ENABLE;
};
pub const Properties = opencl.cl_command_queue_properties;

pub const QueueProperty = struct {
    pub const properties = opencl.CL_QUEUE_PROPERTIES;
    pub const size = opencl.CL_QUEUE_SIZE;
};
pub const QueueProperties = opencl.cl_queue_properties;

pub const CommandQueue = *opaque {};

const cl_context = @import("context.zig").cl_context;
const cl_device_id = @import("device.zig").cl_device_id;

pub fn create_with_properties(
    context: cl_context,
    device: cl_device_id,
    properties: ?[]const QueueProperties,
) OpenCLError!CommandQueue {
    if (cl.opencl_version < 200) unreachable;

    var properties_ptr: ?[*]const QueueProperties = null;
    if (properties) |v| {
        properties_ptr = v.ptr;
    }

    var ret: i32 = undefined;
    const command_queue: ?CommandQueue = @ptrCast(opencl.clCreateCommandQueueWithProperties(
        @ptrCast(context),
        @ptrCast(device),
        properties_ptr,
        &ret,
    ));
    if (ret == opencl.CL_SUCCESS) return command_queue.?;

    const errors_arr = .{
        "invalid_value",    "invalid_context",
        "invalid_device",   "invalid_queue_properties",
        "out_of_resources", "out_of_host_memory",
    };
    return errors.translateOpenCLError(errors_arr, ret);
}

pub fn create(
    context: cl_context,
    device: cl_device_id,
    properties: Properties,
) OpenCLError!CommandQueue {
    var ret: i32 = undefined;
    const command_queue: ?CommandQueue = @ptrCast(opencl.clCreateCommandQueue(
        @ptrCast(context),
        @ptrCast(device),
        properties,
        &ret,
    ));
    if (ret == opencl.CL_SUCCESS) return command_queue.?;

    const errors_arr = .{
        "invalid_value",    "invalid_context",
        "invalid_device",   "invalid_queue_properties",
        "out_of_resources", "out_of_host_memory",
    };
    return errors.translateOpenCLError(errors_arr, ret);
}

pub fn flush(command_queue: CommandQueue) OpenCLError!void {
    const ret: i32 = opencl.clFlush(@ptrCast(command_queue));
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "out_of_host_memory", "invalid_command_queue", "out_of_resources",
    };
    return errors.translateOpenCLError(errors_arr, ret);
}

pub fn finish(command_queue: CommandQueue) OpenCLError!void {
    const ret: i32 = opencl.clFinish(@ptrCast(command_queue));
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "out_of_host_memory", "invalid_command_queue", "out_of_resources",
    };
    return errors.translateOpenCLError(errors_arr, ret);
}

pub fn retain(command_queue: CommandQueue) OpenCLError!void {
    const ret: i32 = opencl.clRetainCommandQueue(@ptrCast(command_queue));
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "out_of_host_memory", "invalid_command_queue", "out_of_resources",
    };
    return errors.translateOpenCLError(errors_arr, ret);
}

pub fn release(command_queue: CommandQueue) void {
    const ret: i32 = opencl.clReleaseCommandQueue(@ptrCast(command_queue));
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "out_of_host_memory", "invalid_command_queue", "out_of_resources",
    };
    std.debug.panic(
        "Unexpected error while releasing OpenCL command queue: {s}",
        .{@errorName(errors.translateOpenCLError(errors_arr, ret))},
    );
}
