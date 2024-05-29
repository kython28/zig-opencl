## Creating a Kernel

### Description

The `create` function creates a kernel object for a specific function declared in a program. This function ensures that the kernel is properly set up and ready to be used in OpenCL operations.

```zig
pub fn create(
    program: cl_program,
    kernel_name: []const u8
) errors.opencl_error!cl_kernel;
```

### Parameters

-   **program**: The `cl_program` object with a successfully built executable.
-   **kernel_name**: The name of the kernel function declared with the `__kernel` qualifier in the program.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clCreateKernel` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_program"`: The program is not a valid program object.
-   `"invalid_program_executable"`: There is no successfully built executable for the program.
-   `"invalid_kernel_name"`: The kernel name is not found in the program.
-   `"invalid_kernel_definition"`: The function definition for the `__kernel` function given by kernel_name does not match for all devices for which the program executable has been built.
-   `"invalid_value"`: The kernel_name is null.
-   `"out_of_resources"`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.

## Setting a Kernel Argument

### Description

The `set_arg` function sets the value of a specific argument for a kernel object. This function ensures that the kernel's argument is properly configured for execution.

```zig
pub fn set_arg(
    kernel: cl_kernel,
    arg_index: u32,
    arg_size: usize,
    arg_value: ?*const anyopaque
) errors.opencl_error!void;
```

### Parameters

-   **kernel**: A valid `cl_kernel` object.
-   **arg_index**: The argument index. Arguments to the kernel are referred to by indices that go from 0 for the leftmost argument to `n - 1`, where `n` is the total number of arguments declared by the kernel.
-   **arg_size**: Specifies the size of the argument value. If the argument is a memory object, the `arg_size` value must be equal to `sizeof(cl_mem)`. For arguments declared with the `local` qualifier, the size specified will be the size in bytes of the buffer that must be allocated for the `local` argument. If the argument is of type `sampler_t`, the `arg_size` value must be equal to `sizeof(cl_sampler)`. If the argument is of type `queue_t`, the `arg_size` value must be equal to `sizeof(cl_command_queue)`. For all other arguments, the size will be the size of the argument type.
-   **arg_value**: A pointer to data that should be used as the argument value for the argument specified by `arg_index`. The argument data pointed to by `arg_value` is copied and the `arg_value` pointer can therefore be reused by the application after `clSetKernelArg` returns. The argument value specified is the value used by all API calls that enqueue `kernel` (`clEnqueueNDRangeKernel` and `clEnqueueTask`) until the argument value is changed by a call to `clSetKernelArg` for `kernel`.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clSetKernelArg` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_kernel"`: The kernel is not a valid kernel object.
-   `"invalid_arg_index"`: The arg_index is not a valid argument index.
-   `"invalid_arg_value"`: The arg_value specified is not a valid value.
-   `"invalid_mem_object"`: For an argument declared to be a memory object, the arg_value is not a valid memory object.
-   `"invalid_sampler"`: For an argument declared to be of type sampler_t, the arg_value is not a valid sampler object.
-   `"invalid_device_queue"`: For an argument declared to be of type queue_t, the arg_value is not a valid device queue object.
-   `"invalid_arg_size"`: The arg_size does not match the size of the data type for an argument that is not a memory object or if the argument is a memory object and arg_size is not equal to `sizeof(cl_mem)` or if arg_size is zero and the argument is declared with the `local` qualifier or if the argument is a sampler and arg_size is not equal to `sizeof(cl_sampler)`.
-   `"max_size_restriction_exceeded"`: The size in bytes of the memory object exceeds a language-specified maximum size restriction for this argument, such as the `MaxByteOffset` SPIR-V decoration.
-   `"out_of_resources"`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.

## Enqueueing ND Range

### Description

The `enqueue_nd_range` function enqueues a command to execute a kernel on a device. This function allows the application to specify the dimensions and size of the global and local work-items, as well as any events to wait for and generate.

```zig
pub fn enqueue_nd_range(
    command_queue: cl_command_queue,
    kernel: cl_kernel,
    global_work_offset: ?[]const usize,
    global_work_size: []const usize,
    local_work_size: ?[]const usize,
    event_wait_list: ?[]const cl_event,
    event: ?*cl_event
) errors.opencl_error!void;
```

### Parameters

-   `command_queue`: The `cl_command_queue` in which the kernel will be queued for execution.
-   `kernel`: The `cl_kernel` object. The OpenCL context associated with `kernel` and `command_queue` must be the same.
-   `global_work_offset`: An optional array of offsets to calculate the global ID of a work-item. If `global_work_offset` is null, the global IDs start at offset (0, 0, 0).
-   `global_work_size`: An array of dimensions describing the number of global work-items. The number of global work-items is computed as `global_work_size[0] * ... * global_work_size[work_dim - 1]`.
-   `local_work_size`: An optional array of dimensions describing the number of work-items that make up a work-group. The total number of work-items in the work-group is computed as `local_work_size[0] * ... * local_work_size[work_dim - 1]`.
-   `event_wait_list`: An optional array of events that need to complete before this command can be executed. If `event_wait_list` is null, the command does not wait on any event.
-   `event`: A pointer to a `cl_event` object that identifies this command. If `event` is null, no event will be created.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clEnqueueNDRangeKernel` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_program_executable"`: No successfully built program executable available.
-   `"invalid_command_queue"`: Invalid host command-queue.
-   `"invalid_kernel"`: Invalid kernel object.
-   `"invalid_context"`: Context associated with `command_queue` and `kernel` are not the same.
-   `"invalid_kernel_args"`: Kernel argument values not specified.
-   `"invalid_work_dimension"`: Invalid work dimension.
-   `"invalid_global_work_size"`: Global work size is null or has an invalid value.
-   `"invalid_global_offset"`: Global offset is invalid.
-   `"invalid_work_group_size"`: Local work size is invalid or not consistent.
-   `"invalid_work_item_size"`: Number of work-items specified in any dimension is greater than the corresponding value specified by `CL_DEVICE_MAX_WORK_ITEM_SIZES`.
-   `"misaligned_sub_buffer_offset"`: Offset specified is not aligned.
-   `"invalid_image_size"`: Image size specified is not supported.
-   `"image_format_not_supported"`: Image format specified is not supported.
-   `"out_of_resources"`: Insufficient resources to execute the kernel.
-   `"mem_object_allocation_failure"`: Failure to allocate memory.
-   `"invalid_event_wait_list"`: Event wait list is invalid.
-   `"invalid_operation"`: Invalid operation.
-   `"out_of_host_memory"`: Failure to allocate resources on the host.

## Retaining a Kernel

### Description

The `retain` function increments the reference count of a kernel object. This function ensures that the kernel object is not released while it is still being used.

```zig
pub fn retain(kernel: cl_kernel) errors.opencl_error!void;
```

### Parameters

-   `kernel`: The `cl_kernel` object to be retained. The kernel reference count is incremented.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clRetainKernel` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_kernel"`: The kernel object is not valid.
-   `"out_of_resources"`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.

## Releasing a Kernel

### Description

The `release` function decrements the reference count of a kernel object. When the reference count becomes zero, the kernel object is deleted.

```zig
pub fn release(kernel: cl_kernel) errors.opencl_error!void;
```

### Parameters

-   `kernel`: The `cl_kernel` object to be released. The kernel reference count is decremented.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clReleaseKernel` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_kernel"`: The kernel object is not valid.
-   `"out_of_resources"`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.

