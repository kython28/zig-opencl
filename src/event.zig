const cl = @import("cl.zig");
const opencl = cl.opencl;

const errors = @import("errors.zig");
pub const enums = @import("enums/event.zig");

pub const cl_event = opencl.cl_event;
const cl_context = opencl.cl_context;

pub const pfn_notify_callback = fn (event: cl_event, event_command_status: i32, user_data: ?*anyopaque) callconv(.C) void;

pub fn create_user_event(context: cl_context) errors.opencl_error!cl_event {
    var ret: i32 = undefined;
    const event: ?cl_event = opencl.clCreateUserEvent(context, &ret);
    if (ret == opencl.CL_SUCCESS) return event.?;

    const errors_arr = .{
        "invalid_context", "out_of_resources", "out_of_host_memory"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn set_user_event_status(event: cl_event, status: enums.execution_status) errors.opencl_error!void {
    const ret: i32 = opencl.clSetUserEventStatus(event, @intFromEnum(status));
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "invalid_event", "invalid_value", "invalid_operation",
        "out_of_resources", "out_of_host_memory"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn set_callback(
    event: cl_event, command_exec_callback_type: enums.execution_status,
    callback: ?*const pfn_notify_callback, user_data: ?*anyopaque
) errors.opencl_error!void {
    const ret: i32 = opencl.clSetEventCallback(
        event, @intFromEnum(command_exec_callback_type), callback, user_data
    );
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "invalid_event", "invalid_value", "out_of_host_memory",
        "out_of_resources"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

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

pub fn wait_for_many(events: []const cl_event) errors.opencl_error!void {
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
