const utils = @import("../utils.zig");

const execution_status_definitions: []const [:0]const u8 =  &[_][:0]const u8{
    "complete", "CL_COMPLETE",
    "running", "CL_RUNNING",
    "submitted", "CL_SUBMITTED",
    "queued", "CL_QUEUED"
};

pub const execution_status = utils.build_enum(i32, execution_status_definitions);

