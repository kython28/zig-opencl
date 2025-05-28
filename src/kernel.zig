const std = @import("std");
const cl = @import("cl.zig");
const opencl = cl.opencl;

const errors = @import("errors.zig");
pub const OpenCLError = errors.OpenCLError;

pub const Kernel = *opaque {};
const cl_program = @import("program.zig").Program;
const CommandQueue = @import("command_queue.zig").CommandQueue;
const Event = @import("event.zig").Event;

pub fn create(program: cl_program, kernel_name: []const u8) OpenCLError!Kernel {
    var ret: i32 = undefined;
    const kernel: ?Kernel = @ptrCast(opencl.clCreateKernel(
        @ptrCast(program),
        kernel_name.ptr,
        &ret,
    ));
    if (ret == opencl.CL_SUCCESS) return kernel.?;

    const errors_arr = .{
        "invalid_program",     "invalid_program_executable",
        "invalid_kernel_name", "invalid_kernel_definition",
        "invalid_value",       "out_of_resources",
        "out_of_host_memory",
    };
    return errors.translateOpenCLError(errors_arr, ret);
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

    const errors_arr = .{
        "invalid_kernel",     "invalid_arg_index",
        "invalid_arg_value",  "invalid_mem_object",
        "invalid_sampler",    "invalid_device_queue",
        "invalid_arg_size",   "max_size_restriction_exceeded",
        "invalid_arg_value",  "out_of_resources",
        "out_of_host_memory",
    };
    return errors.translateOpenCLError(errors_arr, ret);
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
            return OpenCLError.invalid_global_offset;
        }
        global_work_offset_ptr = v.ptr;
    }
    if (local_work_size) |v| {
        if (v.len != work_dim) {
            return OpenCLError.invalid_work_item_size;
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

    const errors_arr = .{
        "invalid_program_executable",    "invalid_command_queue",
        "invalid_kernel",                "invalid_context",
        "invalid_kernel_args",           "invalid_work_dimension",
        "invalid_global_work_size",      "invalid_global_offset",
        "invalid_work_group_size",       "invalid_work_item_size",
        "misaligned_sub_buffer_offset",  "invalid_image_size",
        "image_format_not_supported",    "out_of_resources",
        "mem_object_allocation_failure", "invalid_event_wait_list",
        "invalid_operation",             "out_of_host_memory",
    };
    return errors.translateOpenCLError(errors_arr, ret);
}

pub fn retain(kernel: Kernel) OpenCLError!void {
    const ret: i32 = opencl.clRetainKernel(@ptrCast(kernel));
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{ "out_of_host_memory", "invalid_kernel", "out_of_resources" };
    return errors.translateOpenCLError(errors_arr, ret);
}

pub fn release(kernel: Kernel) void {
    const ret: i32 = opencl.clReleaseKernel(@ptrCast(kernel));
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{ "out_of_host_memory", "invalid_kernel", "out_of_resources" };
    std.debug.panic(
        "Unexpected error while releasing OpenCL kernel: {s}",
        .{@errorName(errors.translateOpenCLError(errors_arr, ret))},
    );
}
