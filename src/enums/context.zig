const utils = @import("../utils.zig");

const context_properties_definitions: []const [:0]const u8 = &[_][:0]const u8 {
    "platform", "CL_CONTEXT_PLATFORM",
    "interop_user_sync", "CL_CONTEXT_INTEROP_USER_SYNC",
};

pub const context_properties = utils.build_enum(isize, context_properties_definitions);

const context_info_definitions: []const [:0]const u8 = &[_][:0]const u8 {
    "reference_count", "CL_CONTEXT_REFERENCE_COUNT",
    "devices", "CL_CONTEXT_DEVICES",
    "properties", "CL_CONTEXT_PROPERTIES",
    "num_devices", "CL_CONTEXT_NUM_DEVICES"
};

pub const context_info = utils.build_enum(u32, context_properties_definitions);
