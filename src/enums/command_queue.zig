const utils = @import("../utils.zig");

const command_queue_properties_definitions: []const [:0]const u8 =  &[_][:0]const u8{
    "queue_out_of_order_exec_mode_enable", "CL_QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE",
    "queue_profiling_enable", "CL_QUEUE_PROFILING_ENABLE",
};

pub const Property = utils.buildEnum(u64, command_queue_properties_definitions);

const queue_properties_definitions: []const [:0]const u8 =  &[_][:0]const u8{
    "queue_properties", "CL_QUEUE_PROPERTIES",
    "queue_size", "CL_QUEUE_SIZE"
};

pub const QueueProperty = utils.buildEnum(u64, queue_properties_definitions);
