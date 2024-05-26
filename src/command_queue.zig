const cl = @import("cl.zig");
const opencl = cl.opencl;
const std = @import("std");

pub const enums = @import("enums/command_queue.zig");
const errors = @import("errors.zig");

pub const cl_command_queue_properties = opencl.cl_command_queue_properties;
pub const cl_queue_properties = opencl.cl_queue_properties; 
pub const cl_command_queue = opencl.cl_command_queue;

const cl_context = opencl.cl_context;
const cl_device_id = opencl.cl_device_id; 

pub fn create_with_properties(
    context: cl_context, device: cl_device_id,
    properties: ?[]const cl_queue_properties
) errors.opencl_error!cl_command_queue {
    if (cl.opencl_version < 200) unreachable; 

    var properties_ptr: ?[*]cl_queue_properties = null;
    if (properties) |v| {
        properties_ptr = v.ptr;
    }

    var ret: i32 = undefined;
    const command_queue: cl_command_queue = opencl.clCreateCommandQueueWithProperties(
        context, device, properties_ptr, &ret
    );
    if (ret == opencl.CL_SUCCESS) return command_queue;

    const errors_arr = .{
        "invalid_value", "invalid_context", "invalid_device", "invalid_queue_properties",
        "out_of_resources", "out_of_host_memory"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn create(
    context: cl_context, device: cl_device_id,
    properties: cl_command_queue_properties
) errors.opencl_error!cl_command_queue {
    var ret: i32 = undefined;
    const command_queue: cl_command_queue = opencl.clCreateCommandQueue(
        context, device, properties, &ret
    );
    if (ret == opencl.CL_SUCCESS) return command_queue;

    const errors_arr = .{
        "invalid_value", "invalid_context", "invalid_device", "invalid_queue_properties",
        "out_of_resources", "out_of_host_memory"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn flush(command_queue: cl_command_queue) errors.opencl_error!void {
    const ret: i32 = opencl.clFlush(command_queue);
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "out_of_host_memory", "invalid_command_queue", "out_of_resources"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn finish(command_queue: cl_command_queue) errors.opencl_error!void {
    const ret: i32 = opencl.clFinish(command_queue);
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "out_of_host_memory", "invalid_command_queue", "out_of_resources"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn retain(command_queue: cl_command_queue) errors.opencl_error!void {
    const ret: i32 = opencl.clRetainCommandQueue(command_queue);
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "out_of_host_memory", "invalid_command_queue", "out_of_resources"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn release(command_queue: cl_command_queue) errors.opencl_error!void {
    const ret: i32 = opencl.clReleaseCommandQueue(command_queue);
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "out_of_host_memory", "invalid_command_queue", "out_of_resources"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}
