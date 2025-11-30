const std = @import("std");
const cl = @import("cl.zig");
const opencl = cl.opencl;

const utils = @import("utils.zig");

const errors = @import("errors.zig");
pub const OpenCLError = errors.OpenCLError;

pub const Info = enum(u32) {
    profile = opencl.CL_PLATFORM_PROFILE,
    version = opencl.CL_PLATFORM_VERSION,
    name = opencl.CL_PLATFORM_NAME,
    vendor = opencl.CL_PLATFORM_VENDOR,
    extensions = opencl.CL_PLATFORM_EXTENSIONS,
};

pub const PlatformId = *opaque {};
pub const Details = struct {
    id: ?PlatformId = null,
    profile: []u8,
    version: []u8,
    name: []u8,
    vendor: []u8,
    extensions: []u8,
};

pub fn getIds(platforms: ?[]PlatformId, num_platforms: ?*u32) OpenCLError!void {
    var platforms_ptr: ?[*]PlatformId = null;
    var num_entries: u32 = 0;
    if (platforms) |v| {
        platforms_ptr = v.ptr;
        num_entries = @intCast(v.len);
    }

    const ret: i32 = opencl.clGetPlatformIDs(
        num_entries,
        @ptrCast(platforms_ptr),
        num_platforms,
    );
    if (ret == opencl.CL_SUCCESS) return;

    return errors.translateOpenCLError(ret);
}

pub fn getInfo(
    platform: PlatformId,
    param_name: Info,
    param_value_size: usize,
    param_value: ?*anyopaque,
    param_value_size_ret: ?*usize,
) OpenCLError!void {
    const ret: i32 = opencl.clGetPlatformInfo(
        @ptrCast(platform),
        @intFromEnum(param_name),
        param_value_size,
        param_value,
        param_value_size_ret,
    );
    if (ret == opencl.CL_SUCCESS) return;

    return errors.translateOpenCLError(ret);
}

pub fn getAll(allocator: std.mem.Allocator) ![]Details {
    var platforms: []PlatformId = undefined;
    var num_platforms: u32 = undefined;

    try getIds(null, &num_platforms);
    platforms = try allocator.alloc(PlatformId, num_platforms);
    defer allocator.free(platforms);

    const platform_infos: []Details = try allocator.alloc(
        Details,
        num_platforms,
    );
    for (platform_infos) |*p_info| p_info.id = null;
    errdefer releaseList(allocator, platform_infos);

    try getIds(platforms, null);
    for (platform_infos, platforms) |*p_info, p| {
        const name = try utils.getAttrInfo(
            []u8,
            getInfo,
            Info.name,
            p,
            allocator,
        );
        errdefer allocator.free(name);

        const extensions = try utils.getAttrInfo(
            []u8,
            getInfo,
            Info.extensions,
            p,
            allocator,
        );
        errdefer allocator.free(extensions);

        const vendor = try utils.getAttrInfo(
            []u8,
            getInfo,
            Info.vendor,
            p,
            allocator,
        );
        errdefer allocator.free(vendor);

        const version = try utils.getAttrInfo(
            []u8,
            getInfo,
            Info.version,
            p,
            allocator,
        );
        errdefer allocator.free(version);

        const profile = try utils.getAttrInfo(
            []u8,
            getInfo,
            Info.profile,
            p,
            allocator,
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

pub fn releaseList(allocator: std.mem.Allocator, platform_infos: []Details) void {
    for (platform_infos) |p_info| {
        if (p_info.id == null) break;

        const fields = @typeInfo(@TypeOf(p_info)).@"struct".fields;
        inline for (fields) |field| {
            if (field.type != ?PlatformId) {
                utils.releaseAttrInfo(
                    field.type,
                    allocator,
                    @field(p_info, field.name),
                );
            }
        }
    }
    allocator.free(platform_infos);
}
