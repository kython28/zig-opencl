const utils = @import("../utils.zig");

const map_flags_definitions: []const [:0]const u8 =  &[_][:0]const u8{
    "map_read", "CL_MAP_READ",
    "map_write", "CL_MAP_WRITE",
    "map_write_invalidate_region", "CL_MAP_WRITE_INVALIDATE_REGION",
};

pub const map_flags = utils.build_enum(u64, map_flags_definitions);

const mem_flags_definitions: []const [:0]const u8 =  &[_][:0]const u8{
    "mem_read_write", "CL_MEM_READ_WRITE",
    "mem_write_only", "CL_MEM_WRITE_ONLY",
    "mem_read_only", "CL_MEM_READ_ONLY",
    "mem_use_host_ptr", "CL_MEM_USE_HOST_PTR",
    "mem_alloc_host_ptr", "CL_MEM_ALLOC_HOST_PTR",
    "mem_copy_host_ptr", "CL_MEM_COPY_HOST_PTR",
    "mem_host_write_only", "CL_MEM_HOST_WRITE_ONLY",
    "mem_host_read_only", "CL_MEM_HOST_READ_ONLY",
    "mem_host_no_access", "CL_MEM_HOST_NO_ACCESS",
    "mem_svm_fine_grain_buffer", "CL_MEM_SVM_FINE_GRAIN_BUFFER",
    "mem_svm_atomics", "CL_MEM_SVM_ATOMICS",
    "mem_kernel_read_and_write", "CL_MEM_KERNEL_READ_AND_WRITE"
};

pub const mem_flags = utils.build_enum(u64, mem_flags_definitions);
