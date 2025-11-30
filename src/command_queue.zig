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

const Context = @import("context.zig").Context;
const DeviceId = @import("device.zig").DeviceId;

pub fn createWithProperties(
    context: Context,
    device: DeviceId,
    properties: ?[]const QueueProperties,
) OpenCLError!CommandQueue {
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

    return errors.translateOpenCLError(ret);
}

pub fn create(
    context: Context,
    device: DeviceId,
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

    return errors.translateOpenCLError(ret);
}

pub fn flush(command_queue: CommandQueue) OpenCLError!void {
    const ret: i32 = opencl.clFlush(@ptrCast(command_queue));
    if (ret == opencl.CL_SUCCESS) return;

    return errors.translateOpenCLError(ret);
}

pub fn finish(command_queue: CommandQueue) OpenCLError!void {
    const ret: i32 = opencl.clFinish(@ptrCast(command_queue));
    if (ret == opencl.CL_SUCCESS) return;

    return errors.translateOpenCLError(ret);
}

pub fn retain(command_queue: CommandQueue) OpenCLError!void {
    const ret: i32 = opencl.clRetainCommandQueue(@ptrCast(command_queue));
    if (ret == opencl.CL_SUCCESS) return;

    return errors.translateOpenCLError(ret);
}

pub fn release(command_queue: CommandQueue) void {
    const ret: i32 = opencl.clReleaseCommandQueue(@ptrCast(command_queue));
    if (ret == opencl.CL_SUCCESS) return;

    std.debug.panic(
        "Unexpected error while releasing OpenCL command queue: {s}",
        .{@errorName(errors.translateOpenCLError(ret))},
    );
}
