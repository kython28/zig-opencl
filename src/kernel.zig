const std = @import("std");
const cl = @import("cl.zig");
const opencl = cl.opencl;

const errors = @import("errors.zig");
pub const OpenCLError = errors.OpenCLError;

pub const Kernel = *opaque {};
const Program = @import("program.zig").Program;
const CommandQueue = @import("command_queue.zig").CommandQueue;
const Event = @import("event.zig").Event;

pub fn create(program: Program, kernel_name: []const u8) OpenCLError!Kernel {
    var ret: i32 = undefined;
    const kernel: ?Kernel = @ptrCast(opencl.clCreateKernel(
        @ptrCast(program),
        kernel_name.ptr,
        &ret,
    ));
    if (ret == opencl.CL_SUCCESS) return kernel.?;

    return errors.translateOpenCLError(ret);
}

pub fn setArg(
    kernel: Kernel,
    arg_index: u32,
    arg_size: usize,
    arg_value: ?*const anyopaque,
) OpenCLError!void {
    const ret: i32 = opencl.clSetKernelArg(
        @ptrCast(kernel),
        arg_index,
        arg_size,
        arg_value,
    );
    if (ret == opencl.CL_SUCCESS) return;

    return errors.translateOpenCLError(ret);
}

pub fn enqueueNdRange(
    command_queue: CommandQueue,
    kernel: Kernel,
    global_work_offset: ?[]const usize,
    global_work_size: []const usize,
    local_work_size: ?[]const usize,
    event_wait_list: ?[]const Event,
    event: ?*Event,
) OpenCLError!void {
    const work_dim: u32 = @intCast(global_work_size.len);
    const global_work_size_ptr: [*]const usize = global_work_size.ptr;
    var global_work_offset_ptr: ?[*]const usize = null;
    var local_work_size_ptr: ?[*]const usize = null;
    if (global_work_offset) |v| {
        if (v.len != work_dim) {
            return OpenCLError.InvalidGlobalOffset;
        }
        global_work_offset_ptr = v.ptr;
    }
    if (local_work_size) |v| {
        if (v.len != work_dim) {
            return OpenCLError.InvalidWorkItemSize;
        }
        local_work_size_ptr = v.ptr;
    }

    var event_wait_list_ptr: ?[*]const Event = null;
    var num_events: u32 = 0;
    if (event_wait_list) |v| {
        event_wait_list_ptr = v.ptr;
        num_events = @intCast(v.len);
    }

    const ret: i32 = opencl.clEnqueueNDRangeKernel(
        @ptrCast(command_queue),
        @ptrCast(kernel),
        work_dim,
        global_work_offset_ptr,
        global_work_size_ptr,
        local_work_size_ptr,
        num_events,
        @ptrCast(event_wait_list_ptr),
        @ptrCast(event),
    );
    if (ret == opencl.CL_SUCCESS) return;

    return errors.translateOpenCLError(ret);
}

pub fn retain(kernel: Kernel) OpenCLError!void {
    const ret: i32 = opencl.clRetainKernel(@ptrCast(kernel));
    if (ret == opencl.CL_SUCCESS) return;

    return errors.translateOpenCLError(ret);
}

pub fn release(kernel: Kernel) void {
    const ret: i32 = opencl.clReleaseKernel(@ptrCast(kernel));
    if (ret == opencl.CL_SUCCESS) return;

    std.debug.panic(
        "Unexpected error while releasing OpenCL kernel: {s}",
        .{@errorName(errors.translateOpenCLError(ret))},
    );
}
