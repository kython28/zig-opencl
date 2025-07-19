const cl = @import("cl.zig");
const opencl = cl.opencl;

const std = @import("std");

const errors = @import("errors.zig");
pub const OpenCLError = errors.OpenCLError;

const CommandQueue = @import("command_queue.zig").CommandQueue;
const Context = @import("context.zig").Context;
const Event = @import("event.zig").Event;

pub const Region = extern struct {
    origin: usize,
    size: usize,
};

pub const MapFlag = struct {
    pub const read = opencl.CL_MAP_READ;
    pub const write = opencl.CL_MAP_WRITE;
    pub const write_invalidate_region = opencl.CL_MAP_WRITE_INVALIDATE_REGION;
};
pub const MapFlags = opencl.cl_map_flags;

pub const MemFlag = struct {
    pub const read_write = opencl.CL_MEM_READ_WRITE;
    pub const write_only = opencl.CL_MEM_WRITE_ONLY;
    pub const read_only = opencl.CL_MEM_READ_ONLY;
    pub const use_host_ptr = opencl.CL_MEM_USE_HOST_PTR;
    pub const alloc_host_ptr = opencl.CL_MEM_ALLOC_HOST_PTR;
    pub const copy_host_ptr = opencl.CL_MEM_COPY_HOST_PTR;
    pub const host_write_only = opencl.CL_MEM_HOST_WRITE_ONLY;
    pub const host_read_only = opencl.CL_MEM_HOST_READ_ONLY;
    pub const host_no_access = opencl.CL_MEM_HOST_NO_ACCESS;
    pub const svm_fine_grain_buffer = opencl.CL_MEM_SVM_FINE_GRAIN_BUFFER;
    pub const svm_atomics = opencl.CL_MEM_SVM_ATOMICS;
    pub const kernel_read_and_write = opencl.CL_MEM_KERNEL_READ_AND_WRITE;
};
pub const MemFlags = opencl.cl_mem_flags;

pub const CreateTypes = struct {
    pub const region = opencl.CL_BUFFER_CREATE_TYPE_REGION;
};
pub const CreateType = opencl.cl_buffer_create_type;

pub const Mem = *opaque {};

pub fn create(
    context: Context,
    flags: MemFlags,
    size: usize,
    host_ptr: ?*anyopaque,
) OpenCLError!Mem {
    var ret: i32 = undefined;
    const mem: ?Mem = @ptrCast(opencl.clCreateBuffer(
        @ptrCast(context),
        flags,
        size,
        host_ptr,
        &ret,
    ));
    if (ret == opencl.CL_SUCCESS) return mem.?;

    const errors_arr = .{
        "invalid_context",               "invalid_value",
        "invalid_buffer_size",           "invalid_host_ptr",
        "mem_object_allocation_failure", "out_of_resources",
        "out_of_host_memory",
    };
    return errors.translateOpenCLError(errors_arr, ret);
}

pub fn createSubBuffer(
    buffer: Mem,
    flags: MemFlags,
    buffer_create_type: CreateType,
    buffer_create_info: *anyopaque,
) OpenCLError!Mem {
    var ret: i32 = undefined;
    const mem: ?Mem = @ptrCast(opencl.clCreateSubBuffer(
        @ptrCast(buffer),
        flags,
        buffer_create_type,
        buffer_create_info,
        &ret,
    ));
    if (ret == opencl.CL_SUCCESS) return mem.?;

    const errors_arr = .{
        "invalid_mem_object",            "invalid_value",
        "mem_object_allocation_failure", "out_of_resources",
        "out_of_host_memory",            "invalid_buffer_size",
        "misaligned_sub_buffer_offset",
    };
    return errors.translateOpenCLError(errors_arr, ret);
}

pub fn read(
    command_queue: CommandQueue,
    buffer: Mem,
    blocking_read: bool,
    offset: usize,
    size: usize,
    ptr: *anyopaque,
    event_wait_list: ?[]const Event,
    event: ?*Event,
) OpenCLError!void {
    var event_wait_list_ptr: ?[*]const Event = null;
    var num_events: u32 = 0;
    if (event_wait_list) |v| {
        event_wait_list_ptr = v.ptr;
        num_events = @intCast(v.len);
    }

    const ret: i32 = opencl.clEnqueueReadBuffer(
        @ptrCast(command_queue),
        @ptrCast(buffer),
        @intFromBool(blocking_read),
        offset,
        size,
        ptr,
        num_events,
        @ptrCast(event_wait_list_ptr),
        @ptrCast(event),
    );
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "invalid_command_queue",                     "invalid_context",
        "invalid_mem_object",                        "invalid_value",
        "invalid_event_wait_list",                   "misaligned_sub_buffer_offset",
        "exec_status_error_for_events_in_wait_list", "mem_object_allocation_failure",
        "invalid_operation",                         "out_of_resources",
        "out_of_host_memory",
    };
    return errors.translateOpenCLError(errors_arr, ret);
}

