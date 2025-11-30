const std = @import("std");
const cl = @import("cl.zig");
const opencl = cl.opencl;

const errors = @import("errors.zig");
pub const OpenCLError = errors.OpenCLError;

pub const ExecutionStatus = enum(i32) {
    complete = opencl.CL_COMPLETE,
    running = opencl.CL_RUNNING,
    submitted = opencl.CL_SUBMITTED,
    queued = opencl.CL_QUEUED,
};

pub const Event = *opaque {};

const Context = @import("context.zig").Context;

pub const Callback = fn (
    event: Event,
    event_command_status: i32,
    user_data: ?*anyopaque,
) callconv(.c) void;

pub fn createUserEvent(context: Context) OpenCLError!Event {
    var ret: i32 = undefined;
    const event: ?Event = @ptrCast(opencl.clCreateUserEvent(@ptrCast(context), &ret));
    if (ret == opencl.CL_SUCCESS) return event.?;

    return errors.translateOpenCLError(ret);
}

pub fn setUserEventStatus(event: Event, status: ExecutionStatus) OpenCLError!void {
    const ret: i32 = opencl.clSetUserEventStatus(@ptrCast(event), @intFromEnum(status));
    if (ret == opencl.CL_SUCCESS) return;

    return errors.translateOpenCLError(ret);
}

pub fn setCallback(
    event: Event,
    command_exec_callback_type: ExecutionStatus,
    callback: ?*const Callback,
    user_data: ?*anyopaque,
) OpenCLError!void {
    const ret: i32 = opencl.clSetEventCallback(
        @ptrCast(event),
        @intFromEnum(command_exec_callback_type),
        @ptrCast(callback),
        user_data,
    );
    if (ret == opencl.CL_SUCCESS) return;

    return errors.translateOpenCLError(ret);
}

pub fn wait(event: Event) OpenCLError!void {
    const ret: i32 = opencl.clWaitForEvents(1, @ptrCast(&event));
    if (ret == opencl.CL_SUCCESS) return;

    return errors.translateOpenCLError(ret);
}

pub fn waitForMany(events: []const Event) OpenCLError!void {
    if (events.len == 0) return;

    const ret: i32 = opencl.clWaitForEvents(@intCast(events.len), @ptrCast(events.ptr));
    if (ret == opencl.CL_SUCCESS) return;

    return errors.translateOpenCLError(ret);
}

pub fn retain(event: Event) OpenCLError!void {
    const ret: i32 = opencl.clRetainEvent(@ptrCast(event));
    if (ret == opencl.CL_SUCCESS) return;

    return errors.translateOpenCLError(ret);
}

pub fn release(event: Event) void {
    const ret: i32 = opencl.clReleaseEvent(@ptrCast(event));
    if (ret == opencl.CL_SUCCESS) return;

    std.debug.panic(
        "Unexpected error while releasing OpenCL event: {s}",
        .{@errorName(errors.translateOpenCLError(ret))},
    );
}
