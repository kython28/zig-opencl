const cl = @import("cl.zig");
const opencl = cl.opencl;
const std = @import("std");

const errors = @import("errors.zig");
pub const enums = @import("enums/device.zig");

pub const cl_device_id = *opaque {};
pub const cl_device_local_mem_type = opencl.cl_device_local_mem_type;
const cl_platform_id = @import("platform.zig").cl_platform_id;

pub const device_partition_property = opencl.cl_device_partition_property;

pub fn get_ids(
    platform: cl_platform_id, device_type: enums.device_type,
    devices: ?[]cl_device_id, num_devices: ?*u32
) errors.opencl_error!void {
    var devices_ptr: ?[*]cl_device_id = null;
    var num_entries: u32 = 0;
    if (devices) |value| {
        devices_ptr = value.ptr;
        num_entries = @intCast(value.len);
    }

    const ret: i32 = opencl.clGetDeviceIDs(
        @ptrCast(platform), @intFromEnum(device_type), num_entries, @ptrCast(devices_ptr),
        num_devices
    );
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "invalid_value", "out_of_host_memory",
        "invalid_platform", "invalid_device_type",
        "device_not_found", "out_of_resources"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn get_info(device: cl_device_id, param_name: enums.device_info,
    param_value_size: usize, param_value: ?*anyopaque,
    param_value_size_ret: ?*usize) errors.opencl_error!void {
    const ret: i32 = opencl.clGetDeviceInfo(
        @ptrCast(device), @intFromEnum(param_name), param_value_size, param_value,
        param_value_size_ret
    );
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "invalid_value", "out_of_host_memory",
        "invalid_device", "out_of_resources"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn create_sub_devices(
    in_device: cl_device_id, properties: []const device_partition_property,
    out_devices: ?[]cl_device_id, num_devices_ret: ?*u32
) errors.opencl_error!void {
    if (cl.opencl_version < 120) @compileError("Partitioning device is missing before version 1.2");

    var out_devices_ptr: ?[*]cl_device_id = null;
    var num_devices: u32 = 0;
    if (out_devices) |v| {
        out_devices_ptr = v.ptr;
        num_devices = @intCast(v.len);
    }

    const ret: i32 = opencl.clCreateSubDevices(
        @ptrCast(in_device), properties.ptr, num_devices, @ptrCast(out_devices_ptr),
        num_devices_ret
    );
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "invalid_value", "out_of_host_memory",
        "invalid_device", "out_of_resources"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn retain(device: cl_device_id) errors.opencl_error!void {
    if (cl.opencl_version < 120) return;

    const ret: i32 = opencl.clRetainContext(@ptrCast(device));
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "out_of_host_memory", "invalid_device", "out_of_resources"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn release(device: cl_device_id) errors.opencl_error!void {
    if (cl.opencl_version < 120) return;

    const ret: i32 = opencl.clReleaseDevice(@ptrCast(device));
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{
        "out_of_host_memory", "invalid_device", "out_of_resources"
    };
    return errors.translate_opencl_error(errors_arr, ret);
}