pub fn write(
    command_queue: CommandQueue,
    buffer: Mem,
    blocking_write: bool,
    offset: usize,
    size: usize,
    ptr: *const anyopaque,
    event_wait_list: ?[]const Event,
    event: ?*Event,
) OpenCLError!void {
    var event_wait_list_ptr: ?[*]const Event = null;
    var num_events: u32 = 0;
    if (event_wait_list) |v| {
        event_wait_list_ptr = v.ptr;
        num_events = @intCast(v.len);
    }

    const ret: i32 = opencl.clEnqueueWriteBuffer(
        @ptrCast(command_queue),
        @ptrCast(buffer),
        @intFromBool(blocking_write),
        offset,
        size,
        ptr,
        num_events,
        @ptrCast(event_wait_list_ptr),
        @ptrCast(event),
    );
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "invalid_command_queue",                     "invalid_context",
        "invalid_mem_object",                        "invalid_value",
        "invalid_event_wait_list",                   "misaligned_sub_buffer_offset",
        "exec_status_error_for_events_in_wait_list", "mem_object_allocation_failure",
        "invalid_operation",                         "out_of_resources",
        "out_of_host_memory",
    };
    return errors.translateOpenCLError(errors_arr, ret);
}

pub fn writeRect(
    command_queue: CommandQueue,
    buffer: Mem,
    blocking_write: bool,
    buffer_origin: []const usize,
    host_origin: []const usize,
    region: []const usize,
    buffer_row_pitch: usize,
    buffer_slice_pitch: usize,
    host_row_pitch: usize,
    host_slice_pitch: usize,
    ptr: *const anyopaque,
    event_wait_list: ?[]const Event,
    event: ?*Event,
) OpenCLError!void {
    if (buffer_origin.len != 3 or host_origin.len != 3 or region.len != 3) {
        return OpenCLError.invalid_value;
    }

    var event_wait_list_ptr: ?[*]const Event = null;
    var num_events: u32 = 0;
    if (event_wait_list) |v| {
        event_wait_list_ptr = v.ptr;
        num_events = @intCast(v.len);
    }

    const ret: i32 = opencl.clEnqueueWriteBufferRect(
        @ptrCast(command_queue),
        @ptrCast(buffer),
        @intFromBool(blocking_write),
        buffer_origin.ptr,
        host_origin.ptr,
        region.ptr,
        buffer_row_pitch,
        buffer_slice_pitch,
        host_row_pitch,
        host_slice_pitch,
        ptr,
        num_events,
        @ptrCast(event_wait_list_ptr),
        @ptrCast(event),
    );
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "invalid_command_queue",                     "invalid_context",
        "invalid_mem_object",                        "invalid_value",
        "invalid_event_wait_list",                   "misaligned_sub_buffer_offset",
        "exec_status_error_for_events_in_wait_list", "mem_object_allocation_failure",
        "invalid_operation",                         "out_of_resources",
        "out_of_host_memory",
    };
    return errors.translateOpenCLError(errors_arr, ret);
}

pub fn readRect(
    command_queue: CommandQueue,
    buffer: Mem,
    blocking_read: bool,
    buffer_origin: []const usize,
    host_origin: []const usize,
    region: []const usize,
    buffer_row_pitch: usize,
    buffer_slice_pitch: usize,
    host_row_pitch: usize,
    host_slice_pitch: usize,
    ptr: *anyopaque,
    event_wait_list: ?[]const Event,
    event: ?*Event,
) OpenCLError!void {
    if (buffer_origin.len != 3 or host_origin.len != 3 or region.len != 3) {
        return OpenCLError.invalid_value;
    }

    var event_wait_list_ptr: ?[*]const Event = null;
    var num_events: u32 = 0;
    if (event_wait_list) |v| {
        event_wait_list_ptr = v.ptr;
        num_events = @intCast(v.len);
    }

    const ret: i32 = opencl.clEnqueueReadBufferRect(
        @ptrCast(command_queue),
        @ptrCast(buffer),
        @intFromBool(blocking_read),
        buffer_origin.ptr,
        host_origin.ptr,
        region.ptr,
        buffer_row_pitch,
        buffer_slice_pitch,
        host_row_pitch,
        host_slice_pitch,
        ptr,
        num_events,
        @ptrCast(event_wait_list_ptr),
        @ptrCast(event),
    );
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "invalid_command_queue",                     "invalid_context",
        "invalid_mem_object",                        "invalid_value",
        "invalid_event_wait_list",                   "misaligned_sub_buffer_offset",
        "exec_status_error_for_events_in_wait_list", "mem_object_allocation_failure",
        "invalid_operation",                         "out_of_resources",
        "out_of_host_memory",
    };
    return errors.translateOpenCLError(errors_arr, ret);
}

