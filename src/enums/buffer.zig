const utils = @import("../utils.zig");

const map_flags_definitions: []const [:0]const u8 =  &[_][:0]const u8{
    "read", "CL_MAP_READ",
    "write", "CL_MAP_WRITE",
    "write_invalidate_region", "CL_MAP_WRITE_INVALIDATE_REGION",
};

pub const map_flags = utils.build_enum(u64, map_flags_definitions);

const mem_flags_definitions: []const [:0]const u8 =  &[_][:0]const u8{
    "read_write", "CL_MEM_READ_WRITE",
    "write_only", "CL_MEM_WRITE_ONLY",
    "read_only", "CL_MEM_READ_ONLY",
    "use_host_ptr", "CL_MEM_USE_HOST_PTR",
    "alloc_host_ptr", "CL_MEM_ALLOC_HOST_PTR",
    "copy_host_ptr", "CL_MEM_COPY_HOST_PTR",
    "host_write_only", "CL_MEM_HOST_WRITE_ONLY",
    "host_read_only", "CL_MEM_HOST_READ_ONLY",
    "host_no_access", "CL_MEM_HOST_NO_ACCESS",
    "svm_fine_grain_buffer", "CL_MEM_SVM_FINE_GRAIN_BUFFER",
    "svm_atomics", "CL_MEM_SVM_ATOMICS",
    "kernel_read_and_write", "CL_MEM_KERNEL_READ_AND_WRITE"
};

pub const mem_flags = utils.build_enum(u64, mem_flags_definitions);

const buffer_create_type_definitions: []const [:0]const u8 =  &[_][:0]const u8{
    "region", "CL_BUFFER_CREATE_TYPE_REGION"
};

pub const buffer_create_type = utils.build_enum(u32, buffer_create_type_definitions);
