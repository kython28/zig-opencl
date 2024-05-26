const utils = @import("../utils.zig");

const build_info_definitions: []const [:0]const u8 =  &[_][:0]const u8{
    "build_status", "CL_PROGRAM_BUILD_STATUS",
    "build_options", "CL_PROGRAM_BUILD_OPTIONS",
    "build_log", "CL_PROGRAM_BUILD_LOG",
    "binary_type", "CL_PROGRAM_BINARY_TYPE",
    "build_global_variable_total_size", "CL_PROGRAM_BUILD_GLOBAL_VARIABLE_TOTAL_SIZE",
};

pub const build_info = utils.build_enum(u32, build_info_definitions);
