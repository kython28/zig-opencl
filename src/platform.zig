const std = @import("std");
const cl = @import("cl.zig");
const opencl = cl.opencl;
const utils = @import("utils.zig");

const errors = @import("errors.zig");
pub const enums = @import("enums/platform.zig");

pub const cl_platform_id = *opaque {};
pub const platform_info = struct {
    id: ?cl_platform_id = null,
    profile: []u8,
    version: []u8,
    name: []u8,
    vendor: []u8,
    extensions: []u8
};

pub inline fn get_ids(platforms: ?[]cl_platform_id,
    num_platforms: ?*u32) errors.opencl_error!void {
    var platforms_ptr: ?[*]cl_platform_id = null;
    var num_entries: u32 = 0;
    if (platforms) |v| {
        platforms_ptr = v.ptr;
        num_entries = @intCast(v.len);
    }

    const ret: i32 = opencl.clGetPlatformIDs(num_entries, @ptrCast(platforms_ptr), num_platforms);
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{"invalid_value", "out_of_host_memory"};
    return errors.translate_opencl_error(errors_arr, ret);
}

pub inline fn get_info(platform: cl_platform_id, param_name: enums.platform_info,
    param_value_size: usize, param_value: ?*anyopaque,
    param_value_size_ret: ?*usize) errors.opencl_error!void {
    const ret: i32 = opencl.clGetPlatformInfo(
        @ptrCast(platform), @intFromEnum(param_name), param_value_size, param_value,
        param_value_size_ret
    );
    if (ret == opencl.CL_SUCCESS) return;

    const errors_arr = .{"invalid_value", "out_of_host_memory", "invalid_platform"};
    return errors.translate_opencl_error(errors_arr, ret);
}

pub fn get_all(allocator: std.mem.Allocator) ![]platform_info {
    var platforms: []cl_platform_id = undefined;
    var num_platforms: u32 = undefined;

    try get_ids(null, &num_platforms);
    platforms = try allocator.alloc(cl_platform_id, num_platforms);
    defer allocator.free(platforms);

    const platform_infos: []platform_info = try allocator.alloc(
        platform_info, num_platforms
    );
    for (platform_infos) |*p_info| p_info.id = null;
    errdefer release_list(allocator, platform_infos);

    try get_ids(platforms, null);
    for (platform_infos, platforms) |*p_info, p| {
        const name = try utils.get_attr_info(
            []u8, get_info, enums.platform_info.name, p, allocator
        );
        errdefer allocator.free(name);

        const extensions = try utils.get_attr_info(
            []u8, get_info, enums.platform_info.extensions, p, allocator
        );
        errdefer allocator.free(extensions);

        const vendor = try utils.get_attr_info(
            []u8, get_info, enums.platform_info.vendor, p, allocator
        );
        errdefer allocator.free(vendor);

        const version = try utils.get_attr_info(
            []u8, get_info, enums.platform_info.version, p, allocator
        );
        errdefer allocator.free(version);

        const profile = try utils.get_attr_info(
            []u8, get_info, enums.platform_info.profile, p, allocator
        );
        errdefer allocator.free(profile);

        p_info.name = name;
        p_info.vendor = vendor;
        p_info.version = version;
        p_info.profile = profile;
        p_info.extensions = extensions;
        p_info.id = p;
    }

    return platform_infos;
}

pub fn release_list(allocator: std.mem.Allocator,
    platform_infos: []platform_info) void {
    for (platform_infos) |p_info| {
        if (p_info.id == null) break;

        const fields = @typeInfo(@TypeOf(p_info)).Struct.fields;
        inline for (fields) |field| {
            if (field.type != ?cl_platform_id){
                utils.release_attr_info(field.type, allocator, @field(p_info, field.name));
            }
        }
    }
    allocator.free(platform_infos);
}
