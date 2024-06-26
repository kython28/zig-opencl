const builtin = @import("builtin");
const std = @import("std");
const opencl_target_version = @import("opencl_config").opencl_version;

const opencl_header_file = switch (builtin.target.os.tag) {
    .macos => "OpenCL/cl.h",
    else => "CL/cl.h",
};

pub const opencl = @cImport({
    @cDefine("CL_TARGET_OPENCL_VERSION", opencl_target_version);
    @cInclude(opencl_header_file);
});

fn get_opencl_version() u16 {
    if (std.fmt.parseInt(u16, opencl_target_version, 10)) |value| {
        return value;
    } else |_| {
        unreachable;
    }
}

pub const opencl_version = get_opencl_version();