pub fn fill(
    command_queue: CommandQueue,
    buffer: Mem,
    pattern: *const anyopaque,
    pattern_size: usize,
    offset: usize,
    size: usize,
    event_wait_list: ?[]const Event,
    event: ?*Event,
) OpenCLError!void {
    var event_wait_list_ptr: ?[*]const Event = null;
    var num_events: u32 = 0;
    if (event_wait_list) |v| {
        event_wait_list_ptr = v.ptr;
        num_events = @intCast(v.len);
    }

    const ret: i32 = opencl.clEnqueueFillBuffer(
        @ptrCast(command_queue),
        @ptrCast(buffer),
        pattern,
        pattern_size,
        offset,
        size,
        num_events,
        @ptrCast(event_wait_list_ptr),
        @ptrCast(event),
    );
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "invalid_command_queue",         "invalid_context",
        "invalid_mem_object",            "invalid_value",
        "invalid_event_wait_list",       "misaligned_sub_buffer_offset",
        "mem_object_allocation_failure", "out_of_resources",
        "out_of_host_memory",
    };
    return errors.translateOpenCLError(errors_arr, ret);
}

pub fn copy(
    command_queue: CommandQueue,
    src_buffer: Mem,
    dst_buffer: Mem,
    src_offset: usize,
    dst_offset: usize,
    size: usize,
    event_wait_list: ?[]const Event,
    event: ?*Event,
) OpenCLError!void {
    var event_wait_list_ptr: ?[*]const Event = null;
    var num_events: u32 = 0;
    if (event_wait_list) |v| {
        event_wait_list_ptr = v.ptr;
        num_events = @intCast(v.len);
    }

    const ret: i32 = opencl.clEnqueueCopyBuffer(
        @ptrCast(command_queue),
        @ptrCast(src_buffer),
        @ptrCast(dst_buffer),
        src_offset,
        dst_offset,
        size,
        num_events,
        @ptrCast(event_wait_list_ptr),
        @ptrCast(event),
    );
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "invalid_mem_object",      "invalid_value",
        "invalid_event_wait_list", "misaligned_sub_buffer_offset",
        "mem_copy_overlap",        "mem_object_allocation_failure",
        "out_of_resources",        "out_of_host_memory",
        "invalid_command_queue",   "invalid_context",
    };
    return errors.translateOpenCLError(errors_arr, ret);
}

pub fn copyRect(
    command_queue: CommandQueue,
    src_buffer: Mem,
    dst_buffer: Mem,
    src_origin: []const usize,
    dst_origin: []const usize,
    region: []const usize,
    src_row_pitch: usize,
    src_slice_pitch: usize,
    dst_row_pitch: usize,
    dst_slice_pitch: usize,
    event_wait_list: ?[]const Event,
    event: ?*Event,
) OpenCLError!void {
    if (src_origin.len != 3 or dst_origin.len != 3 or region.len != 3) {
        return OpenCLError.invalid_value;
    }

    var event_wait_list_ptr: ?[*]const Event = null;
    var num_events: u32 = 0;
    if (event_wait_list) |v| {
        event_wait_list_ptr = v.ptr;
        num_events = @intCast(v.len);
    }

    const ret: i32 = opencl.clEnqueueCopyBufferRect(
        @ptrCast(command_queue),
        @ptrCast(src_buffer),
        @ptrCast(dst_buffer),
        src_origin.ptr,
        dst_origin.ptr,
        region.ptr,
        src_row_pitch,
        src_slice_pitch,
        dst_row_pitch,
        dst_slice_pitch,
        num_events,
        @ptrCast(event_wait_list_ptr),
        @ptrCast(event),
    );
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "invalid_command_queue",        "invalid_context",
        "invalid_mem_object",           "invalid_value",
        "invalid_event_wait_list",      "mem_copy_overlap",
        "misaligned_sub_buffer_offset", "mem_object_allocation_failure",
        "out_of_resources",             "out_of_host_memory",
    };
    return errors.translateOpenCLError(errors_arr, ret);
}

