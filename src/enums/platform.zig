const cl = @import("../cl.zig").opencl;

pub const PlatformInfo = enum(u32) {
    profile = cl.CL_PLATFORM_PROFILE,
    version = cl.CL_PLATFORM_VERSION,
    name = cl.CL_PLATFORM_NAME,
    vendor = cl.CL_PLATFORM_VENDOR,
    extensions = cl.CL_PLATFORM_EXTENSIONS,
};
