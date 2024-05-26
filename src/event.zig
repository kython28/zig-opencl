const cl = @import("cl.zig");
const opencl = cl.opencl;

const errors = @import("errors.zig");

pub const cl_event = opencl.cl_event;


pub fn wait(event: cl_event) errors.opencl_error!void {
    const ret: i32 = opencl.clWaitForEvents(1, &event);
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "invalid_value", "invalid_context", "invalid_event",
        "exec_status_error_for_events_in_wait_list", "out_of_resources",
        "out_of_host_memory"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn wait_for_many(events: []cl_event) errors.opencl_error!void {
    const ret: i32 = opencl.clWaitForEvents(@intCast(events.len), events.ptr);
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "invalid_value", "invalid_context", "invalid_event",
        "exec_status_error_for_events_in_wait_list", "out_of_resources",
        "out_of_host_memory"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn retain(event: cl_event) errors.opencl_error!void {
    const ret: i32 = opencl.clRetainEvent(event);
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "out_of_host_memory", "invalid_event", "out_of_resources"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn release(event: cl_event) errors.opencl_error!void {
    const ret: i32 = opencl.clReleaseEvent(event);
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "out_of_host_memory", "invalid_event", "out_of_resources"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}
