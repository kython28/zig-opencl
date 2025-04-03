const utils = @import("../utils.zig");

const device_type_definitions: []const [:0]const u8 =  &[_][:0]const u8{
    "cpu", "CL_DEVICE_TYPE_CPU",
    "gpu", "CL_DEVICE_TYPE_GPU",
    "accelerator", "CL_DEVICE_TYPE_ACCELERATOR",
    "default", "CL_DEVICE_TYPE_DEFAULT",
    "all", "CL_DEVICE_TYPE_ALL",
    "custom", "CL_DEVICE_TYPE_CUSTOM"
};

pub const device_type = utils.build_enum(u32, device_type_definitions);

const device_info_definitions: []const [:0]const u8 = &[_][:0]const u8 {
    "type", "CL_DEVICE_TYPE",
    "vendor_id", "CL_DEVICE_VENDOR_ID",
    "max_compute_units", "CL_DEVICE_MAX_COMPUTE_UNITS",
    "max_work_item_dimensions", "CL_DEVICE_MAX_WORK_ITEM_DIMENSIONS",
    "max_work_group_size", "CL_DEVICE_MAX_WORK_GROUP_SIZE",
    "max_work_item_sizes", "CL_DEVICE_MAX_WORK_ITEM_SIZES",
    "preferred_vector_width_char", "CL_DEVICE_PREFERRED_VECTOR_WIDTH_CHAR",
    "preferred_vector_width_short", "CL_DEVICE_PREFERRED_VECTOR_WIDTH_SHORT",
    "preferred_vector_width_int", "CL_DEVICE_PREFERRED_VECTOR_WIDTH_INT",
    "preferred_vector_width_long", "CL_DEVICE_PREFERRED_VECTOR_WIDTH_LONG",
    "preferred_vector_width_float", "CL_DEVICE_PREFERRED_VECTOR_WIDTH_FLOAT",
    "preferred_vector_width_double", "CL_DEVICE_PREFERRED_VECTOR_WIDTH_DOUBLE",
    "max_clock_frequency", "CL_DEVICE_MAX_CLOCK_FREQUENCY",
    "address_bits", "CL_DEVICE_ADDRESS_BITS",
    "max_read_image_args", "CL_DEVICE_MAX_READ_IMAGE_ARGS",
    "max_write_image_args", "CL_DEVICE_MAX_WRITE_IMAGE_ARGS",
    "max_mem_alloc_size", "CL_DEVICE_MAX_MEM_ALLOC_SIZE",
    "image2d_max_width", "CL_DEVICE_IMAGE2D_MAX_WIDTH",
    "image2d_max_height", "CL_DEVICE_IMAGE2D_MAX_HEIGHT",
    "image3d_max_width", "CL_DEVICE_IMAGE3D_MAX_WIDTH",
    "image3d_max_height", "CL_DEVICE_IMAGE3D_MAX_HEIGHT",
    "image3d_max_depth", "CL_DEVICE_IMAGE3D_MAX_DEPTH",
    "image_support", "CL_DEVICE_IMAGE_SUPPORT",
    "max_parameter_size", "CL_DEVICE_MAX_PARAMETER_SIZE",
    "max_samplers", "CL_DEVICE_MAX_SAMPLERS",
    "mem_base_addr_align", "CL_DEVICE_MEM_BASE_ADDR_ALIGN",
    "min_data_type_align_size", "CL_DEVICE_MIN_DATA_TYPE_ALIGN_SIZE",
    "single_fp_config", "CL_DEVICE_SINGLE_FP_CONFIG",
    "global_mem_cache_type", "CL_DEVICE_GLOBAL_MEM_CACHE_TYPE",
    "global_mem_cacheline_size", "CL_DEVICE_GLOBAL_MEM_CACHELINE_SIZE",
    "global_mem_cache_size", "CL_DEVICE_GLOBAL_MEM_CACHE_SIZE",
    "global_mem_size", "CL_DEVICE_GLOBAL_MEM_SIZE",
    "max_constant_buffer_size", "CL_DEVICE_MAX_CONSTANT_BUFFER_SIZE",
    "max_constant_args", "CL_DEVICE_MAX_CONSTANT_ARGS",
    "local_mem_type", "CL_DEVICE_LOCAL_MEM_TYPE",
    "local_mem_size", "CL_DEVICE_LOCAL_MEM_SIZE",
    "error_correction_support", "CL_DEVICE_ERROR_CORRECTION_SUPPORT",
    "profiling_timer_resolution", "CL_DEVICE_PROFILING_TIMER_RESOLUTION",
    "endian_little", "CL_DEVICE_ENDIAN_LITTLE",
    "available", "CL_DEVICE_AVAILABLE",
    "compiler_available", "CL_DEVICE_COMPILER_AVAILABLE",
    "execution_capabilities", "CL_DEVICE_EXECUTION_CAPABILITIES",

    // CL_VERSION_2_0
    "queue_on_host_properties", "CL_DEVICE_QUEUE_ON_HOST_PROPERTIES",

    "name", "CL_DEVICE_NAME",
    "vendor", "CL_DEVICE_VENDOR",
    "profile", "CL_DEVICE_PROFILE",
    "version", "CL_DEVICE_VERSION",
    "extensions", "CL_DEVICE_EXTENSIONS",
    "platform", "CL_DEVICE_PLATFORM",

    // CL_VERSION_1_2
    "double_fp_config", "CL_DEVICE_DOUBLE_FP_CONFIG",

    // 0x1033 reserved for CL_DEVICE_HALF_FP_CONFIG which is already defined in "cl_ext.h"
    // CL_VERSION_1_1
    "preferred_vector_width_half", "CL_DEVICE_PREFERRED_VECTOR_WIDTH_HALF",
    "host_unified_memory", "CL_DEVICE_HOST_UNIFIED_MEMORY",
    "native_vector_width_char", "CL_DEVICE_NATIVE_VECTOR_WIDTH_CHAR",
    "native_vector_width_short", "CL_DEVICE_NATIVE_VECTOR_WIDTH_SHORT",
    "native_vector_width_int", "CL_DEVICE_NATIVE_VECTOR_WIDTH_INT",
    "native_vector_width_long", "CL_DEVICE_NATIVE_VECTOR_WIDTH_LONG",
    "native_vector_width_float", "CL_DEVICE_NATIVE_VECTOR_WIDTH_FLOAT",
    "native_vector_width_double", "CL_DEVICE_NATIVE_VECTOR_WIDTH_DOUBLE",
    "native_vector_width_half", "CL_DEVICE_NATIVE_VECTOR_WIDTH_HALF",
    "opencl_c_version", "CL_DEVICE_OPENCL_C_VERSION",

    // CL_VERSION_1_2
    "linker_available", "CL_DEVICE_LINKER_AVAILABLE",
    "built_in_kernels", "CL_DEVICE_BUILT_IN_KERNELS",
    "image_max_buffer_size", "CL_DEVICE_IMAGE_MAX_BUFFER_SIZE",
    "image_max_array_size", "CL_DEVICE_IMAGE_MAX_ARRAY_SIZE",
    "parent_device", "CL_DEVICE_PARENT_DEVICE",
    "partition_max_sub_devices", "CL_DEVICE_PARTITION_MAX_SUB_DEVICES",
    "partition_properties", "CL_DEVICE_PARTITION_PROPERTIES",
    "partition_affinity_domain", "CL_DEVICE_PARTITION_AFFINITY_DOMAIN",
    "partition_type", "CL_DEVICE_PARTITION_TYPE",
    "reference_count", "CL_DEVICE_REFERENCE_COUNT",
    "preferred_interop_user_sync", "CL_DEVICE_PREFERRED_INTEROP_USER_SYNC",
    "printf_buffer_size", "CL_DEVICE_PRINTF_BUFFER_SIZE",

    // CL_VERSION_2_0
    "image_pitch_alignment", "CL_DEVICE_IMAGE_PITCH_ALIGNMENT",
    "image_base_address_alignment", "CL_DEVICE_IMAGE_BASE_ADDRESS_ALIGNMENT",
    "max_read_write_image_args", "CL_DEVICE_MAX_READ_WRITE_IMAGE_ARGS",
    "max_global_variable_size", "CL_DEVICE_MAX_GLOBAL_VARIABLE_SIZE",
    "queue_on_device_properties", "CL_DEVICE_QUEUE_ON_DEVICE_PROPERTIES",
    "queue_on_device_preferred_size", "CL_DEVICE_QUEUE_ON_DEVICE_PREFERRED_SIZE",
    "queue_on_device_max_size", "CL_DEVICE_QUEUE_ON_DEVICE_MAX_SIZE",
    "max_on_device_queues", "CL_DEVICE_MAX_ON_DEVICE_QUEUES",
    "max_on_device_events", "CL_DEVICE_MAX_ON_DEVICE_EVENTS",
    "svm_capabilities", "CL_DEVICE_SVM_CAPABILITIES",
    "global_variable_preferred_total_size", "CL_DEVICE_GLOBAL_VARIABLE_PREFERRED_TOTAL_SIZE",
    "max_pipe_args", "CL_DEVICE_MAX_PIPE_ARGS",
    "pipe_max_active_reservations", "CL_DEVICE_PIPE_MAX_ACTIVE_RESERVATIONS",
    "pipe_max_packet_size", "CL_DEVICE_PIPE_MAX_PACKET_SIZE",
    "preferred_platform_atomic_alignment", "CL_DEVICE_PREFERRED_PLATFORM_ATOMIC_ALIGNMENT",
    "preferred_global_atomic_alignment", "CL_DEVICE_PREFERRED_GLOBAL_ATOMIC_ALIGNMENT",
    "preferred_local_atomic_alignment", "CL_DEVICE_PREFERRED_LOCAL_ATOMIC_ALIGNMENT",

    // CL_VERSION_2_1
    "il_version", "CL_DEVICE_IL_VERSION",
    "max_num_sub_groups", "CL_DEVICE_MAX_NUM_SUB_GROUPS",
    "sub_group_independent_forward_progress", "CL_DEVICE_SUB_GROUP_INDEPENDENT_FORWARD_PROGRESS",

    // CL_VERSION_3_0
    "numeric_version", "CL_DEVICE_NUMERIC_VERSION",
    "extensions_with_version", "CL_DEVICE_EXTENSIONS_WITH_VERSION",
    "ils_with_version", "CL_DEVICE_ILS_WITH_VERSION",
    "built_in_kernels_with_version", "CL_DEVICE_BUILT_IN_KERNELS_WITH_VERSION",
    "atomic_memory_capabilities", "CL_DEVICE_ATOMIC_MEMORY_CAPABILITIES",
    "atomic_fence_capabilities", "CL_DEVICE_ATOMIC_FENCE_CAPABILITIES",
    "non_uniform_work_group_support", "CL_DEVICE_NON_UNIFORM_WORK_GROUP_SUPPORT",
    "opencl_c_all_versions", "CL_DEVICE_OPENCL_C_ALL_VERSIONS",
    "preferred_work_group_size_multiple", "CL_DEVICE_PREFERRED_WORK_GROUP_SIZE_MULTIPLE",
    "work_group_collective_functions_support", "CL_DEVICE_WORK_GROUP_COLLECTIVE_FUNCTIONS_SUPPORT",
    "generic_address_space_support", "CL_DEVICE_GENERIC_ADDRESS_SPACE_SUPPORT",
    // 0x106A to 0x106E - Reserved for upcoming KHR extension
    "opencl_c_features", "CL_DEVICE_OPENCL_C_FEATURES",
    "device_enqueue_capabilities", "CL_DEVICE_DEVICE_ENQUEUE_CAPABILITIES",
    "pipe_support", "CL_DEVICE_PIPE_SUPPORT",
    "latest_conformance_version_passed", "CL_DEVICE_LATEST_CONFORMANCE_VERSION_PASSED"
};

pub const device_info = utils.build_enum(u32, device_info_definitions);

const device_partition_properties_definitions: []const [:0]const u8 = &[_][:0]const u8 {
    "partition_equally", "CL_DEVICE_PARTITION_EQUALLY",
    "partition_by_counts", "CL_DEVICE_PARTITION_BY_COUNTS",
    "partition_by_counts_list_end", "CL_DEVICE_PARTITION_BY_COUNTS_LIST_END",
    "partition_by_affinity_domain", "CL_DEVICE_PARTITION_BY_AFFINITY_DOMAIN"
};

pub const partition_property = utils.build_enum(isize, device_partition_properties_definitions);

const device_local_mem_type_definitions: []const [:0]const u8 = &[_][:0]const u8 {
    "local", "CL_LOCAL",
    "global", "CL_GLOBAL"
};

pub const local_mem_type = utils.build_enum(u32, device_local_mem_type_definitions);
