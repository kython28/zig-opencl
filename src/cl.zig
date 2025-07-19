const builtin = @import("builtin");
const std = @import("std");

const opencl_header_file = switch (builtin.target.os.tag) {
    .macos => "OpenCL/cl.h",
    else => "CL/cl.h",
};

pub const opencl = @cImport({
    @cDefine("CL_TARGET_OPENCL_VERSION", "300");
    @cInclude(opencl_header_file);
});
