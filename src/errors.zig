const utils = @import("utils.zig");

const opencl_error_definitions: []const [:0]const u8 = &[_][:0]const u8{
    "device_not_found", "CL_DEVICE_NOT_FOUND",
    "device_not_available", "CL_DEVICE_NOT_AVAILABLE",
    "compiler_not_available", "CL_COMPILER_NOT_AVAILABLE",
    "mem_object_allocation_failure", "CL_MEM_OBJECT_ALLOCATION_FAILURE",
    "out_of_resources", "CL_OUT_OF_RESOURCES",
    "out_of_host_memory", "CL_OUT_OF_HOST_MEMORY",
    "profiling_info_not_available", "CL_PROFILING_INFO_NOT_AVAILABLE",
    "mem_copy_overlap", "CL_MEM_COPY_OVERLAP",
    "image_format_mismatch", "CL_IMAGE_FORMAT_MISMATCH",
    "image_format_not_supported", "CL_IMAGE_FORMAT_NOT_SUPPORTED",
    "build_program_failure", "CL_BUILD_PROGRAM_FAILURE",
    "map_failure", "CL_MAP_FAILURE",
    "misaligned_sub_buffer_offset", "CL_MISALIGNED_SUB_BUFFER_OFFSET",
    "exec_status_error_for_events_in_wait_list", "CL_EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST",
    "compile_program_failure", "CL_COMPILE_PROGRAM_FAILURE",
    "linker_not_available", "CL_LINKER_NOT_AVAILABLE",
    "link_program_failure", "CL_LINK_PROGRAM_FAILURE",
    "device_partition_failed", "CL_DEVICE_PARTITION_FAILED",
    "kernel_arg_info_not_available", "CL_KERNEL_ARG_INFO_NOT_AVAILABLE",
    "invalid_value", "CL_INVALID_VALUE",
    "invalid_device_type", "CL_INVALID_DEVICE_TYPE",
    "invalid_platform", "CL_INVALID_PLATFORM",
    "invalid_device", "CL_INVALID_DEVICE",
    "invalid_context", "CL_INVALID_CONTEXT",
    "invalid_queue_properties", "CL_INVALID_QUEUE_PROPERTIES",
    "invalid_command_queue", "CL_INVALID_COMMAND_QUEUE",
    "invalid_host_ptr", "CL_INVALID_HOST_PTR",
    "invalid_mem_object", "CL_INVALID_MEM_OBJECT",
    "invalid_image_format_descriptor", "CL_INVALID_IMAGE_FORMAT_DESCRIPTOR",
    "invalid_image_size", "CL_INVALID_IMAGE_SIZE",
    "invalid_sampler", "CL_INVALID_SAMPLER",
    "invalid_binary", "CL_INVALID_BINARY",
    "invalid_build_options", "CL_INVALID_BUILD_OPTIONS",
    "invalid_program", "CL_INVALID_PROGRAM",
    "invalid_program_executable", "CL_INVALID_PROGRAM_EXECUTABLE",
    "invalid_kernel_name", "CL_INVALID_KERNEL_NAME",
    "invalid_kernel_definition", "CL_INVALID_KERNEL_DEFINITION",
    "invalid_kernel", "CL_INVALID_KERNEL",
    "invalid_arg_index", "CL_INVALID_ARG_INDEX",
    "invalid_arg_value", "CL_INVALID_ARG_VALUE",
    "invalid_arg_size", "CL_INVALID_ARG_SIZE",
    "invalid_kernel_args", "CL_INVALID_KERNEL_ARGS",
    "invalid_work_dimension", "CL_INVALID_WORK_DIMENSION",
    "invalid_work_group_size", "CL_INVALID_WORK_GROUP_SIZE",
    "invalid_work_item_size", "CL_INVALID_WORK_ITEM_SIZE",
    "invalid_global_offset", "CL_INVALID_GLOBAL_OFFSET",
    "invalid_event_wait_list", "CL_INVALID_EVENT_WAIT_LIST",
    "invalid_event", "CL_INVALID_EVENT",
    "invalid_operation", "CL_INVALID_OPERATION",
    "invalid_gl_object", "CL_INVALID_GL_OBJECT",
    "invalid_buffer_size", "CL_INVALID_BUFFER_SIZE",
    "invalid_mip_level", "CL_INVALID_MIP_LEVEL",
    "invalid_global_work_size", "CL_INVALID_GLOBAL_WORK_SIZE",
    "invalid_property", "CL_INVALID_PROPERTY",
    "invalid_image_descriptor", "CL_INVALID_IMAGE_DESCRIPTOR",
    "invalid_compiler_options", "CL_INVALID_COMPILER_OPTIONS",
    "invalid_linker_options", "CL_INVALID_LINKER_OPTIONS",
    "invalid_device_partition_count", "CL_INVALID_DEVICE_PARTITION_COUNT",
    "invalid_pipe_size", "CL_INVALID_PIPE_SIZE",
    "invalid_device_queue", "CL_INVALID_DEVICE_QUEUE",
    "invalid_spec_id", "CL_INVALID_SPEC_ID",
    "max_size_restriction_exceeded", "CL_MAX_SIZE_RESTRICTION_EXCEEDED"
};

const opencl_error_enum = utils.build_enum(i32, opencl_error_definitions);

pub const opencl_error = utils.build_error_set(opencl_error_enum, opencl_error_definitions);

pub fn translate_opencl_error(comptime fields: anytype, error_code: i32) opencl_error {
    inline for (fields) |field| {
        if (@hasField(opencl_error_enum, field) and @intFromEnum(@field(opencl_error_enum, field)) == error_code){
            return @field(opencl_error, field);
        }
    }

    @panic("Unkwon error code");
}