pub fn map(
    comptime T: type,
    command_queue: CommandQueue,
    buffer: Mem,
    blocking_map: bool,
    map_flags: MapFlags,
    offset: usize,
    size: usize,
    event_wait_list: ?[]const Event,
    event: ?*Event,
) OpenCLError!T {
    const type_info = @typeInfo(T);
    if (type_info != .pointer) {
        @compileError("Only pointers are accepted");
    }

    const ptr_child = type_info.pointer.child;
    if (@mod(size, @sizeOf(ptr_child)) != 0) {
        return OpenCLError.invalid_value;
    }

    var event_wait_list_ptr: ?[*]const Event = null;
    var num_events: u32 = 0;
    if (event_wait_list) |v| {
        event_wait_list_ptr = v.ptr;
        num_events = @intCast(v.len);
    }

    var ret: i32 = undefined;
    const ptr: ?*anyopaque = opencl.clEnqueueMapBuffer(
        @ptrCast(command_queue),
        @ptrCast(buffer),
        @intFromBool(blocking_map),
        map_flags,
        offset,
        size,
        num_events,
        @ptrCast(event_wait_list_ptr),
        @ptrCast(event),
        &ret,
    );
    if (ret != opencl.CL_SUCCESS) {
        const errors_arr = .{
            "invalid_command_queue",        "invalid_context",
            "invalid_mem_object",           "invalid_value",
            "invalid_event_wait_list",      "mem_copy_overlap",
            "misaligned_sub_buffer_offset", "mem_object_allocation_failure",
            "out_of_resources",             "out_of_host_memory",
        };
        return errors.translateOpenCLError(errors_arr, ret);
    }

    return switch (type_info.pointer.size) {
        .slice => blk: {
            const type_ptr = type_info.pointer;
            const many_ptr_type = @Type(std.builtin.Type{
                .pointer = .{
                    .child = type_ptr.child,
                    .size = .many,
                    .is_const = type_ptr.is_const,
                    .sentinel_ptr = type_ptr.sentinel_ptr,
                    .alignment = type_ptr.alignment,
                    .is_volatile = type_ptr.is_volatile,
                    .is_allowzero = type_ptr.is_allowzero,
                    .address_space = type_ptr.address_space,
                },
            });
            const new_ptr: many_ptr_type = @ptrCast(@alignCast(ptr.?));
            break :blk new_ptr[0..(size / @sizeOf(ptr_child))];
        },
        else => @ptrCast(@alignCast(ptr.?)),
    };
}

pub fn unmap(
    comptime T: type,
    command_queue: CommandQueue,
    buffer: Mem,
    mapped_ptr: T,
    event_wait_list: ?[]const Event,
    event: ?*Event,
) OpenCLError!void {
    const type_info = @typeInfo(T);
    if (type_info != .pointer) {
        @compileError("Only pointers are accepted");
    }

    var event_wait_list_ptr: ?[*]const Event = null;
    var num_events: u32 = 0;
    if (event_wait_list) |v| {
        event_wait_list_ptr = v.ptr;
        num_events = @intCast(v.len);
    }

    const ptr = switch (type_info.pointer.size) {
        .slice => mapped_ptr.ptr,
        else => mapped_ptr,
    };

    const ret: i32 = opencl.clEnqueueUnmapMemObject(
        @ptrCast(command_queue),
        @ptrCast(buffer),
        ptr,
        num_events,
        @ptrCast(event_wait_list_ptr),
        @ptrCast(event),
    );
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "invalid_command_queue", "invalid_mem_object",
        "invalid_value",         "invalid_event_wait_list",
        "out_of_resources",      "out_of_host_memory",
    };
    return errors.translateOpenCLError(errors_arr, ret);
}

pub fn retain(buffer: Mem) OpenCLError!void {
    const ret: i32 = opencl.clRetainMemObject(@ptrCast(buffer));
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "out_of_host_memory", "invalid_mem_object", "out_of_resources",
    };
    return errors.translateOpenCLError(errors_arr, ret);
}

pub fn release(buffer: Mem) void {
    const ret: i32 = opencl.clReleaseMemObject(@ptrCast(buffer));
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "out_of_host_memory", "invalid_mem_object", "out_of_resources",
    };
    std.debug.panic(
        "Unexpected error while releasing OpenCL buffer: {s}",
        .{@errorName(errors.translateOpenCLError(errors_arr, ret))},
    );
}
