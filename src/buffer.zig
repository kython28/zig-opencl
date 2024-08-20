const cl = @import("cl.zig");
const opencl = cl.opencl;

const std = @import("std");

pub const enums = @import("enums/buffer.zig");
const errors = @import("errors.zig");

pub const cl_buffer_create_type = opencl.cl_buffer_create_type;
pub const cl_map_flags = opencl.cl_map_flags;
pub const cl_mem_flags = opencl.cl_mem_flags;
pub const cl_mem = *opaque {};

const cl_command_queue = @import("command_queue.zig").cl_command_queue;
const cl_context = @import("context.zig").cl_context;
const cl_event = @import("event.zig").cl_event;

pub const cl_buffer_region = extern struct {
    origin: usize,
    size: usize
};

pub fn create(
    context: cl_context,
    flags: cl_mem_flags,
    size: usize,
    host_ptr: ?*anyopaque
) errors.opencl_error!cl_mem {
    var ret: i32 = undefined;
    const mem: ?cl_mem = @ptrCast(opencl.clCreateBuffer(
        @ptrCast(context), flags, size, host_ptr, &ret
    ));
    if (ret == opencl.CL_SUCCESS) return mem.?;

    const errors_arr = .{
        "invalid_context", "invalid_value", "invalid_buffer_size",
        "invalid_host_ptr", "mem_object_allocation_failure", "out_of_resources",
        "out_of_host_memory"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn create_sub_buffer(
    buffer: cl_mem,
    flags: cl_mem_flags,
    buffer_create_type: enums.buffer_create_type,
    buffer_create_info: *anyopaque
) errors.opencl_error!cl_mem {
    var ret: i32 = undefined;
    const mem: ?cl_mem = @ptrCast(opencl.clCreateSubBuffer(
        @ptrCast(buffer), flags, @intFromEnum(buffer_create_type), buffer_create_info, &ret
    ));
    if (ret == opencl.CL_SUCCESS) return mem.?;

    const errors_arr = .{
        "invalid_mem_object", "invalid_value", "mem_object_allocation_failure",
        "out_of_resources", "out_of_host_memory", "invalid_buffer_size",
        "misaligned_sub_buffer_offset"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn read(
    command_queue: cl_command_queue, buffer: cl_mem, blocking_read: bool,
    offset: usize, size: usize, ptr: *anyopaque, event_wait_list: ?[]const cl_event,
    event: ?*cl_event
) errors.opencl_error!void {
    var event_wait_list_ptr: ?[*]const cl_event = null;
    var num_events: u32 = 0;
    if (event_wait_list) |v| {
        event_wait_list_ptr = v.ptr;
        num_events = @intCast(v.len);
    }

    const ret: i32 = opencl.clEnqueueReadBuffer(
        @ptrCast(command_queue), @ptrCast(buffer), @intFromBool(blocking_read),
        offset, size, ptr, num_events, @ptrCast(event_wait_list_ptr), @ptrCast(event)
    );
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "invalid_command_queue", "invalid_context", "invalid_mem_object", "invalid_value",
        "invalid_event_wait_list", "misaligned_sub_buffer_offset",
        "exec_status_error_for_events_in_wait_list", "mem_object_allocation_failure",
        "invalid_operation", "out_of_resources", "out_of_host_memory"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn write(
    command_queue: cl_command_queue, buffer: cl_mem, blocking_write: bool,
    offset: usize, size: usize, ptr: *const anyopaque, event_wait_list: ?[]const cl_event,
    event: ?*cl_event
) errors.opencl_error!void {
    var event_wait_list_ptr: ?[*]const cl_event = null;
    var num_events: u32 = 0;
    if (event_wait_list) |v| {
        event_wait_list_ptr = v.ptr;
        num_events = @intCast(v.len);
    }

    const ret: i32 = opencl.clEnqueueWriteBuffer(
        @ptrCast(command_queue), @ptrCast(buffer), @intFromBool(blocking_write), offset, size, ptr, num_events,
        @ptrCast(event_wait_list_ptr), @ptrCast(event)
    );
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "invalid_command_queue", "invalid_context", "invalid_mem_object", "invalid_value",
        "invalid_event_wait_list", "misaligned_sub_buffer_offset",
        "exec_status_error_for_events_in_wait_list", "mem_object_allocation_failure",
        "invalid_operation", "out_of_resources", "out_of_host_memory"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn write_rect(
    command_queue: cl_command_queue, buffer: cl_mem, blocking_write: bool,
    buffer_origin: []const usize, host_origin: []const usize, region: []const usize,
    buffer_row_pitch: usize, buffer_slice_pitch: usize, host_row_pitch: usize,
    host_slice_pitch: usize, ptr: *const anyopaque, event_wait_list: ?[]const cl_event,
    event: ?*cl_event
) errors.opencl_error!void {
    if (buffer_origin.len != 3 or host_origin.len != 3 or region.len != 3){
        return errors.opencl_error.invalid_value;
    }

    var event_wait_list_ptr: ?[*]const cl_event = null;
    var num_events: u32 = 0;
    if (event_wait_list) |v| {
        event_wait_list_ptr = v.ptr;
        num_events = @intCast(v.len);
    }

    const ret: i32 = opencl.clEnqueueWriteBufferRect(
        @ptrCast(command_queue), @ptrCast(buffer), @intFromBool(blocking_write),
        buffer_origin.ptr, host_origin.ptr, region.ptr, buffer_row_pitch, buffer_slice_pitch,
        host_row_pitch, host_slice_pitch, ptr, num_events, @ptrCast(event_wait_list_ptr), @ptrCast(event)
    );
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "invalid_command_queue", "invalid_context", "invalid_mem_object", "invalid_value",
        "invalid_event_wait_list", "misaligned_sub_buffer_offset",
        "exec_status_error_for_events_in_wait_list", "mem_object_allocation_failure",
        "invalid_operation", "out_of_resources", "out_of_host_memory"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn read_rect(
    command_queue: cl_command_queue, buffer: cl_mem, blocking_read: bool,
    buffer_origin: []const usize, host_origin: []const usize, region: []const usize,
    buffer_row_pitch: usize, buffer_slice_pitch: usize, host_row_pitch: usize,
    host_slice_pitch: usize, ptr: *anyopaque, event_wait_list: ?[]const cl_event,
    event: ?*cl_event
) errors.opencl_error!void {
    if (buffer_origin.len != 3 or host_origin.len != 3 or region.len != 3){
        return errors.opencl_error.invalid_value;
    }

    var event_wait_list_ptr: ?[*]const cl_event = null;
    var num_events: u32 = 0;
    if (event_wait_list) |v| {
        event_wait_list_ptr = v.ptr;
        num_events = @intCast(v.len);
    }

    const ret: i32 = opencl.clEnqueueReadBufferRect(
        @ptrCast(command_queue), @ptrCast(buffer), @intFromBool(blocking_read), buffer_origin.ptr,
        host_origin.ptr, region.ptr, buffer_row_pitch, buffer_slice_pitch, host_row_pitch, host_slice_pitch,
        ptr, num_events, @ptrCast(event_wait_list_ptr), @ptrCast(event)
    );
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "invalid_command_queue", "invalid_context", "invalid_mem_object", "invalid_value",
        "invalid_event_wait_list", "misaligned_sub_buffer_offset",
        "exec_status_error_for_events_in_wait_list", "mem_object_allocation_failure",
        "invalid_operation", "out_of_resources", "out_of_host_memory"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn fill(
    command_queue: cl_command_queue, buffer: cl_mem, pattern: *const anyopaque,
    pattern_size: usize, offset: usize, size: usize, event_wait_list: ?[]const cl_event,
    event: ?*cl_event
) errors.opencl_error!void {
    var event_wait_list_ptr: ?[*]const cl_event = null;
    var num_events: u32 = 0;
    if (event_wait_list) |v| {
        event_wait_list_ptr = v.ptr;
        num_events = @intCast(v.len);
    }

    const ret: i32 = opencl.clEnqueueFillBuffer(
        @ptrCast(command_queue), @ptrCast(buffer), pattern, pattern_size, offset, size, num_events,
        @ptrCast(event_wait_list_ptr), @ptrCast(event)
    );
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "invalid_command_queue", "invalid_context", "invalid_mem_object", "invalid_value",
        "invalid_event_wait_list", "misaligned_sub_buffer_offset", "mem_object_allocation_failure",
        "out_of_resources", "out_of_host_memory"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn copy(
    command_queue: cl_command_queue, src_buffer: cl_mem, dst_buffer: cl_mem,
    src_offset: usize, dst_offset: usize, size: usize, event_wait_list: ?[]const cl_event,
    event: ?*cl_event
) errors.opencl_error!void {
    var event_wait_list_ptr: ?[*]const cl_event = null;
    var num_events: u32 = 0;
    if (event_wait_list) |v| {
        event_wait_list_ptr = v.ptr;
        num_events = @intCast(v.len);
    }

    const ret: i32 = opencl.clEnqueueCopyBuffer(
        @ptrCast(command_queue), @ptrCast(src_buffer), @ptrCast(dst_buffer), src_offset,
        dst_offset, size, num_events, @ptrCast(event_wait_list_ptr), @ptrCast(event)
    );
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "invalid_mem_object", "invalid_value", "invalid_event_wait_list",
        "misaligned_sub_buffer_offset", "mem_copy_overlap", "mem_object_allocation_failure",
        "out_of_resources", "out_of_host_memory", "invalid_command_queue",
        "invalid_context"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn copy_rect(
    command_queue: cl_command_queue, src_buffer: cl_mem, dst_buffer: cl_mem,
    src_origin: []const usize, dst_origin: []const usize, region: []const usize,
    src_row_pitch: usize, src_slice_pitch: usize, dst_row_pitch: usize,
    dst_slice_pitch: usize, event_wait_list: ?[]const cl_event,
    event: ?*cl_event
) errors.opencl_error!void {
    if (src_origin.len != 3 or dst_origin.len != 3 or region.len != 3){
        return errors.opencl_error.invalid_value;
    }

    var event_wait_list_ptr: ?[*]const cl_event = null;
    var num_events: u32 = 0;
    if (event_wait_list) |v| {
        event_wait_list_ptr = v.ptr;
        num_events = @intCast(v.len);
    }

    const ret: i32 = opencl.clEnqueueCopyBufferRect(
        @ptrCast(command_queue), @ptrCast(src_buffer), @ptrCast(dst_buffer), src_origin.ptr,
        dst_origin.ptr, region.ptr, src_row_pitch, src_slice_pitch, dst_row_pitch, dst_slice_pitch,
        num_events, @ptrCast(event_wait_list_ptr), @ptrCast(event)
    );
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "invalid_command_queue", "invalid_context", "invalid_mem_object", "invalid_value",
        "invalid_event_wait_list", "mem_copy_overlap", "misaligned_sub_buffer_offset",
        "mem_object_allocation_failure", "out_of_resources", "out_of_host_memory"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn map(
    comptime T: type, command_queue: cl_command_queue, buffer: cl_mem, blocking_map: bool,
    map_flags: cl_map_flags, offset: usize, size: usize, event_wait_list: ?[]const cl_event,
    event: ?*cl_event
) errors.opencl_error!T {
    const type_info = @typeInfo(T);
    if (type_info != .Pointer) {
        @compileError("Only pointers are accepted");
    }

    const ptr_child = type_info.Pointer.child;
    if (@mod(size, @sizeOf(ptr_child)) != 0) {
        return errors.opencl_error.invalid_value;
    }

    var event_wait_list_ptr: ?[*]const cl_event = null;
    var num_events: u32 = 0;
    if (event_wait_list) |v| {
        event_wait_list_ptr = v.ptr;
        num_events = @intCast(v.len);
    }

    var ret: i32 = undefined;
    const ptr: ?*anyopaque = opencl.clEnqueueMapBuffer(
        @ptrCast(command_queue), @ptrCast(buffer), @intFromBool(blocking_map), map_flags, offset, size,
        num_events, @ptrCast(event_wait_list_ptr), @ptrCast(event), &ret
    );
    if (ret != opencl.CL_SUCCESS) {
        const errors_arr = .{
            "invalid_command_queue", "invalid_context", "invalid_mem_object", "invalid_value",
            "invalid_event_wait_list", "mem_copy_overlap", "misaligned_sub_buffer_offset",
            "mem_object_allocation_failure", "out_of_resources", "out_of_host_memory"
        };
        return errors.translate_opencl_error(errors_arr, ret);
    }

    return switch (type_info.Pointer.size) {
        .Slice => blk: {
            const type_ptr = type_info.Pointer;
            const many_ptr_type = @Type(std.builtin.Type{
                .Pointer = .{
                    .child = type_ptr.child,
                    .size = .Many,
                    .is_const = type_ptr.is_const,
                    .sentinel = type_ptr.sentinel,
                    .alignment = type_ptr.alignment,
                    .is_volatile = type_ptr.is_volatile,
                    .is_allowzero = type_ptr.is_allowzero,
                    .address_space = type_ptr.address_space,
                }
            });
            const new_ptr: many_ptr_type = @ptrCast(@alignCast(ptr.?));
            break :blk new_ptr[0..(size / @sizeOf(ptr_child))];
        },
        else => @ptrCast(@alignCast(ptr.?))
    };
}

pub fn unmap(
    comptime T: type, command_queue: cl_command_queue, buffer: cl_mem, mapped_ptr: T,
    event_wait_list: ?[]const cl_event, event: ?*cl_event
) errors.opencl_error!void {
    const type_info = @typeInfo(T);
    if (type_info != .Pointer) {
        @compileError("Only pointers are accepted");
    }

    var event_wait_list_ptr: ?[*]const cl_event = null;
    var num_events: u32 = 0;
    if (event_wait_list) |v| {
        event_wait_list_ptr = v.ptr;
        num_events = @intCast(v.len);
    }

    const ptr = switch(type_info.Pointer.size) {
        .Slice => mapped_ptr.ptr,
        else => mapped_ptr
    };

    const ret: i32 = opencl.clEnqueueUnmapMemObject(
        @ptrCast(command_queue), @ptrCast(buffer), ptr, num_events, @ptrCast(event_wait_list_ptr),
        @ptrCast(event)
    );
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "invalid_command_queue", "invalid_mem_object", "invalid_value", "invalid_event_wait_list",
        "out_of_resources", "out_of_host_memory"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn retain(buffer: cl_mem) errors.opencl_error!void {
    const ret: i32 = opencl.clRetainMemObject(@ptrCast(buffer));
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "out_of_host_memory", "invalid_mem_object", "out_of_resources"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn release(buffer: cl_mem) errors.opencl_error!void {
    const ret: i32 = opencl.clReleaseMemObject(@ptrCast(buffer));
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "out_of_host_memory", "invalid_mem_object", "out_of_resources"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}
